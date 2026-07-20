import { readdirSync, readFileSync } from "node:fs";
import { createHash } from "node:crypto";
import { join, relative, resolve } from "node:path";

type Json = null | boolean | number | string | Json[] | { [key: string]: Json };
type RecordJson = { [key: string]: Json };

const EVAL_ROOT = resolve(import.meta.dir, "..");
const CASE_ROOT = join(EVAL_ROOT, "cases");
const CONTRACT_ROOT = resolve(EVAL_ROOT, "../../../contracts/orchestrator-state");
const TRACE_ROOT_FLAG = process.argv.indexOf("--trace-root");
const TRACE_ROOT = TRACE_ROOT_FLAG === -1 ? null : resolve(process.argv[TRACE_ROOT_FLAG + 1] ?? fail("--trace-root requires a directory"));
const PROVENANCE_FLAG = process.argv.indexOf("--provenance-manifest");
const PROVENANCE_PATH = PROVENANCE_FLAG === -1 ? null : resolve(process.argv[PROVENANCE_FLAG + 1] ?? fail("--provenance-manifest requires a file"));
const ZULU = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z$/;
const CLASSIFICATIONS = new Set(["expected", "known-defect", "must-change"]);
const REASONING_TIERS = new Set(["low", "medium", "high"]);
const NONDETERMINISTIC_NORMALIZATION_KEYS = new Set(["traceId", "recordedAt", "attemptId"]);
const EVENT_TYPES = new Set([
  "run.created", "run.status_changed", "run.completed", "run.failed",
  "phase.started", "phase.status_changed", "phase.completed", "agent.spawned",
  "agent.status_changed", "agent.reported", "decision.recorded", "blocker.opened",
  "blocker.resolved", "artifact.created", "artifact.updated", "checkpoint.created",
  "review.finding_opened", "review.finding_resolved", "validation.started",
  "validation.passed", "validation.failed", "note.added",
]);
let activeEvidenceMode = "synthetic-specification";

function fail(message: string): never {
  throw new Error(message);
}

function object(value: Json, label: string): RecordJson {
  if (value === null || Array.isArray(value) || typeof value !== "object") fail(`${label} must be an object`);
  return value as RecordJson;
}

function array(value: Json | undefined, label: string): Json[] {
  if (!Array.isArray(value)) fail(`${label} must be an array`);
  return value;
}

function string(value: Json | undefined, label: string): string {
  if (typeof value !== "string" || value.length === 0) fail(`${label} must be a non-empty string`);
  return value;
}

function readJson(path: string): RecordJson {
  try {
    return object(JSON.parse(readFileSync(path, "utf8")) as Json, relative(EVAL_ROOT, path));
  } catch (error) {
    fail(`cannot parse ${relative(EVAL_ROOT, path)}: ${error instanceof Error ? error.message : String(error)}`);
  }
}

function readJsonl(path: string): RecordJson[] {
  return readFileSync(path, "utf8").trim().split("\n").filter(Boolean).map((line, index) => {
    try {
      return object(JSON.parse(line) as Json, `${relative(EVAL_ROOT, path)}:${index + 1}`);
    } catch (error) {
      fail(`cannot parse ${relative(EVAL_ROOT, path)}:${index + 1}: ${error instanceof Error ? error.message : String(error)}`);
    }
  });
}

function stable(value: Json): string {
  if (Array.isArray(value)) return `[${value.map(stable).join(",")}]`;
  if (value !== null && typeof value === "object") {
    return `{${Object.keys(value).sort().map((key) => `${JSON.stringify(key)}:${stable((value as RecordJson)[key])}`).join(",")}}`;
  }
  return JSON.stringify(value);
}

function digest(value: string): string {
  return `sha256:${createHash("sha256").update(value, "utf8").digest("hex")}`;
}

