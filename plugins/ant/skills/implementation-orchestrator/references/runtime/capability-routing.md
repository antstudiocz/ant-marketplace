# Capability Preflight And Routing

This file is the normative owner for host-neutral preflight, route requests, route evidence, and degraded modes. Task complexity and requested reasoning tiers are owned by `../policies/reasoning-policy.md`. This file contains no fixed model slugs.

## Preflight Timing And Storage

Before the first delegation in each run, and after a host/surface change or material resume, inspect the active runtime without performing network delivery or other mutation.

Write a workspace-relative artifact such as `.ant/orchestrator/<run-id>/runtime-capabilities.json`. Store only a compatible display summary and artifact pointer in `state.json.metadata.runtime`; state contract `1.0.0` has no typed runtime field.

Do not dispatch the first child until all three compatible evidence surfaces exist:

1. the linked capability artifact with host, timestamp, capability values, degraded modes, and evidence sources;
2. `state.json.metadata.runtime` with the artifact pointer and non-authoritative summary;
3. a `state.json.metadata.routingDecisions[]` entry for the child request containing `requested`, host-observed `actual` or `unknown`, fallbacks, `evidenceSource`, and `observedAt`.

If the producer cannot persist or link these records, delegation is blocked for this workflow. A task packet, requested model value, child handle, or prose checkpoint alone is not an audit trail.

Every capability value is `verified`, `unverified`, `unsupported`, or `unknown`. Record `unknown` instead of guessing. A route may rely on required capability only when it is `verified` or when the adapter has an explicitly safe degraded path.

## Minimum Snapshot

```json
{
  "schemaVersion": "runtime-capabilities-1.0",
  "observedAt": "<UTC/Zulu>",
  "host": {"id": "codex|claude-code|unknown", "surface": "<value-or-unknown>", "version": "<value-or-unknown>"},
  "delegation": {
    "mechanisms": [],
    "childLifecycle": "<summary-or-unknown>",
    "freshContext": "verified|unverified|unsupported|unknown",
    "historyIsolation": "verified|unverified|unsupported|unknown",
    "maxNestingDepth": "<integer-or-unknown>",
    "maxConcurrency": "<integer-or-unknown>",
    "availableConcurrency": "<integer-or-unknown>",
    "message": "verified|unverified|unsupported|unknown",
    "waitResume": "verified|unverified|unsupported|unknown",
    "interruptStop": "verified|unverified|unsupported|unknown",
    "replacementSafety": "verified|unverified|unsupported|unknown"
  },
  "routing": {
    "modelSelection": "verified|unverified|unsupported|unknown",
    "runtimeModelCatalog": "<host-values-or-unknown>",
    "reasoningSelection": "verified|unverified|unsupported|unknown",
    "runtimeReasoningValues": "<host-values-or-unknown>",
    "reasoningTranslation": "<verified-host-mechanism-or-unknown>",
    "fallbackSemantics": "<observed-rule-or-unknown>"
  },
  "execution": {
    "foreground": "verified|unverified|unsupported|unknown",
    "foregroundPermissionPrompts": "verified|unverified|unsupported|unknown",
    "background": "verified|unverified|unsupported|unknown",
    "backgroundPermissionPrompts": "verified|unverified|unsupported|unknown",
    "sandbox": "<summary-or-unknown>"
  },
  "browser": {"surfaces": [], "sessionAuth": "<summary-or-unknown>"},
  "delivery": {"git": "<status>", "gitlab": "<status>", "github": "<status>", "provider": "<value-or-unknown>"},
  "degradedModes": [],
  "evidence": []
}
```

Do not probe delivery by pushing, opening an MR, or making another external change. Tool presence is capability evidence, not approval.

## Route Request

