# Claude Code Adapter

## Root Route And Durable Plan

- Root must run `best` at `max` for the entire run, selected with `claude --model best --effort max` or `/model best` plus `/effort max`. `best` resolves dynamically to Fable where available, otherwise current Opus; do not use `opusplan`.
- Verify that route from authoritative host/session/task metadata or explicit current host selection. Model self-identification is not evidence. If the mandatory exact root route cannot be verified, fail closed before tracked-writer dispatch.
- The root-owned durable Markdown plan is the shared planning gate for Claude. Verify its stable README entrypoint, material-decision completeness, current phase, ownership, acceptance, risks, and checks before tracked edits. Native Claude Plan UI is optional, non-authoritative, and never a recovery dependency.
- Root writes and updates the plan directory. Children may read it but cannot edit it. Native Goal support is optional; if an adapter-inspected dedicated nonterminal checkpoint mutation exists, root may mirror phase checkpoints there; otherwise its absence is non-blocking and the durable plan remains authoritative. Never supersede an unrelated optional Goal.
- Root updates the plan at decision resolution, phase start/completion, stable in-objective delta, recovery/resume, review readiness, and immediately before candidate freeze. A post-freeze plan edit creates a new candidate and invalidates candidate-bound evidence.

## Routing And Recursive Capsule

- After implementation authority and the durable-plan gate are established, required child and nested-child profile/model/effort routes are automatic internal execution decisions and must be dispatched directly. Genuine host-native approval gates retain their real semantics; unavailable or unenforceable routes fail closed.
- Dispatch every child with a fresh, concise, self-contained assignment through exactly one plugin-scoped profile; children and nested children remain capped at High and never inherit conversational history. Include exact write ownership, plan-directory read-only boundary, checks, reporting shape, and explicit nested-delegation permission.

| Role | Profile | Exact route |
|---|---|---|
| Strong judgment, architecture, security, migration, independent review | `ant:strong-high` | `opus` + `high` |
| Integration and normal implementation | `ant:balanced-high` | `sonnet` + `high` |
| Bounded investigation, slice, validation | `ant:balanced-medium` | `sonnet` + `medium` |
| Narrow work requiring explicit Low | `ant:controlled-low` | `sonnet` + `low` |
| Narrow inventory or deterministic check | `ant:fast` | `sonnet` + `low` |

- Every assignment must include the full recursive capsule from [lifecycle.md](lifecycle.md), including route/preflight, fresh isolation, outcome, acceptance, non-goals, ownership, checks, delegation, and report/escalation topology. If nested delegation is absent, return the need to the parent and do not delegate.
- Hard-gate tracked orchestration before any tracked work: Claude must be version 2.1.219 or newer; root must be verified as `best` + `max`; ordinary root-level `Agent` dispatch must be available; `CLAUDE_CODE_SUBAGENT_MODEL` must be unset or exactly `inherit`; each per-invocation child model must be omitted or exactly match its selected profile; `CLAUDE_CODE_EFFORT_LEVEL` must be entirely unset; and profile, allowlist, cap, isolation, and runtime metadata must be exact. Any failure stops before tracked work. Stop and discard a mismatched child result before correcting and re-dispatching.
- Routine operational communication and repair/test/re-review loops stay local. The integration owner consolidates worker/tester deltas. Settled compact deltas go to the parent; material, disputed, authority, public-contract, security, migration, or repeated-failure issues escalate to root. The reviewer never writes fixes.
- Preferred topology keeps agent teams effectively off, uses a named balanced-high owner and local messaging where supported, and root-dispatches a named strong-high reviewer. If named/nested capability is unavailable, use the safe unnamed ordinary fallback with sequential owner work and fresh unnamed reviewer/owner redispatch. If exact unnamed dispatch cannot be enforced, hard stop.
- The same underlying defect or check unresolved after two completed local repair-and-verification cycles escalates to root. Distinct or resolved routine failures stay local; evidence conflicts and authority ambiguity escalate immediately.

## Decisions And Recovery

- Only root communicates with the user and owns material decisions. Treat permission denials and native user-only gates according to their actual semantics; never weaken the durable plan or let root become a tracked implementation writer.
- After review starts, tracked mutation invalidates affected review and all candidate-bound broad-gate/smoke evidence. Repeat targeted checks, obtain affected-area review, freeze the new candidate, and verify one refreshed broad gate under [lifecycle.md](lifecycle.md).
- Recover interruption/compaction by reconciling the durable plan against git state, native task/thread state, checkpoints, reports, findings, and actual diff. Correct stale phase status and update `progress.md` before resuming.

## Interactive Browser Smoke

- Existing automated browser/E2E tests remain ordinary risk-based validation. Any side-effecting or agent-driven interactive smoke runs only when explicitly requested or required by repository/acceptance criteria; otherwise do not preflight or run it.
- When requested/required, preflight URL, start command/health, worktree/port, browser, auth/session, test data, side effects, cleanup, and evidence. Plan each scenario as an action plus expected postcondition; screenshots supplement assertions. Required smoke affects readiness when it fails or cannot run.
