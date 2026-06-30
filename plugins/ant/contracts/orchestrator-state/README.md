# Orchestrator State Contract

This contract defines the machine-readable state files written under:

```text
.ant/orchestrator/<run-id>/state.json
.ant/orchestrator/<run-id>/events.jsonl
```

Markdown files remain the human resume and handoff layer. Tools should use `state.json` and `events.jsonl` as the primary source for dashboards, automation, and validation. If markdown text conflicts with `state.json`, the markdown is stale.

Human-readable `decisions.md` files must also preserve timing for new user choices: every new user decision entry should include a full UTC/Zulu timestamp, for example `2026-05-26T14:03:12Z`, instead of a date-only prefix. Existing historical date-only decisions should not be guessed or rewritten unless the exact timestamp is known from `events.jsonl` or another durable source.

## Markdown Resume Layer

The recommended markdown surface is intentionally small:

- `state.md`: current human summary of the run.
- `decisions.md`: user decisions with UTC/Zulu timestamps.
- `rationale.md`: durable summaries of material decisions, options considered, rejected alternatives, evidence, tradeoffs, reviewer focus, and accepted or deferred risk.
- `handoff.md`: next safe action and resume instructions.
- `phases/<phase>/phase.md`: concise phase resume.
- `phases/<phase>/rationale.md`: phase-local rationale checkpoints when material choices, rejected alternatives, or risk acceptance occurred.
- `phases/<phase>/review.md`: final review findings and residual risk.
- `phases/<phase>/verification.md`: final validation evidence.
- `phases/05-planning/implementation-plan.md`: approved plan for medium+ implementation work.

Subphase and worker markdown files are archive evidence after closure. Consumers should keep them available, but should not treat them as the default control-center view.

New markdown artifacts should include front matter when practical:

```yaml
---
type: phase
phaseId: 06-implementation
agentId: implementation-lead
status: completed
createdAt: 2026-05-26T12:00:00Z
updatedAt: 2026-05-26T14:03:12Z
canonical: true
supersededBy: null
---
```

`canonical: true` means this is the current human-facing artifact of its type. Historical files should use `canonical: false` or `supersededBy`. Closed artifacts must not contain unqualified `active`, `pending`, or `waiting` status text unless the text is explicitly labeled as historical context.

## Files

- `state.json`: current snapshot for one orchestration run.
- `events.jsonl`: append-only timeline with one JSON object per line.
- `state.schema.json`: JSON Schema for `state.json`.
- `event.schema.json`: JSON Schema for each line in `events.jsonl`.

## Time

All stored timestamps are UTC/Zulu ISO-8601 strings, for example:

```text
2026-05-26T14:03:12Z
```

User local time conversion belongs only in UI rendering.

## Preferred Language

`state.json` may include top-level `preferredLanguage`. Supported values are `cs-CZ` and `en`.

This value is a forward-looking instruction and display hint:

- Producers should set `preferredLanguage` when the host app or the user provides a language preference. If no explicit preference exists, infer it from the initial user request and fall back to `en`.
- Producers should write future user-facing event messages, checkpoints, summaries, notes, markdown headings, phase titles, agent summaries, agent graph labels, agent assignment fields, and handoffs in `preferredLanguage` when it is set.
- Producers must not translate or rewrite historical events, checkpoints, or markdown artifacts when the preference changes.
- Fixed enum values, file paths, code identifiers, command names, timestamps, and schema fields remain unchanged.
- All time storage remains UTC/Zulu; language preference affects text only.
- UI consumers may display the selected language, localize static chrome independently, and may fall back to local app settings when a run has no stored preference.

## Host Support

`host` is one of:

- `codex`
- `claude-code`
- `unknown`

The contract is intentionally host-neutral. Host-specific details belong in `metadata`, `data`, or linked artifacts, not in divergent top-level shapes.

## Risk-Tier Dispatch Metadata

The orchestrator may use a lighter or heavier delegated workflow per request while keeping the same stable schema. Do not add new enum values for risk tiers, flow modes, planning cadence, phase policies, commit strategies, delivery preferences, or pipeline policies. Store dispatch and run-contract details in `state.json.metadata` and child-agent metadata:

```json
{
  "metadata": {
    "originalRiskTier": "critical",
    "activeRiskTier": "low",
    "flowMode": "single-delegated-worker",
    "cycle": "follow-up-003",
    "followUpOf": "initial-implementation",
    "rootMode": "dispatch-only",
    "planningCadence": "full-plan-before-implementation",
    "phaseApprovalPolicy": "auto-continue-after-verified-phase",
    "commitStrategy": "verified-phase-commits",
    "deliveryPreference": "draft-mr-after-verification",
    "pipelinePolicy": "watch-after-mr",
    "postImplementationActions": ["review", "verification", "commit", "push", "draft_mr", "pipeline_check"]
  },
  "agents": [
    {
      "id": "follow-up-003-worker",
      "role": "implementation-lead",
      "status": "running",
      "displayName": "Low bounded worker",
      "metadata": {
        "workerKind": "bounded-low-worker"
      }
    }
  ]
}
```

