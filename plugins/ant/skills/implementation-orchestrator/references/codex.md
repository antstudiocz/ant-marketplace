# Codex adapter

This adapter owns Codex-specific Goal, model, effort, and tool behavior. The shared rules are in [lifecycle.md](lifecycle.md).

## Clarification questions

- When available, map asynchronous clarification to `request_user_input_async`: it returns immediately and receives the user's answer as a later message. Ask concise bundled questions with options when useful, and follow the live host's current interaction guidance. Root remains the sole user-facing adjudicator; do not use the question tool for commentary or progress updates.
- Tool availability and host mode limits govern. If asynchronous input is unavailable, use permitted native input or a plain user question; never force Plan-only `request_user_input` in Default mode, expand Plan mode permissions, or simulate an asynchronous runtime.

## Goal

- For every implementation-authorized run, verify the durable plan, then inspect the native Goal slot with `get_goal`.
- Reuse a matching active Goal. If none exists, create one automatically with `create_goal` under established user/host authorization for automatic Goal creation, without asking again, then reinspect it with `get_goal`.
- If Goal creation or verification is unavailable, forbidden, mismatched, or unverifiable, report the concrete blocker and do not dispatch tracked work or claim that a Goal exists. Never replace, complete, or block an unrelated active Goal.
- `update_goal` is terminal-only (`complete` or `blocked`); it cannot represent phase progress or clear a collision.

## Routes

Use a fresh isolated context and `fork_turns="none"` for every child. Never exceed High or dispatch when the selected route cannot be enforced.

| Role | Model | Effort |
|---|---|---|
| Integration owner | `gpt-5.6-luna` | High |
| Strong reviewer or strong judgment | `gpt-5.6-sol` | High |
| Bounded investigation, validation, or narrow work | `gpt-5.6-luna` | High, Medium, or Low as proportionate |

The root model and effort are developer-selected. There is no Terra route or fallback. Every assignment carries the complete capsule from [lifecycle.md](lifecycle.md), including write ownership, the root-only plan boundary, delegation permission, checks, and report/escalation path.

## Smoke

Existing browser/E2E automation is ordinary risk-based validation. Run interactive smoke only when explicitly requested or required by acceptance criteria, using the internal Codex browser where available and the shared lifecycle preflight.