```json
{
  "requestId": "<stable-id>",
  "role": "reviewer",
  "risk": "high",
  "complexity": {"tier": "high", "signals": ["independent architecture adjudication"]},
  "requested": {"reasoningTier": "high"},
  "requiredCapabilities": ["independent-context", "high-judgment", "read-only-tools"],
  "preferredCapabilities": ["high-reasoning", "long-context"],
  "historyMode": "none",
  "backgroundAllowed": true,
  "fallbackPolicy": "escalate-or-flatten"
}
```

Use capability classes such as `independent-context`, `read-only-tools`, `write-tools`, `high-judgment`, `long-context`, `browser-session`, `delivery-provider`, and `permission-prompt-capable`. Reasoning is the canonical requested tier defined by the reasoning policy, not an opaque capability label. Host-neutral files must not name a current model slug or host-specific effort value.

## Route Evidence

Append route decisions to a linked artifact and a compatible summary in `state.json.metadata.routingDecisions[]`:

```json
{
  "requestId": "<stable-id>",
  "complexity": {"tier": "high", "signals": ["independent architecture adjudication"]},
  "requested": {"role": "reviewer", "capabilities": ["high-judgment"], "reasoningTier": "high", "reasoningHostValue": "<translated-host-value-or-omitted>", "historyMode": "none"},
  "reasoningTranslation": {
    "mechanism": "<verified-host-mechanism-or-none>",
    "mappingEvidenceSource": "<capability-artifact-ref>",
    "mappingScope": {"host": "<host>", "hostVersion": "<version-or-unknown>", "model": "<model-or-unknown>"},
    "observedAt": "<UTC/Zulu>"
  },
  "actual": {
    "host": "<host>",
    "agentHandle": "<value-or-unknown>",
    "model": "<host-observed-value-or-unknown>",
    "reasoningTier": "<host-observed-tier-or-unknown>",
    "reasoningHostValue": "<host-observed-value-or-unknown>",
    "historyMode": "<host-observed-value-or-unknown>",
    "nesting": "<host-observed-value-or-unknown>",
    "execution": "<host-observed-value-or-unknown>"
  },
  "fallbackReason": null,
  "fallbacks": [],
  "evidenceSource": "<host-result-or-unknown>",
  "observedAt": "<UTC/Zulu>"
}
```

`actual` comes only from host observation. Selector support proves only that a request may be sent; it does not prove application. Derive an actual canonical tier only when the host returns an applied value and a fresh mapping tied to the active host/version/model catalog translates it. Otherwise both actual reasoning fields are `unknown`. Record each fallback with the missing capability, chosen alternative, `fallbackReason`, and evidence impact. Revalidate complexity plus reasoning capability after material resume or host/surface change before reusing a route.

Every routing decision must link back to the capability artifact or a concrete host-returned spawn result through `evidenceSource`. Missing evidence source means the actual assignment is `unknown` and cannot support a quality/capability claim.

## Degraded-Mode Decisions

| Missing/unknown capability | Safe action |
|---|---|
| history isolation | Do not spawn that child. Use another verified no-history mechanism or stop. |
| nesting depth >= 2 | Flatten dispatch under root; preserve role ownership and review. |
| free concurrency | Queue/wait; never overlap writers to the same scope. |
| background permission prompts | Route permission-sensitive work foreground; background failure is a host limitation, not an implementation pass/fail. |
| message | Use host-supported synchronous completion/wait; record reduced liveness. |
| wait/resume | Keep work foreground or stop with a checkpoint. |
| interrupt/replacement safety | Do not replace an active writer until it finishes or is safely checkpointed/closed. |
| browser | Record browser scenario as blocked with residual risk; do not invent a pass. |
| delivery provider/tool | Stop before delivery and report the missing capability. |
| actual model/reasoning observation | Record `unknown`; do not repeat requested values. |

Reasoning selection never changes the execution row used for permission-sensitive work. A foreground retry is an execution fallback, not evidence that the requested reasoning tier was applied.

Parity across hosts means the same approval boundary, ownership, acceptance scenarios, evidence policy, and outcome—not the same spawn tree or model name.