function assertIJson(value: Json, label: string): void {
  if (typeof value === "number" && !Number.isFinite(value)) fail(`${label}: non-finite JSON number`);
  if (typeof value === "string" && /[\uD800-\uDFFF]/u.test(value)) {
    for (let index = 0; index < value.length; index += 1) {
      const unit = value.charCodeAt(index);
      if (unit >= 0xD800 && unit <= 0xDBFF) {
        const next = value.charCodeAt(index + 1);
        if (next < 0xDC00 || next > 0xDFFF) fail(`${label}: lone high surrogate`);
        index += 1;
      } else if (unit >= 0xDC00 && unit <= 0xDFFF) fail(`${label}: lone low surrogate`);
    }
  }
  if (Array.isArray(value)) value.forEach((item, index) => assertIJson(item, `${label}[${index}]`));
  if (value !== null && typeof value === "object" && !Array.isArray(value)) {
    for (const [key, item] of Object.entries(value)) {
      assertIJson(key, `${label}.key`);
      assertIJson(item, `${label}.${key}`);
    }
  }
}

function canonicalApprovalDigest(approval: RecordJson): string {
  const withoutDigest = Object.fromEntries(Object.entries(approval).filter(([key]) => key !== "digest")) as RecordJson;
  assertIJson(withoutDigest, "approval");
  return digest(stable(withoutDigest));
}

function isAdjudicableRouteEvidence(source: string): boolean {
  return activeEvidenceMode === "live-host-capture" ? source.startsWith("host-") : source.startsWith("synthetic-host-");
}

function normalize(value: Json, keys: Set<string>): Json {
  if (Array.isArray(value)) return value.map((item) => normalize(item, keys));
  if (value !== null && typeof value === "object") {
    return Object.fromEntries(Object.entries(value).filter(([key]) => !keys.has(key)).map(([key, item]) => [key, normalize(item, keys)]));
  }
  return value;
}

function valuesByPath(value: Json, path: string): Json[] {
  const segments = path.split(".").filter(Boolean);
  let current: Json[] = [value];
  for (const segment of segments) {
    current = current.flatMap((item) => {
      if (Array.isArray(item)) return item.flatMap((child) => segment === "*" ? [child] : []);
      if (item !== null && typeof item === "object" && segment in item) return [(item as RecordJson)[segment]];
      return [];
    });
  }
  return current;
}

function actionTypes(trace: RecordJson): string[] {
  return array(trace.actions, "trace.actions").map((action, index) => string(object(action, `trace.actions[${index}]`).type, `trace.actions[${index}].type`));
}

function assertExpected(caseId: string, fixture: RecordJson, trace: RecordJson): void {
  const expected = object(fixture.expected, `${caseId}.expected`);
  const traceQuestions = new Set(array(trace.questions, `${caseId}.trace.questions`).map((question, index) => string(object(question, `${caseId}.question[${index}]`).id, `${caseId}.question[${index}].id`)));
  const traceEvents = new Set(array(trace.events, `${caseId}.trace.events`).map((event, index) => string(object(event, `${caseId}.event[${index}]`).type, `${caseId}.event[${index}].type`)));
  const traceActions = new Set(actionTypes(trace));
  const expectedQuestions = new Set(array(expected.questions, `${caseId}.expected.questions`).map((id) => string(id, `${caseId}.expected.questions[]`)));
  const expectedEvents = new Set(array(expected.events, `${caseId}.expected.events`).map((type) => string(type, `${caseId}.expected.events[]`)));
  const expectedActions = new Set(array(expected.actions, `${caseId}.expected.actions`).map((type) => string(type, `${caseId}.expected.actions[]`)));
  for (const id of expectedQuestions) if (!traceQuestions.has(id)) fail(`${caseId}: missing expected question ${id}`);
  for (const type of expectedEvents) if (!traceEvents.has(type)) fail(`${caseId}: missing expected event ${type}`);
  for (const type of expectedActions) if (!traceActions.has(type)) fail(`${caseId}: missing expected action ${type}`);
  for (const id of traceQuestions) if (!expectedQuestions.has(id)) fail(`${caseId}: unexpected question ${id}`);
  for (const type of traceEvents) if (!expectedEvents.has(type)) fail(`${caseId}: unexpected event ${type}`);
  for (const type of traceActions) if (!expectedActions.has(type)) fail(`${caseId}: unexpected action ${type}`);
  for (const type of array(fixture.forbiddenActions, `${caseId}.forbiddenActions`)) if (traceActions.has(string(type, `${caseId}.forbiddenActions[]`))) fail(`${caseId}: forbidden action ${type} occurred`);
}

