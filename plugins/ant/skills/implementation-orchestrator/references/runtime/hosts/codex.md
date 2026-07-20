# Codex Runtime Adapter

Load this file only when preflight identifies the active host as Codex. This file owns Codex mechanics; shared routing and authorization remain in `../capability-routing.md` and `../../policies/approval-policy.md`.

## Discovery

Observe the current Codex surface and available collaboration tools. Do not assume a capability from another session, product surface, or documented model name.

Record:

- whether child creation supports an explicit no-history/fresh-task mode;
- runtime-reported nesting and concurrency limits, if available;
- supported per-child model/reasoning selectors and their runtime values, if exposed;
- message, follow-up, wait/resume, interrupt/stop, and replacement behavior;
- foreground/background and permission-prompt behavior;
- available in-app/connected browser tools and session properties;
- git/provider tooling and sandbox restrictions.

When the active `spawn_agent` schema exposes `fork_turns`, call it with `fork_turns: "none"` for every child and preserve the result as route evidence. On another Codex surface, use its verified equivalent. A default or undocumented assumption is `unverified`, not `verified`.

## Dispatch Graph

Use native nesting only when preflight verifies sufficient depth for `Root -> Implementation Lead -> Slice/Reviewer` and enough concurrency exists. Otherwise flatten all children under root:

```text
verified depth >= 2: Root -> Lead -> Slice/Reviewer
depth < 2 or unknown: Root -> Lead; Root -> Slice/Reviewer on lead request
```

Flattening changes dispatch mechanics only. The implementation lead still owns integration and requests root dispatch with a precise packet. The reviewer remains independent.

Every child receives a curated task packet and no chat transcript. If no verified no-history path exists, delegation is blocked for this workflow.

## Routing Evidence

Classify canonical `low|medium|high` complexity/reasoning through `../../policies/reasoning-policy.md`, then translate only through a fresh active-runtime catalog tied to the current host version and model. Depending on the current Codex surface, a verified mechanism may be a tool-call reasoning selector, a custom-agent `model_reasoning_effort` value, or an explicitly supported CLI `-c` configuration path. Record the exact mechanism, requested host value, and mapping evidence; do not assume they are portable across surfaces or models.

`model_reasoning_effort` support and values are model-dependent. Do not infer a portable clamp or lower fallback when the requested value is unsupported. If the catalog is missing, stale, or does not support the canonical request, omit the selector, use the session/runtime default, keep actual reasoning `unknown`, and record the fallback. Do not map canonical `high` to `ultra`: Ultra changes orchestration/topology behavior and is outside the reasoning-tier mapping. Values above the portable canonical tiers are never selected automatically.

Capture the child handle and any host-returned model, reasoning, history, nesting, and execution values. Selector acceptance is not application evidence. Derive actual canonical reasoning only from a returned value plus the fresh host/version/model mapping; otherwise actual remains `unknown`. Never infer it from the request.

When exposed, use `send_message` for non-triggering context updates, `followup_task` for a new child turn, `wait_agent` for mailbox progress, and `interrupt_agent` only for urgent correction/recovery. Preflight their actual semantics first. Before replacing a writer, obtain a checkpoint or verified closed state. Preserve one writer per path.

## Browser And Delivery

Select from currently available browser surfaces according to the scenario and session needs. Missing browser capability becomes blocked evidence.

Tool availability does not authorize delivery. Resolve authorization through `../../policies/approval-policy.md`, then follow repository policy and the canonical merge-request skill.
