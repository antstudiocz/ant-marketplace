# Codex adapter

This adapter owns Codex-specific Goal, model, effort, and tool behavior. The shared rules are in [lifecycle.md](lifecycle.md).

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