function assertFixtureContext(caseId: string, fixture: RecordJson, trace: RecordJson): void {
  const input = object(fixture.input, `${caseId}.input`);
  const capabilities = object(fixture.hostCapabilities, `${caseId}.hostCapabilities`);
  if (Object.keys(input).length === 0) fail(`${caseId}: input must describe the replay request`);
  const host = string(capabilities.host, `${caseId}.hostCapabilities.host`);
  const routing = valuesByPath(trace, "routing.*").map((item, index) => object(item, `${caseId}.routing[${index}]`));
  for (const entry of routing) {
    const actual = object(entry.actual, `${caseId}.actual`);
    if (actual.host !== host) fail(`${caseId}: actual host does not match the capability fixture`);
  }
  if ("complexity" in input) {
    const reasoning = object(trace.reasoning, `${caseId}.reasoning`);
    const complexity = object(reasoning.complexity, `${caseId}.reasoning.complexity`);
    if (complexity.tier !== input.complexity) fail(`${caseId}: trace complexity does not match the replay input`);
    if (reasoning.capabilityStatus !== capabilities.reasoningSelection) fail(`${caseId}: reasoning capability status does not match host capabilities`);
  }
}

function assertStructural(caseId: string, assertions: Json[], trace: RecordJson): void {
  for (const assertion of assertions) {
    const rule = string(object(assertion, `${caseId}.structuralAssertion`).rule, `${caseId}.structuralAssertion.rule`);
    const actions = actionTypes(trace);
    const routing = valuesByPath(trace, "routing.*").map((item, index) => object(item, `${caseId}.routing[${index}]`));
    if (rule === "routing-requested-and-actual-separated") {
      if (routing.length === 0) fail(`${caseId}: routing evidence is missing`);
      for (const entry of routing) {
        const requested = object(entry.requested, `${caseId}.requested`);
        const actual = object(entry.actual, `${caseId}.actual`);
        const evidenceSource = string(actual.evidenceSource, `${caseId}.actual.evidenceSource`);
        if (stable(requested) === stable(actual)) fail(`${caseId}: requested and actual evidence are semantically identical`);
        for (const field of ["model", "reasoning", "reasoningTier", "historyMode"]) {
          if (field in requested && field in actual && actual[field] !== "unknown" && stable(requested[field]) === stable(actual[field]) && !isAdjudicableRouteEvidence(evidenceSource)) {
            fail(`${caseId}: ${field} copied from requested without host evidence`);
          }
        }
      }
    } else if (rule === "no-history-dispatch-evidence") {
      if (routing.some((entry) => object(entry.actual, `${caseId}.actual`).historyMode !== "none")) fail(`${caseId}: no-history route evidence is missing`);
    } else if (rule === "foreground-or-blocker-on-permission") {
      if (!actions.includes("foreground-retry") && !actions.includes("open-blocker")) fail(`${caseId}: permission failure needs foreground retry or blocker`);
    } else if (rule === "metadata-does-not-authorize") {
      if (!actions.includes("deny-action") || actions.includes("push") || actions.includes("edit")) fail(`${caseId}: metadata-only authorization must deny mutation`);
    } else if (rule === "review-missing-context-cannot-verify") {
      if (!actions.includes("return-cannot-verify") || actions.includes("approve-review")) fail(`${caseId}: review missing context must not approve`);
    } else if (rule === "mr-owned-by-merge-request-skill") {
      if (!actions.includes("handoff-to-merge-request-skill") || actions.includes("create-mr")) fail(`${caseId}: orchestrator must hand off MR creation`);
    } else if (rule === "follow-up-has-fresh-cycle") {
      if (!actions.includes("reclassify-risk") || valuesByPath(trace, "state.metadata.cycle").length !== 1) fail(`${caseId}: follow-up requires a new cycle and risk classification`);
    } else if (rule === "compaction-reopens-state-before-work") {
      if (!actions.includes("reopen-state") || !actions.includes("append-resume-event")) fail(`${caseId}: compaction resume must reopen state and append evidence`);
    } else if (rule === "browser-unavailable-is-blocked-risk") {
      if (!actions.includes("record-browser-unavailable") || !actions.includes("open-blocker")) fail(`${caseId}: unavailable browser must remain explicit residual risk`);
    } else if (rule === "delivery-declined-stops-delivery") {
      if (!actions.includes("record-delivery-declined") || actions.some((action) => ["stage", "commit", "push", "create-mr"].includes(action))) fail(`${caseId}: declined delivery must stop delivery actions`);
    } else if (rule === "known-defect-is-not-approved") {
      if (new Set(["approved", "production-pass", "live-pass"]).has(String(object(trace.adjudication, `${caseId}.adjudication`).status))) fail(`${caseId}: known defect cannot claim production approval`);
    } else if (rule === "must-change-is-not-production-pass") {
      if (object(trace.adjudication, `${caseId}.adjudication`).status === "production-pass") fail(`${caseId}: must-change behavior cannot claim production pass`);
    } else if (rule === "native-or-flat-graph-is-explicit") {
      if (!actions.includes("dispatch-lead") || !actions.some((action) => action === "dispatch-child" || action === "flatten-to-root")) fail(`${caseId}: routing graph fallback is not explicit`);
    } else if (rule === "claude-flat-named-subagents") {
      if (!actions.includes("root-dispatch-flat-named-subagent") || actions.includes("lead-spawn-child")) fail(`${caseId}: Claude Code must use flat named-subagent dispatch`);
    } else if (rule === "adaptive-reasoning-evidence") {
      const reasoning = object(trace.reasoning, `${caseId}.reasoning`);
      const complexity = object(reasoning.complexity, `${caseId}.reasoning.complexity`);
      const requested = object(reasoning.requested, `${caseId}.reasoning.requested`);
      const translation = object(reasoning.translation, `${caseId}.reasoning.translation`);
      const actual = object(reasoning.actual, `${caseId}.reasoning.actual`);
      const tier = string(complexity.tier, `${caseId}.reasoning.complexity.tier`);
      const requestedTier = string(requested.reasoningTier, `${caseId}.reasoning.requested.reasoningTier`);
      if (!REASONING_TIERS.has(tier) || !REASONING_TIERS.has(requestedTier)) fail(`${caseId}: invalid canonical complexity/reasoning tier`);
      if (array(complexity.signals, `${caseId}.reasoning.complexity.signals`).length === 0) fail(`${caseId}: complexity signals are missing`);
      string(requested.reasoningHostValue, `${caseId}.reasoning.requested.reasoningHostValue`);
      string(translation.mechanism, `${caseId}.reasoning.translation.mechanism`);
      string(translation.mappingEvidenceSource, `${caseId}.reasoning.translation.mappingEvidenceSource`);
      const mappingScope = object(translation.mappingScope, `${caseId}.reasoning.translation.mappingScope`);
      string(mappingScope.host, `${caseId}.reasoning.translation.mappingScope.host`);
      string(mappingScope.hostVersion, `${caseId}.reasoning.translation.mappingScope.hostVersion`);
      string(mappingScope.model, `${caseId}.reasoning.translation.mappingScope.model`);
      if (!ZULU.test(string(translation.observedAt, `${caseId}.reasoning.translation.observedAt`))) fail(`${caseId}: translation mapping timestamp must be UTC/Zulu`);
      string(actual.reasoningTier, `${caseId}.reasoning.actual.reasoningTier`);
      string(actual.hostValue, `${caseId}.reasoning.actual.hostValue`);
      string(reasoning.evidenceSource, `${caseId}.reasoning.evidenceSource`);
      if (!("fallbackReason" in reasoning)) fail(`${caseId}: fallbackReason must be persisted even when null`);
    } else if (rule === "reasoning-supported-translation") {
      const reasoning = object(trace.reasoning, `${caseId}.reasoning`);
      const actual = object(reasoning.actual, `${caseId}.reasoning.actual`);
      if (reasoning.capabilityStatus !== "supported" || reasoning.applicationStatus !== "observed" || actual.reasoningTier === "unknown" || actual.hostValue === "unknown" || !isAdjudicableRouteEvidence(string(reasoning.evidenceSource, `${caseId}.reasoning.evidenceSource`))) fail(`${caseId}: supported reasoning case lacks evidence appropriate to its declared provenance`);
      if (reasoning.fallbackReason !== null) fail(`${caseId}: supported observed translation must not claim a fallback`);
    } else if (rule === "reasoning-supported-unobservable") {
      const reasoning = object(trace.reasoning, `${caseId}.reasoning`);
      const actual = object(reasoning.actual, `${caseId}.reasoning.actual`);
      if (reasoning.capabilityStatus !== "supported" || reasoning.applicationStatus !== "unobservable") fail(`${caseId}: case must separate supported selector from unobservable application`);
      if (actual.reasoningTier !== "unknown" || actual.hostValue !== "unknown") fail(`${caseId}: unobservable application must keep actual reasoning unknown`);
      if (!string(reasoning.fallbackReason, `${caseId}.reasoning.fallbackReason`).includes("application-unobservable")) fail(`${caseId}: unobservable application fallback reason is missing`);
      if (!actions.includes("record-reasoning-unobservable")) fail(`${caseId}: unobservable application action is missing`);
    } else if (rule === "reasoning-degraded-fallback") {
      const reasoning = object(trace.reasoning, `${caseId}.reasoning`);
      const actual = object(reasoning.actual, `${caseId}.reasoning.actual`);
      if (!new Set(["unsupported", "unknown"]).has(String(reasoning.capabilityStatus))) fail(`${caseId}: degraded reasoning case needs unsupported or unknown capability`);
      if (reasoning.applicationStatus !== "not-requested") fail(`${caseId}: unsupported/unknown selector must not claim application`);
      if (actual.reasoningTier !== "unknown" || actual.hostValue !== "unknown") fail(`${caseId}: degraded reasoning cannot fabricate actual values`);
      string(reasoning.fallbackReason, `${caseId}.reasoning.fallbackReason`);
      if (!actions.includes("record-reasoning-fallback")) fail(`${caseId}: degraded reasoning fallback action is missing`);
    } else if (rule === "reasoning-resume-revalidated") {
      const revalidation = object(object(trace.reasoning, `${caseId}.reasoning`).revalidation, `${caseId}.reasoning.revalidation`);
      if (revalidation.reason !== "resume" || !ZULU.test(String(revalidation.previousObservedAt)) || !ZULU.test(String(revalidation.observedAt))) fail(`${caseId}: resume reasoning revalidation evidence is incomplete`);
      if (!actions.includes("reclassify-complexity") || !actions.includes("revalidate-reasoning")) fail(`${caseId}: resume must reclassify and revalidate reasoning`);
    } else if (rule === "reasoning-permission-orthogonal") {
      const routingEntry = routing[0];
      if (!routingEntry) fail(`${caseId}: routing evidence is missing`);
      const execution = object(routingEntry.execution, `${caseId}.routing.execution`);
      if (execution.requested !== "background" || execution.actual !== "foreground" || !actions.includes("foreground-retry")) fail(`${caseId}: permission-sensitive work needs an independent foreground fallback`);
      if (actions.includes("reasoning-upgrade-for-permission") || actions.includes("reasoning-downgrade-for-permission")) fail(`${caseId}: permission fallback must not mutate reasoning tier`);
    } else {
      fail(`${caseId}: unknown structural rule ${rule}`);
    }
  }
}

