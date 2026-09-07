# Implementation orchestrator guide

`implementation-orchestrator` coordinates implementation work that should finish as a reviewed and verified candidate. The entrypoint is intentionally short; the [shared lifecycle reference](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) owns detailed policy, and the [Codex](../plugins/ant/skills/implementation-orchestrator/references/codex.md) and [Claude Code](../plugins/ant/skills/implementation-orchestrator/references/claude.md) adapters own host-specific behavior.

## What happens

The orchestrator:

1. classifies the request as analysis-only, implementation-authorized, or ambiguous;
2. inspects repository facts and asks only for material unknowns;
3. records a root-owned plan before tracked edits;
4. applies the active host's Goal and child-route preflight;
5. dispatches a fresh, isolated integration owner and keeps root coordination-only;
6. obtains independent strong review, refreshes affected checks after changes, and verifies one risk-appropriate final gate.

Analysis-only work ends with evidence and findings and does not create or advance implementation state. New applications use the conditional [new-application intake](../plugins/ant/skills/implementation-orchestrator/references/new-application.md).

Material questions are scoped to the affected work: independent authorized work can continue while dependent scope waits, optional preferences can proceed after a stated reasonable assumption, and required decisions or approvals remain pending. During implementation, answers, including late replies, are reconciled into the plan and affected evidence. The shared policy is in the [lifecycle reference](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md); host-specific async input and fallback behavior is in the [Codex adapter](../plugins/ant/skills/implementation-orchestrator/references/codex.md).

## Authority

Root is the sole user-facing adjudicator. Root owns decisions, plan checkpoints, Goal lifecycle, recovery, freeze, final verification, retrospective, and readiness, and writes only the scoped plan bundle. The integration owner writes scoped source, configuration, tests, and general documentation. The independent strong reviewer reads and reports findings but never writes fixes. Children read the plan and report to their parent; they cannot write the plan directory.

The plan and any established Goal describe the same measurable outcome. Goal handling follows the [shared lifecycle](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) and active host adapter. On Codex, Goals are default-on through the [Codex adapter](../plugins/ant/skills/implementation-orchestrator/references/codex.md); optional fallback remains subject to host authority and truthful reporting. A Goal never grants permission or replaces the plan, and unrelated Goals remain protected. Host permissions and controls take precedence.

## Routing

Every child receives a complete capsule: exact model/profile and effort, fresh isolated context, outcome and acceptance, non-goals, write ownership, checks, root-only plan boundary, delegation permission, and reporting/escalation path. Children remain capped at High.

For Codex, the normal owner is `gpt-5.6-luna` at High and the independent strong reviewer is `gpt-5.6-sol` at High. Narrow work uses Luna at proportional High, Medium, or Low. For Claude Code, the owner is `ant:balanced-high` (`sonnet` + High) and the reviewer is `ant:strong-high` (`opus` + High); bounded profiles are selected by the adapter. If the exact route, freshness, isolation, or required host metadata cannot be enforced, stop before tracked work.

## Validation and delivery

Run checks affected by coherent changes and avoid repeating equivalent evidence without a new change or risk reason. A tracked mutation after review invalidates affected review and candidate-bound checks. Freeze one exact tree/SHA and choose one broad gate using blast radius, reversibility, test confidence, and environment parity. Qualifying exact-candidate CI may replace the local gate only when its source-to-tested mapping, coverage, required jobs, and terminal success are authoritative; otherwise use the appropriate local gate.

Interactive smoke is optional unless explicitly requested or required by acceptance criteria. Provider delivery, merge, release, and deployment remain separate authority and belong to [`merge-request`](../plugins/ant/skills/merge-request/SKILL.md). Completion has one lifecycle verdict: **NOT READY**, **CONDITIONALLY READY**, **READY TO DEPLOY**, or **DEPLOYED & VERIFIED**.