Recommended values:

- `originalRiskTier`: first cycle risk tier for this run, usually `low`, `medium`, `high`, or `critical`.
- `activeRiskTier`: current cycle risk tier. Follow-ups must be classified fresh and must not inherit this value automatically from the previous cycle.
- `flowMode`: display hint such as `single-delegated-worker`, `implementation-lead`, `scout-plan-implement-review`, or `full-critical-lifecycle`.
- `cycle`: stable current cycle id such as `initial-implementation`, `review-fix-001`, `follow-up-002`, or `delivery`.
- `followUpOf`: optional cycle id this cycle follows.
- `rootMode`: should be `dispatch-only` for this orchestrator.
- `planningCadence`: display hint such as `minimal-dispatch`, `full-plan-before-implementation`, or `full-roadmap-current-phase-detail`.
- `phaseApprovalPolicy`: display hint such as `manual-after-each-phase`, `auto-continue-after-verified-phase`, or `full-workstream-autonomous`.
- `commitStrategy`: display hint such as `no-commits`, `final-verified-commit`, `verified-phase-commits`, or `explicit-wip-checkpoint-commits`.
- `deliveryPreference`: display hint such as `stop-after-verification`, `commit-only`, `push-after-verification`, `draft-mr-after-verification`, `ready-mr-after-verification`, or `ask-before-delivery`.
- `pipelinePolicy`: display hint such as `do-not-check`, `check-once`, `watch-after-push`, `watch-after-mr`, or `recover-in-scope-failures`.
- `postImplementationActions`: optional ordered list of intended post-implementation actions such as `review`, `verification`, `commit`, `push`, `draft_mr`, `ready_mr`, `pipeline_check`, or `pipeline_watch`.

Consumers should treat these fields as optional display hints. Current run state still comes from top-level `status`, `currentPhaseId`, `agents`, `edges`, `phases`, `blockers`, `artifacts`, and `checkpoints`.

## Snapshot Rules

Producers should rewrite `state.json` atomically whenever the latest run state changes:

- run status or current phase changes;
- phase, agent, blocker, artifact, checkpoint, or edge state changes;
- validation or review state changes;
- a durable handoff is updated.

If a completed run receives a follow-up that requires more work, producers must rewrite `state.json` before work starts so `status` is no longer `completed`, `currentPhaseId` points at the active phase or follow-up subphase, and `metadata.activeRiskTier` / `metadata.cycle` describe the new cycle. Append a `run.status_changed` event and preserve historical completion evidence instead of rewriting it.

`state.json` must be valid against `state.schema.json`.

## Agent Assignment Summary

Each active or planned agent should expose a short machine-readable assignment so UI consumers can explain why the agent exists without scraping markdown:

- `agent.shortLabel`: a 2-4 word graph label, for example `Security review` or `Zapracování review`.
- `agent.intent`: one concise user-facing sentence, for example `Run security review of file deletion behavior`.
- `agent.plannedWork`: short bullets describing the next work the agent is expected to do.
- `agent.doneDefinition`: one concise condition that tells the parent when the assignment is complete.

Keep these fields operational and current. `shortLabel` is for dense graph cards and should not be a sentence. The other assignment fields should describe planned responsibility, not a full activity log. Historical progress belongs in `checkpoints`, `events.jsonl`, and linked markdown artifacts.

## Event Rules

Producers should append one event object to `events.jsonl` for each durable event. Each line must be valid against `event.schema.json`.

Required event types:

- `run.created`, `run.status_changed`, `run.completed`, `run.failed`
- `phase.started`, `phase.status_changed`, `phase.completed`
- `agent.spawned`, `agent.status_changed`, `agent.reported`
- `decision.recorded`, `blocker.opened`, `blocker.resolved`
- `artifact.created`, `artifact.updated`, `checkpoint.created`
- `review.finding_opened`, `review.finding_resolved`
- `validation.started`, `validation.passed`, `validation.failed`
- `note.added`

## Status Normalization

Run status:

```text
not_started, planning, implementing, reviewing, verifying, blocked, paused, completed, failed, cancelled
```

Phase status:

```text
not_started, in_progress, blocked, needs_review, completed, skipped, failed
```

Agent status:

```text
pending, running, blocked, done, failed, cancelled
```

Severity:

```text
info, warning, error, critical
```

## IDs And Paths

- `runId` should match the `.ant/orchestrator/<run-id>/` directory name.
- `phase.id` should use stable zero-padded lifecycle IDs such as `05-planning`.
- `agent.id` must be stable within a run.
- `artifact.path` should be workspace-relative when possible. Consumers must resolve relative paths inside the selected workspace after canonicalization/symlink resolution. Absolute paths are allowed only for explicit `external` artifacts that cannot be expressed relative to the selected workspace.
- `edge.fromAgentId` and `edge.toAgentId` should refer to known `agent.id` values.

## Examples

- `examples/codex/state.json`
- `examples/codex/events.jsonl`
- `examples/claude-code/state.json`
- `examples/claude-code/events.jsonl`