function validateStateFixture(path: string, expectedValid: boolean): void {
  const state = readJson(path);
  const required = ["schemaVersion", "runId", "workspaceRoot", "host", "createdAt", "updatedAt", "status", "currentPhaseId", "agents", "edges", "phases", "blockers", "artifacts", "checkpoints"];
  const errors: string[] = [];
  if (state.schemaVersion !== "1.0.0") errors.push("schemaVersion");
  if (!ZULU.test(String(state.createdAt)) || !ZULU.test(String(state.updatedAt))) errors.push("timestamps");
  if (!required.every((key) => key in state)) errors.push("required fields");
  if (!Array.isArray(state.edges)) errors.push("edges array");
  else for (const edge of state.edges) {
    const entry = object(edge, "state edge");
    if (typeof entry.relation !== "string") errors.push("edge.relation");
    if ("type" in entry) errors.push("edge.type is not allowed");
  }
  if (expectedValid ? errors.length > 0 : errors.length === 0) fail(`${relative(EVAL_ROOT, path)} validation expectation failed: ${errors.join(", ") || "no error"}`);
}

function validateEventsFixture(path: string): void {
  for (const [index, event] of readJsonl(path).entries()) {
    const required = ["schemaVersion", "eventId", "runId", "timestamp", "type", "actorAgentId", "phaseId", "agentId", "severity", "message", "data", "artifactRefs"];
    if (!required.every((key) => key in event) || event.schemaVersion !== "1.0.0" || !ZULU.test(String(event.timestamp)) || !EVENT_TYPES.has(String(event.type))) fail(`${relative(EVAL_ROOT, path)}:${index + 1} is not a valid 1.0.0 event fixture`);
  }
}

