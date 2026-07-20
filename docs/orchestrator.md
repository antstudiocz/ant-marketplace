# Orchestrator Setup

Use `implementation-orchestrator` when a task needs an end-to-end workflow instead of a direct one-off answer.

The orchestrator is responsible for:

- checking git context and delivery expectations first;
- clarifying the goal and blocking product or technical decisions;
- planning the implementation shape before editing;
- delegating scouts, implementation leads, slice workers, and reviewers when useful;
- keeping validation and review loops explicit;
- handing off final delivery evidence and PR/MR readiness.

## First Use

1. Install the plugin from [docs/install.md](install.md).
2. Start a new Claude Code or Codex session.
3. Invoke the orchestrator:
   - Claude Code: `/ant:implementation-orchestrator`
   - Codex: `$implementation-orchestrator`
4. Give it the goal, relevant repo/path, and any delivery expectations.
5. Let it ask clarification questions before implementation starts.

## Capability Preflight And Host Parity

Before its first delegation, the orchestrator observes the capabilities available in the current host/session. It records requested route preferences separately from actual observed results and uses `unknown` when the host cannot prove an actual model, reasoning level, nesting depth, browser surface, or permission behavior.

Delegation starts only after the run contains a linked `runtime-capabilities.json` artifact, a `metadata.runtime` pointer/summary, and a `metadata.routingDecisions[]` record with requested, actual/unknown, fallbacks, and an evidence source. A prompt-level model request or child handle alone is not accepted as actual route evidence.

Host parity means equivalent outcomes and safety boundaries, not identical agent trees:

| Capability area | Preferred route when observed | Degraded route |
|---|---|---|
| Nested delegation | Root delegates to a lead that can own bounded children | Root dispatches the same roles flat while preserving ownership and review. |
| Isolated child context | Use a no-history child for independence-sensitive work | Flatten or stop when isolation is required and unavailable. |
| Approval-sensitive tool use | Use a foreground/background mode that can complete required prompts | Retry in foreground or record a blocker; never report a permission failure as implementation success. |
| Browser validation | Use an observed available browser surface | Record browser validation as unavailable/blocked and preserve the evidence gap. |
| Model/reasoning selection | Classify the task `low`, `medium`, or `high`, then translate through the current host/model catalog | Omit an unknown/unsupported selector, record the fallback, and keep actual reasoning `unknown`. |

No model slug, reasoning level, nesting depth, browser integration, or agent-team feature is promised statically by these docs. The runtime preflight and host-returned evidence are authoritative for a particular run.

## Codex Subagent Depth

For the full hierarchy `Root Orchestrator -> Implementation Lead -> Slice Worker/Reviewer`, Codex must allow spawned agents to spawn child agents:

```toml
[agents]
max_depth = 2
```

Add this to `~/.codex/config.toml`, then restart Codex or open a new session.

This setting is a user configuration hint, not proof of runtime behavior. The preflight still checks the confirmed depth. When depth 2 is unavailable or unknown, the root dispatches implementation and review roles in a flattened graph without weakening the acceptance criteria.

## Model Routing And Adaptive Reasoning

The root model is selected by the user/session. Every bounded child task receives a host-neutral complexity classification: `low` for local deterministic work, `medium` for integration or moderate ambiguity, and `high` for architecture, conflicting evidence, contracts, data, security, permissions, migrations, or independent review judgment. Complexity controls the requested reasoning tier; lifecycle risk separately controls approvals, review, and validation.

The active adapter translates the canonical tier through a fresh capability catalog tied to the current host version and model. The route records the canonical requested tier, requested host value or `omitted`, translation mechanism/evidence, host-returned actual value or `unknown`, evidence source, and fallback reason. Selector support does not prove application: when the host does not report the applied value, actual remains `unknown`.

Codex reasoning mechanisms and values are model/surface dependent; canonical `high` is never automatically mapped to Ultra because Ultra changes orchestration behavior. Claude Code effort is a soft adaptive per-step control that can be clamped by supported values or organization policy; fixed thinking-token budgets and ultracode are not portable reasoning-tier mechanisms.

If a selected route encounters ambiguity, conflicting evidence, contract changes, data/cache/permission risk, or review-level judgment beyond its capabilities, it stops and escalates to a stronger available route. Requested values must never be copied into actual evidence; the host result is recorded, or actual remains `unknown`.

Reasoning never authorizes tools or delivery and never chooses foreground/background execution. Permission-sensitive work follows the execution capability and approval policy independently; a foreground retry is not a reasoning upgrade.

## Authorization And Resume

Startup choices and `state.json.metadata` are display/context only. Before edits, commits, pushes, PR/MRs, pipeline recovery, merges, or releases—and again after resume, compaction, or cross-host handoff—the orchestrator resolves a schema-valid immutable approval event/artifact. Missing, expired, revoked, conflicting, metadata-only, or out-of-scope evidence fails closed and requires fresh approval. See the [state contract](../plugins/ant/contracts/orchestrator-state/README.md) for contract-1.0 compatibility examples.

## Run State

Orchestrated runs should maintain local ignored structured state under:

```text
.ant/orchestrator/<run>/
```

The machine-readable contract lives in:

- [plugins/ant/contracts/orchestrator-state/README.md](../plugins/ant/contracts/orchestrator-state/README.md)
- [state.schema.json](../plugins/ant/contracts/orchestrator-state/state.schema.json)
- [event.schema.json](../plugins/ant/contracts/orchestrator-state/event.schema.json)

## Explainer

For a visual walkthrough of the lifecycle, root role, delegated subagents, review loop, and durable state, open:

[orchestrator-explainer.vercel.app](https://orchestrator-explainer.vercel.app/)
