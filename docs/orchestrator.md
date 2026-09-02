# Implementation Orchestrator

This is the detailed user-facing guide for `implementation-orchestrator`. The skill remains instruction-only: it uses a human-readable Git-tracked plan, not a custom runtime, hooks, machine state schema, event log, lease protocol, compatibility reader, generated validator, or synthetic evaluator.

## Lifecycle And Authority

1. Classify the request as **analysis-only**, **implementation-authorized**, or **ambiguous**.
2. Discover repository instructions, git state, contracts, risks, and checks without edits. For new or material work, ask about every material fact not discoverable in the repository/environment.
3. Present a concise chat plan, then create the detailed root-owned bundle at `docs/implementation-plans/YYYY/MM/<slug>/README.md`. Add `specification.md`, `decisions.md`, `implementation.md`, and `progress.md` for substantial work. The README is the stable entrypoint and the supporting files are complementary.
4. Resolve material decisions before dispatch. The durable plan is the shared planning gate; host-provided planning UI is optional and never blocks work. Codex additionally requires a matching native Goal; Claude Goal support is optional.
5. Select continuity (in-place evolution, accepted integrated replacement in a dedicated checkout, or isolated handoff) and record its implications in the plan and, when Codex or an opted-in native Goal is in use, its Goal. Do not retain unauthorized fallback paths or shims.
6. After the durable-plan gate and, for Codex or an opted-in native Goal, its matching Goal gate, dispatch one integration owner and only disjoint workers with complete recursive capsules. Children read plan files and report evidence; root alone writes plan/progress/checkpoints.
7. Run targeted checks after coherent phases. Root updates the plan at decision resolution, phase start/completion, stable delta, recovery, review readiness, and immediately before freeze.
8. Obtain independent strong review, freeze one candidate, and verify exactly one risk-appropriate broad gate (local suite or qualifying exact-candidate CI). Do not mutate the plan after freeze merely to record terminal gate results.
9. Perform the root-owned retrospective and keep delivery separate from implementation readiness.

Root is the sole user-facing and material adjudicator. Root owns decisions, applicable Goal lifecycle, phase status, recovery, candidate freeze, final-gate verification, retrospective, and readiness, but may not write source, tests, configuration, or general documentation. The integration owner writes and consolidates those implementation areas. The independent strong reviewer never writes fixes. The plan directory is root-write/child-read-only.

## Recursive Routing Capsule

Every child assignment, recursively, includes:

| Field | Required content |
|---|---|
| Route | Exact active-adapter model/profile and effort; Codex `fork_turns="none"`. |
| Context | Fresh isolated task-local context; no history inheritance. |
| Ownership | Measurable outcome, acceptance, non-goals, exact write ownership, shared boundaries, and targeted checks. |
| Plan boundary | Plan directory explicitly marked root-only for writes and read-only for the child. |
| Delegation | Explicit yes/no; if yes, permitted nested routes, effort ceiling, and a complete recursive capsule. |
| Reporting | Checkpoint shape: phase/status, files/areas, validation, discoveries/decisions, proposed plan delta, risks/blockers. |

Routine repair/test/re-review stays local. Settled deltas return to the parent/integration owner. Material, disputed, authority, public-contract, security, migration, or repeated-failure issues escalate to root. Every child remains capped at High; unavailable or unenforceable routes fail closed.

## Host Matrix And Preflight