function validateApprovalReplay(): number {
  const scenarioPath = join(EVAL_ROOT, "fixtures/authorization/scenarios.json");
  const scenarios = JSON.parse(readFileSync(scenarioPath, "utf8")) as Json;
  const list = array(scenarios, "authorization scenarios");

  for (const [index, item] of list.entries()) {
    const scenario = object(item, `authorization[${index}]`);
    const scenarioId = string(scenario.id, `authorization[${index}].id`);
    const active = new Map<string, RecordJson>();
    let invalidChain = false;

    for (const decisionValue of array(scenario.decisions, `${scenarioId}.decisions`)) {
      const decision = object(decisionValue, `${scenarioId}.decision`);
      const operation = string(decision.operation, `${scenarioId}.operation`);
      const approvalId = string(decision.approvalId, `${scenarioId}.approvalId`);
      string(decision.digest, `${scenarioId}.digest`);
      if (operation === "grant") {
        active.set(approvalId, decision);
      } else if (operation === "supersede") {
        const targetId = string(decision.supersedesApprovalId, `${scenarioId}.supersedesApprovalId`);
        const targetDigest = string(decision.supersedesApprovalDigest, `${scenarioId}.supersedesApprovalDigest`);
        const target = active.get(targetId);
        if (!target || target.digest !== targetDigest) invalidChain = true;
        else active.delete(targetId);
        active.set(approvalId, decision);
      } else if (operation === "revoke") {
        const targetId = string(decision.revokesApprovalId, `${scenarioId}.revokesApprovalId`);
        const targetDigest = string(decision.revokesApprovalDigest, `${scenarioId}.revokesApprovalDigest`);
        string(decision.reason, `${scenarioId}.reason`);
        const target = active.get(targetId);
        if (!target || target.digest !== targetDigest) invalidChain = true;
        else active.delete(targetId);
      } else {
        fail(`${scenarioId}: unsupported approval operation ${operation}`);
      }
    }

    const request = object(scenario.request, `${scenarioId}.request`);
    const approval = active.get(string(request.approvalId, `${scenarioId}.request.approvalId`));
    let result = "deny";
    if (!invalidChain && approval) {
      const actions = array(approval.actions, `${scenarioId}.approval.actions`).map((value) => string(value, `${scenarioId}.approval.actions[]`));
      const inScope = approval.scope === request.scope;
      const actionAllowed = actions.includes(string(request.action, `${scenarioId}.request.action`));
      const expiresAt = approval.expiresAt;
      const unexpired = approval.noExpiry === true || (typeof expiresAt === "string" && Date.parse(expiresAt) > Date.parse(string(request.at, `${scenarioId}.request.at`)));
      const hostMatches = approval.provenanceHost === request.host || request.crossHostRevalidated === true;
      if (inScope && actionAllowed && unexpired && hostMatches) result = "allow";
    }
    if (result !== scenario.expected) fail(`${scenarioId}: expected ${scenario.expected}, got ${result}`);
  }
  return list.length;
}

