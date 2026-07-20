# Adaptive Reasoning Policy

This file is the normative host-neutral owner for task-complexity classification and requested reasoning tiers. It applies to every delegated role and every model. Host adapters own translation to the active host mechanism; this policy contains no model slugs or host-specific effort values.

## Classify The Task, Not The Model

Before each route request, classify the bounded assignment independently from lifecycle risk and execution permissions:

| Complexity | Use when |
| --- | --- |
| `low` | The task is local, deterministic, contract-known, and has a narrow validation path. |
| `medium` | The task crosses files or components, requires integration judgment, or has moderate ambiguity and regression surface. |
| `high` | The task requires architecture or independent review judgment, resolves conflicting evidence, or affects contracts, data, security, permissions, migrations, or broad acceptance risk. |

Persist the tier plus short evidence-backed signals. Do not classify from role name alone. A reviewer, scout, or writer may receive any tier justified by its actual packet.

Risk and complexity are related inputs, not aliases. Risk controls approval/review/validation gates; complexity controls requested reasoning. Foreground/background, sandbox, permission-prompt, browser, mutation, and delivery decisions remain separate execution/authorization concerns.

## Requested Tier

Every route request contains:

```json
{
  "complexity": {"tier": "low|medium|high", "signals": ["<bounded evidence>"]},
  "requested": {"reasoningTier": "low|medium|high"}
}
```

Default the requested reasoning tier to the classified complexity. It may be elevated when independent judgment, contradictory evidence, or a safety-critical boundary warrants it. Record the reason for an elevation. Never lower the requested tier merely because a preferred model or host mechanism is unavailable.

Reclassify before a materially changed packet, after compaction/resume, after a host/surface change, and when validation or review exposes new complexity. Reuse is allowed only when the persisted classification still describes the exact bounded task and capability evidence is still fresh.

## Translation And Evidence

The active host adapter translates the canonical requested tier only through mechanisms and values reported as supported by current preflight evidence.

Persist all of:

```json
{
  "requested": {"reasoningTier": "high"},
  "translation": {
    "mechanism": "<verified-host-mechanism-or-none>",
    "requestedHostValue": "<verified-host-value-or-omitted>",
    "mappingEvidenceSource": "<fresh-capability-catalog-ref>",
    "mappingScope": {"host": "<host>", "hostVersion": "<version-or-unknown>", "model": "<model-or-unknown>"},
    "observedAt": "<UTC/Zulu>"
  },
  "actual": {"reasoningTier": "<host-observed-tier-or-unknown>", "hostValue": "<host-observed-value-or-unknown>"},
  "evidenceSource": "<host-result-or-capability-artifact>",
  "fallbackReason": "<null-or-specific-reason>"
}
```

- Supported and host-observed: record the returned host value and derive the canonical actual tier only through the fresh translation mapping tied to the active host, host version, and model/catalog context.
- Supported but not observable after dispatch: the translated request may be sent, but both actual host value and canonical tier remain `unknown`; evidenceSource points to the host result and mapping artifact.
- Unsupported: use the documented host/session default or another preflight-verified safe mechanism; keep `actual` observed or `unknown` and record `reasoning-selection-unsupported` plus the chosen degradation.
- Unknown/stale: do not send a speculative selector; use the host/session default, record `actual: unknown`, and set `fallbackReason` to `reasoning-capability-unknown` or `reasoning-capability-stale`.

Requested values are intent, never evidence. Do not copy requested tier/value into actual without a host-returned or otherwise concrete observation.

## Permission Separation

A reasoning tier never authorizes tools, mutations, permission escalation, background work, browser use, or delivery. Determine foreground/background and permission handling from execution capabilities and the approval policy. If a permission-sensitive action must retry in foreground, preserve or separately reclassify the reasoning request; do not call the foreground retry a reasoning upgrade or downgrade.

## Stop And Escalate

Stop or escalate the bounded packet when the chosen degraded path cannot provide the judgment needed for a high-complexity task, or when actual capability evidence contradicts the request. Record the blocker or fallback and its evidence impact instead of claiming parity.
