# Codex Adapter

## Root Guidance, Plan, And Goal

- Codex root model and effort are the developer's choice. `gpt-5.6-sol` at High is recommended guidance only.
- Before each tracked-writer dispatch, call the native structured Plan operation (`update_plan`) to create or update the Plan.
- Inspect the authoritative native Plan state returned by that operation or shown by the host.
- Dispatch only when exactly one top-level Plan item is `in_progress` and every other item has a valid `pending` or `completed` state.
- Treat commentary or prose such as “the Plan is stable,” a narrated checklist, an assignment, or an intention to create or update a Plan as non-evidence.
- If the native Plan write fails, inspection fails, or the state is unknown or unverifiable, fail closed before dispatch.
- After the Plan gate, inspect the native Goal slot with the native Goal inspection operation (`get_goal`).
- Reuse the Goal only when it is active and its objective matches the current implementation.
- If the slot is empty, create the matching immutable Goal with the native creation operation (`create_goal`).
- After creating a Goal, reinspect it with `get_goal`.
- Treat commentary or prose such as a narrated Goal, assignment, intention to create a Goal, or claim that the Goal matches as non-evidence.
- If the Goal is missing, mismatched, unavailable, or unverifiable, fail closed before dispatch.
- If native Goal inspection or creation fails, fail closed before dispatch.
- Never replace, complete, or block an unrelated unfinished Goal.
- If one occupies the slot, pause tracked work.
- Root asks whether to finish the current Goal and queue a follow-on, or use native controls to end or resolve it.
- Create a new Goal only after native state reports no unfinished Goal.
- If a material objective or public-contract delta no longer fits the Goal, pause affected work and follow the same lifecycle choice.
- Stable in-objective changes update the native Plan and assignments.

## Routing And Recursive Capsule

- After the Plan/Goal gates pass, invoke required Luna/Sol child and nested-child routes directly. The shared lifecycle and capsule rules are in [lifecycle.md](lifecycle.md).
- Pin every child and nested child with an explicit model and effort, never above High, and `fork_turns="none"`.
- Route strong judgment, architecture, security, migration, and independent final review to `gpt-5.6-sol` at High.
- Route integration and normal implementation to `gpt-5.6-luna` at High.
- Route narrow work to Luna at proportional High, Medium, or Low.
- There is no Terra route or fallback.
- Use the complete recursive capsule and reporting rules in [lifecycle.md](lifecycle.md).
- Do not dispatch if any required child route, effort, availability, fresh context, isolation, or `fork_turns="none"` selector cannot be enforced.

## Decisions And Recovery

- Root uses native structured input for material choices when available. Children return evidence, options, recommendation, and paused scope only through parents.
- Follow [lifecycle.md](lifecycle.md) for review invalidation, candidate-bound validation, recovery, and interactive smoke.

## Interactive Browser Smoke

- Existing automated browser/E2E tests remain ordinary risk-based validation. Agent-driven interactive smoke runs only when the user explicitly requests it or repository/acceptance criteria explicitly require it; otherwise do not preflight or run it.
- Use the shared lifecycle smoke and recovery rules, with the internal Codex browser surface as the host-specific browser surface.