function validateCanonicalApprovalEvents(): number {
  const path = join(CONTRACT_ROOT, "examples/codex/events.jsonl");
  const approvals = readJsonl(path)
    .map((event) => event.data)
    .filter((data): data is RecordJson => data !== null && !Array.isArray(data) && typeof data === "object" && "approval" in data && data.approval !== null && !Array.isArray(data.approval) && typeof data.approval === "object")
    .map((data, index) => object(data.approval, `contract approval[${index}]`));
  const byId = new Map<string, RecordJson>();
  for (const approval of approvals) {
    const approvalId = string(approval.approvalId, "contract approval id");
    const expectedDigest = string(approval.digest, `${approvalId}.digest`);
    if (canonicalApprovalDigest(approval) !== expectedDigest) fail(`${approvalId}: approval digest mismatch`);
    const operation = string(approval.operation, `${approvalId}.operation`);
    if (operation === "supersede") {
      const target = byId.get(string(approval.supersedesApprovalId, `${approvalId}.supersedesApprovalId`));
      if (!target || target.digest !== approval.supersedesApprovalDigest) fail(`${approvalId}: supersede target id/digest mismatch`);
    }
    if (operation === "revoke") {
      const target = byId.get(string(approval.revokesApprovalId, `${approvalId}.revokesApprovalId`));
      string(approval.reason, `${approvalId}.reason`);
      if (!target || target.digest !== approval.revokesApprovalDigest) fail(`${approvalId}: revoke target id/digest mismatch`);
    }
    byId.set(approvalId, approval);
  }
  return approvals.length;
}

