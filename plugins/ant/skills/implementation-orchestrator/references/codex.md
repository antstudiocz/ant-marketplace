# Codex adapter

This adapter owns Codex-specific Goal, model, effort, and tool behavior. The shared rules are in [lifecycle.md](lifecycle.md).

## Clarification questions

- When available, map asynchronous clarification to `request_user_input_async`: it returns immediately and receives the user's answer as a later message. Ask concise bundled questions with options when useful, and follow the live host's current interaction guidance. Root remains the sole user-facing adjudicator; do not use the question tool for commentary or progress updates.
- Tool availability and host mode limits govern. If asynchronous input is unavailable, use permitted native input or a plain user question; never force Plan-only `request_user_input` in Default mode, expand Plan mode permissions, or simulate an asynchronous runtime.

## Goal

- For every implementation-authorized run, verify the durable plan, then inspect the native Goal slot with `get_goal`. Native Goals are default-on for this route.
- Reuse a matching active Goal. After classifying the inspected slot, use `create_goal` and reinspect with `get_goal` only for a verified empty slot or a slot containing a terminally completed Goal, with no unfinished unrelated Goal collision, when the tool is available and established user/host authorization covers automatic creation. Do not create through an unrelated or unverified state. Do not ask for consent solely for this optional Goal when that authority is already established, and never claim that the plugin grants consent.
- Apply the shared lifecycle classification for verified absence, unavailable capability or authority, unknown or unverifiable state, unrelated active Goals, explicit Goal requirements, and analysis-only work. Do not claim a Goal exists when verification fails.
- `update_goal` is terminal-only (`complete` or `blocked`); it cannot represent phase progress or clear a collision.

## Recovery

- After interruption or compaction, use `get_goal` when available and apply the shared lifecycle recovery and Goal classification before resuming.

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
