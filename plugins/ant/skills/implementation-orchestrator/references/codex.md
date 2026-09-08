# Codex adapter

This adapter owns Codex-specific Goal, model, effort, and tool behavior. The shared rules are in [lifecycle.md](lifecycle.md).

## Clarification questions

- When available, map asynchronous clarification to `request_user_input_async`: it returns immediately and receives the user's answer as a later message. Ask concise bundled questions with options when useful, and follow the live host's current interaction guidance. Root remains the sole user-facing adjudicator; do not use the question tool for commentary or progress updates.
- Tool availability and host mode limits govern. If asynchronous input is unavailable, use permitted native input or a plain user question; never force Plan-only `request_user_input` in Default mode, expand Plan mode permissions, or simulate an asynchronous runtime.

## Parent communication

- Children report progress, findings, blockers, and requested scope changes through `collaboration.send_message` to their verified parent; when that channel is unavailable, use the child final response. Use `send_message_to_thread` only for a genuine independent task handoff after verifying a non-empty destination thread ID; never use it to contact `/root` or with an empty or guessed ID.

## Goal

- For every implementation-authorized run, verify the durable plan. Inspect the native Goal slot with `get_goal` only when the user explicitly requests a Goal or the current task already has one in use; an absent Goal does not block authorized work.
- Reuse a matching active Goal. After classifying the inspected slot, use `create_goal` and reinspect with `get_goal` only for a verified empty slot or a slot containing a terminally completed Goal, with no unfinished unrelated Goal collision, when the user explicitly requested the Goal and the tool is available. Do not create through an unrelated or unverified state, and never claim that the plugin grants consent. If no Goal was requested, do not ask for one or create one.
- Apply the shared lifecycle classification for verified absence, unavailable capability or authority, unknown or unverifiable state, unrelated active Goals, explicit Goal requirements, and analysis-only work. Do not claim a Goal exists when verification fails.
- `update_goal` is terminal-only (`complete` or `blocked`); it cannot represent phase progress or clear a collision.

## Recovery

- After interruption or compaction, use `get_goal` when a Goal was explicitly requested or is already in use, then apply the shared lifecycle recovery and Goal classification before resuming. Otherwise reconcile the durable plan and native task state without creating a Goal.

## Routes

Use a fresh isolated context and `fork_turns="none"` for every child. Never exceed High or dispatch when the selected route cannot be enforced.

| Role | Model | Effort |
|---|---|---|
| Integration owner | `gpt-5.6-luna` | High |
| Strong reviewer or strong judgment | `gpt-5.6-sol` | High |
| Bounded investigation, validation, or narrow work | `gpt-5.6-luna` | High, Medium, or Low as proportionate |

The root model and effort are developer-selected. There is no Terra route or fallback. Every assignment carries the complete capsule from [lifecycle.md](lifecycle.md), including write ownership, the root-only plan boundary, delegation permission, checks, and report/escalation path.

## Smoke

Existing browser/E2E automation is ordinary risk-based outcome evidence. Choose appropriate interaction evidence automatically when changed behavior and risk require it: use existing browser/E2E automation or interactive smoke as suitable, including realistic states defined by the shared lifecycle; do not require a special smoke request. Use the internal Codex browser where available. Evidence gathering never expands authority; reuse established authority and obtain appropriate explicit authorization for effects outside it, with destructive or data-loss actions explicitly authorized under the authority rules.