function validateCanonicalApprovalAlgorithm(): number {
  const left: RecordJson = { digest: "sha256:ignored", z: "last", a: { y: [1, 2], x: "first" } };
  const reordered: RecordJson = { a: { x: "first", y: [1, 2] }, z: "last", digest: "sha256:also-ignored" };
  if (canonicalApprovalDigest(left) !== canonicalApprovalDigest(reordered)) fail("canonical approval digest depends on object insertion order or embedded top-level digest");
  if (canonicalApprovalDigest({ text: "é" }) === canonicalApprovalDigest({ text: "e\u0301" })) fail("canonical approval digest must not normalize Unicode");
  if (canonicalApprovalDigest({ values: [1, 2] }) === canonicalApprovalDigest({ values: [2, 1] })) fail("canonical approval digest must preserve array order");
  if (canonicalApprovalDigest({ nested: { digest: "one" } }) === canonicalApprovalDigest({ nested: { digest: "two" } })) fail("canonical approval digest must omit only the top-level digest member");
  return 4;
}

function validateRoutingNegativeControl(): void {
  const copiedActual: RecordJson = {
    routing: [{
      requested: { model: "requested-value" },
      actual: { host: "codex", model: "requested-value", evidenceSource: "unavailable" },
    }],
  };
  let rejected = false;
  try {
    assertStructural("routing-negative-control", [{ rule: "routing-requested-and-actual-separated" }], copiedActual);
  } catch {
    rejected = true;
  }
  if (!rejected) fail("routing negative control did not reject copied requested-as-actual evidence");
}

