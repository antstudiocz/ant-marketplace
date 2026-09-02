# Codex Adapter

## Root Guidance, Durable Plan, And Goal

- Codex root model and effort are the developer's choice. `gpt-5.6-sol` at High is recommended guidance only.
- Verify the root-owned durable plan bundle before any tracked-writer dispatch. It must have a stable README entrypoint, resolved material decisions, current phase, ownership, acceptance, risks, and checks. Host-provided planning UI is optional only and has zero blocking or evidentiary role.
- Inspect the native Goal slot with `get_goal` after durable-plan verification. Reuse only an active Goal whose stable measurable objective matches the implementation and references the repo-relative plan README.
- If the slot is empty, create the matching Goal with `create_goal`, then reinspect it with `get_goal`. Missing, mismatched, unavailable, or unverifiable required Goal state fails closed before dispatch.
- Codex currently exposes Goal creation/reading and terminal closure (`update_goal` with `complete` or `blocked`), not explicit step mutation. `update_goal` is terminal-only: never use it to simulate phase progress, clear collisions, or record a stable delta.
- Only an adapter-inspected, dedicated nonterminal Goal checkpoint mutation may mirror root's durable-plan phase checkpoints. Current Codex tools do not expose that capability, so its absence is non-blocking and the durable plan remains authoritative. `blocked` follows host repeated-blocker semantics and never clears a collision.
- Never replace, complete, or block an unrelated unfinished Goal. Pause and ask root/user to finish it and queue a follow-on or use native controls to end/resolve it. A material objective/public-contract delta follows the same rule.
- Stable in-objective changes update the root-owned durable plan and assignments. Root updates the plan at decision resolution, phase transitions, stable deltas, recovery, review readiness, and immediately before freeze.

## Routing And Recursive Capsule

- After the durable-plan and required Codex Goal gates pass, invoke required Luna/Sol child and nested-child routes directly. The shared capsule, ownership, read-only plan boundary, review, recovery, and validation rules are in [lifecycle.md](lifecycle.md).
- Pin every child and nested child with an explicit model and effort, never above High, and `fork_turns="none"`. Every assignment uses fresh isolated context and explicitly states whether nested delegation is allowed.
- Route strong judgment, architecture, security, migration, and independent final review to `gpt-5.6-sol` at High.
- Route integration and normal implementation to `gpt-5.6-luna` at High.
- Route narrow work to Luna at proportional High, Medium, or Low. There is no Terra route or fallback.
- Do not dispatch if any required child route, effort, availability, fresh context, isolation, or `fork_turns="none"` selector cannot be enforced.
- Children read plan files but cannot edit the plan directory. Their checkpoint report includes phase/status, files/areas, validation, discoveries/decisions, proposed plan delta, and risks/blockers.

## Decisions And Recovery

- Root uses native structured input for material choices when available, but the durable Markdown plan remains authoritative and tracked. Children return evidence, options, recommendation, and paused scope through parents.
- On compaction or interruption, reconcile the durable plan with Codex Goal state, git state, native task state, checkpoints, findings, and actual diffs before resuming; update `progress.md` as a root-owned recovery checkpoint.
- Follow [lifecycle.md](lifecycle.md) for candidate freeze, review invalidation, candidate-bound validation, and interactive smoke.

## Interactive Browser Smoke

- Existing automated browser/E2E tests remain ordinary risk-based validation. Any side-effecting or agent-driven interactive smoke runs only when explicitly requested or required by repository/acceptance criteria; otherwise do not preflight or run it.
- Use the shared lifecycle smoke and recovery rules, with the internal Codex browser surface as the host-specific browser surface.