| Host/role | Exact route | Required preflight |
|---|---|---|
| Claude root | `best` + `max` | Verify current host/session/task metadata; `opusplan` is not a route. |
| Claude strong/reviewer | `ant:strong-high` → `opus` + `high` | Claude ≥2.1.219, verified root route, ordinary `Agent`, exact profile/allowlist/cap/isolation, no conflicting model/effort environment overrides. |
| Claude integration | `ant:balanced-high` → `sonnet` + `high` | Same exact child route, fresh-context, isolation, and capsule checks. |
| Claude bounded | `ant:balanced-medium` → `sonnet` + `medium`; `ant:controlled-low`/`ant:fast` → `sonnet` + `low` | Profile supplies effort; global `CLAUDE_CODE_EFFORT_LEVEL` is unset. |
| Codex strong/reviewer | `gpt-5.6-sol` + High | Explicit model, effort, fresh context, isolation, complete capsule, and `fork_turns="none"`. |
| Codex integration | `gpt-5.6-luna` + High | Same explicit route and capsule checks. |
| Codex narrow | `gpt-5.6-luna` + proportional High/Medium/Low | Never above High; no Terra fallback. |

Claude requires `CLAUDE_CODE_SUBAGENT_MODEL` unset or exactly `inherit`, per-invocation model omitted or matching the selected profile, and no auto-added teammate metadata. If exact routing cannot be enforced, stop before tracked work. Codex root model/effort is developer-selected; its required native Goal remains fail-closed.

## Durable Plan And Goal Rules

The plan README must contain the stable measurable objective, acceptance, scope/non-goals, continuity, repository findings/analysis, material decisions and rationale/open questions, ownership, risks, checks, current phase/status, a `Resume from here` exact next action, and relative links to supporting docs. Use proportionate statuses: `specifying`, `ready`, `in_progress`, `blocked`, `completed`, or `superseded`. An unresolved material decision blocks its affected scope. Root reconciles the plan with Codex Goal, or with an optional native Goal confirmed in use: stable in-objective deltas update the plan; material outcome/public-contract deltas pause work and use applicable Goal collision rules. Plan-file creation/update authority applies only to the planning bundle and never authorizes product implementation or delivery; analysis-only remains read-only.

Codex uses `get_goal`/`create_goal` to inspect or establish a matching Goal and `update_goal` only for terminal `complete` or `blocked` closure. Those operations do not represent phase progress. Never replace, complete, or block an unrelated unfinished Goal; ask root/user to resolve the collision through native controls. Claude's optional Goal is non-blocking, applies these rules only when confirmed in use, and never overrides the durable plan.

## Review And Candidate Validation

Tracked mutation after review begins invalidates affected review and candidate evidence. Repair findings, rerun targeted checks, obtain affected-area re-review, update the plan, and freeze a new candidate. Select the single broad gate from blast radius, reversibility, test-selection confidence, and environment parity: low-blast-radius, reversible, high-confidence, parity-aligned work may use the smallest qualifying gate; shared/public, hard-to-reverse, low-confidence, or parity-gapped work needs broader or risk-specific evidence. CI substitutes for the local broad suite only with separately authorized publication, an exact tested SHA/source mapping, equivalent or broader coverage, present successful required jobs, and passing targeted/risk-specific checks. Missing, skipped, neutral, timed-out, mismatched, or incomplete CI is unverified. Delivery belongs exclusively to `merge-request`.

Existing browser/E2E automation is ordinary risk-based validation. Side-effecting or interactive smoke runs only when explicitly requested or required by repository/acceptance criteria. If applicable, the active adapter preflights URL/start health, worktree/port, browser, auth, data, side effects, cleanup, and evidence; scenarios state actions and expected postconditions. Required smoke affects readiness; optional smoke may remain unverified.

## Recovery And Completion

On interruption or compaction, root reconciles the plan with Codex Goal state, or optional native Goal state confirmed in use, plus git/worktree/index, native task state, child reports, reviewer findings, and actual diffs; correct stale state, preserve one active phase, confirm ownership/routes, update `progress.md`, and resume only with current evidence. Root directly verifies the single broad gate, records retrospective/adjacent findings, and gives exactly one verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**.

For new applications, use [new-application intake](../plugins/ant/skills/implementation-orchestrator/references/new-application.md) to capture users, workflows, data/security, operations, architecture, acceptance, and non-goals before the durable plan.
