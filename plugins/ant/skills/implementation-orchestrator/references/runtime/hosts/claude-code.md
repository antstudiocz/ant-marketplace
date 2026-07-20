# Claude Code Runtime Adapter

Load this file only when preflight identifies the active host as Claude Code. This file owns Claude Code mechanics; shared routing and authorization remain in `../capability-routing.md` and `../../policies/approval-policy.md`.

## Default Mode: Flat Named Subagents

Use root-owned named-subagent dispatch through the active Agent/subagent surface as the production default:

```text
Root -> Scout
Root -> Plan Writer
Root -> Implementation Lead
Root -> Slice Worker(s) requested by lead
Root -> Reviewer
```

Named subagents receive a fresh curated assignment and do not receive the parent conversation as working context. Record history isolation as verified only when the active surface guarantees or demonstrates it.

Named subagents do not spawn nested subagents in this adapter. The implementation lead proposes slices/review to root; root dispatches them and returns results to the lead. Ownership remains unchanged.

## Foreground And Background

Permission-sensitive work runs foreground. Background subagents may be used only when their complete read/write/tool scope is already permitted and no new permission prompt can be required. If a background action needs permission and fails, classify it as a host execution limitation, retry foreground when authorized, or report a blocker; do not count it as passed implementation evidence.

Classify canonical `low|medium|high` complexity/reasoning through `../../policies/reasoning-policy.md`. Translate it through a fresh capability catalog tied to the active Claude Code version/model using a supported `--effort` or `effortLevel` mechanism. Record precedence, requested host value, mapping evidence, and any organization-level cap. Effort is a soft control over adaptive per-step reasoning; it is not a fixed thinking-token budget.

Claude Code may clamp an applied effort to a supported value no higher than the request or an organization cap. Record a clamp only when returned/observed by the host, including the requested value, applied value, and fallback reason. Selector acceptance alone does not prove application. If no applied value is returned, actual host value and canonical tier remain `unknown` even when selection is supported.

Do not use `MAX_THINKING_TOKENS` as a portable control: it is ignored, deprecated, or unsupported for adaptive/newer reasoning paths. Do not map a canonical tier to `ultracode`; that is an orchestration mode, not an effort level. Unknown/stale support omits the selector and records the host/session default as a degraded fallback with actual `unknown`.

## Agent Teams

Agent teams are opt-in only after:

- preflight verifies the feature and its permission/ownership behavior;
- the user explicitly approves the alternate adapter mode;
- the run records separate scenario evidence.

The team's shared task list never replaces `.ant/orchestrator/<run>/state.json` and `events.jsonl`. If any writer ownership is ambiguous, use flat named-subagent dispatch.

## Browser And Delivery

Preflight connected Chrome/MCP/browser surfaces and authentication state. Use them only for approved scenarios; otherwise record unavailable/blocked evidence.

Tool availability does not authorize delivery. Resolve authorization through `../../policies/approval-policy.md`, then follow repository policy and the canonical merge-request skill.