const cases = readdirSync(CASE_ROOT).filter((name) => name.endsWith(".json")).sort();
const goldenDigests = readJson(join(EVAL_ROOT, "rubrics/golden-digests.json"));
if ((TRACE_ROOT === null) !== (PROVENANCE_PATH === null)) fail("--trace-root and --provenance-manifest must be supplied together");
const provenance = PROVENANCE_PATH === null ? null : readJson(PROVENANCE_PATH);
if (provenance !== null) {
  const kind = string(provenance.kind, "provenance.kind");
  if (!new Set(["synthetic-replay", "live-host-capture"]).has(kind)) fail(`unsupported provenance kind ${kind}`);
  activeEvidenceMode = kind;
  if (!ZULU.test(string(provenance.createdAt, "provenance.createdAt"))) fail("provenance.createdAt must be UTC/Zulu");
  const traceIds = new Set(array(provenance.traceIds, "provenance.traceIds").map((id) => string(id, "provenance.traceIds[]")));
  for (const name of cases) {
    const fixture = readJson(join(CASE_ROOT, name));
    if (!traceIds.has(string(fixture.id, `${name}.id`))) fail(`${name}: external trace provenance entry is missing`);
  }
  if (kind === "live-host-capture") {
    string(provenance.captureTool, "provenance.captureTool");
    if (array(provenance.hostRuns, "provenance.hostRuns").length === 0) fail("live provenance needs hostRuns");
    const traces = object(provenance.traces, "provenance.traces");
    for (const id of traceIds) {
      const entry = object(traces[id], `provenance.traces.${id}`);
      string(entry.host, `provenance.traces.${id}.host`);
      if (!ZULU.test(string(entry.capturedAt, `provenance.traces.${id}.capturedAt`))) fail(`${id}: live capture timestamp must be UTC/Zulu`);
      string(entry.evidenceSource, `provenance.traces.${id}.evidenceSource`);
    }
  }
}
let expected = 0;
let knownDefect = 0;
let mustChange = 0;
for (const name of cases) {
  const fixture = readJson(join(CASE_ROOT, name));
  const id = string(fixture.id, `${name}.id`);
  const classification = string(fixture.classification, `${id}.classification`);
  if (!CLASSIFICATIONS.has(classification)) fail(`${id}: invalid classification ${classification}`);
  const goldenRelative = string(fixture.golden, `${id}.golden`);
  const tracePath = join(TRACE_ROOT ?? EVAL_ROOT, goldenRelative);
  const trace = readJson(tracePath);
  assertFixtureContext(id, fixture, trace);
  assertExpected(id, fixture, trace);
  const normalizeKeys = new Set(array(fixture.normalization, `${id}.normalization`).map((key) => string(key, `${id}.normalization[]`)));
  for (const key of normalizeKeys) if (!NONDETERMINISTIC_NORMALIZATION_KEYS.has(key)) fail(`${id}: cannot normalize evidence-bearing key ${key}`);
  const normalizedOnce = stable(normalize(trace, normalizeKeys));
  const expectedDigest = string(goldenDigests[id], `${id}.goldenDigest`);
  if (digest(normalizedOnce) !== expectedDigest) fail(`${id}: normalized trace differs from the independently stored golden digest`);
  assertStructural(id, array(fixture.structuralAssertions, `${id}.structuralAssertions`), trace);
  if (classification === "expected") expected += 1;
  if (classification === "known-defect") knownDefect += 1;
  if (classification === "must-change") mustChange += 1;
}
validateStateFixture(join(EVAL_ROOT, "fixtures/state/valid-state-1.0.json"), true);
validateStateFixture(join(EVAL_ROOT, "fixtures/state/synthetic-invalid-edge-type-1.0.json"), false);
validateEventsFixture(join(EVAL_ROOT, "fixtures/state/valid-events-1.0.jsonl"));
const authorizationScenarios = validateApprovalReplay();
const canonicalApprovalEvents = validateCanonicalApprovalEvents();
const canonicalAlgorithmVectors = validateCanonicalApprovalAlgorithm();
validateRoutingNegativeControl();

console.log(stable({
  status: "passed",
  cases: cases.length,
  classification: { expected, "known-defect": knownDefect, "must-change": mustChange },
  contractFixtures: { validState: "passed", invalidEdgeType: "rejected", validEvents: "passed" },
  authorization: { scenarios: authorizationScenarios, canonicalEvents: canonicalApprovalEvents, canonicalAlgorithmVectors, semanticReplay: "passed" },
  negativeControls: { copiedRequestedAsActual: "rejected" },
  structuralAssertions: "passed",
  evidenceMode: activeEvidenceMode,
  liveHostEvidence: activeEvidenceMode === "live-host-capture",
  traceSource: TRACE_ROOT === null ? "checked-in-synthetic-specification" : "external-trace-root",
  snapshotOnly: false,
}));
