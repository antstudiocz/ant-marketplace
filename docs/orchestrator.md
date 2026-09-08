# Implementation orchestrator guide

`implementation-orchestrator` coordinates implementation work that should finish as a reviewed and verified candidate. The entrypoint is intentionally short; the [shared lifecycle reference](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) owns detailed policy, and the [Codex](../plugins/ant/skills/implementation-orchestrator/references/codex.md) and [Claude Code](../plugins/ant/skills/implementation-orchestrator/references/claude.md) adapters own host-specific behavior.

## What happens

The orchestrator:

1. classifies the request as analysis-only, implementation-authorized, or ambiguous;
2. inspects repository facts and asks only for consequential missing human intent or authority;
3. records a root-owned plan before tracked edits;
4. applies the active adapter's Goal preflight when applicable, plus the child-route preflight;
5. dispatches a fresh, isolated integration owner and keeps root coordination-only;
6. obtains independent strong review, refreshes affected checks after changes, and verifies one risk-appropriate final gate.

Before implementation or analysis, it derives the goal, scenarios, and observable completion criteria, then selects proportional outcome evidence for the changed surface and risk. The [shared evidence and quality policy](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#evidence-and-quality) requires fact-checked claims, realistic-state verification for changed user-visible behavior, and independent whole-outcome review; unknowns and material limitations remain visible. In-scope findings are repaired and reverified under existing authority.

Cadence is chosen separately from continuity: incremental work validates coherent increments, while a one-time sweep may defer routine per-feature checks in an isolated checkout after risk-needed early architecture and integration evidence, review, or probes. Both use the same final evidence, review, and repair requirements; see the [verification cadence policy](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#verification-cadence).

Analysis-only work ends with evidence and findings and does not create or advance implementation state. New applications use the conditional [new-application intake](../plugins/ant/skills/implementation-orchestrator/references/new-application.md).

Questions are limited to consequential missing human intent or impacts outside established authority: independent authorized work can continue while dependent scope waits, optional preferences can proceed after a stated reasonable assumption, and required decisions or approvals remain pending. Agents resolve routine in-scope technical choices from repository evidence and proportional risk. During implementation, answers, including late replies, are reconciled into the plan and affected evidence. The shared policy is in the [lifecycle reference](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md); host-specific async input and fallback behavior is in the [Codex adapter](../plugins/ant/skills/implementation-orchestrator/references/codex.md).

## Authority

Root is the sole user-facing adjudicator. Root owns decisions, plan checkpoints, Goal lifecycle, recovery, freeze, final verification, retrospective, and readiness, and writes only the scoped plan bundle. The integration owner writes scoped source, configuration, tests, and general documentation. The independent strong reviewer reads and reports findings but never writes fixes. Children read the plan and report to their parent; they cannot write the plan directory.

The plan and any established Goal describe the same measurable outcome. Goal handling follows the [shared lifecycle](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) and active host adapter. On Codex, Goals are handled only when explicitly requested or already in use; missing or unavailable optional Goal support never blocks otherwise-authorized work under the plan, while an explicitly requested Goal remains pending until established and verified. A Goal never grants permission or replaces the plan, and unrelated Goals remain protected. Cross-thread handoffs preserve consent provenance, scope bounds, the exact follow-up, and any proposed delta; the receiving agent verifies that context under the shared lifecycle. Host permissions and controls take precedence.

## Routing

Every child receives a complete capsule: exact model/profile and effort, fresh isolated context, outcome and acceptance, selected verification cadence from the [cadence policy](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#verification-cadence), outcome evidence and realistic states required by the [shared evidence and quality policy](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#evidence-and-quality), risk-needed early evidence/review/probes and deferred routine checks, non-goals, write ownership, checks, root-only plan boundary, delegation permission, and reporting/escalation path. Children remain capped at High.

For Codex, the normal owner is `gpt-5.6-luna` at High and the independent strong reviewer is `gpt-5.6-sol` at High. Narrow work uses Luna at proportional High, Medium, or Low. For Claude Code, the owner is `ant:balanced-high` (`sonnet` + High) and the reviewer is `ant:strong-high` (`opus` + High); bounded profiles are selected by the adapter. If the exact route, freshness, isolation, or required host metadata cannot be enforced, stop before tracked work.

## Validation and delivery

Apply the selected verification cadence and avoid repeating equivalent evidence without a new change or risk reason. A tracked mutation after final candidate review invalidates affected final review and candidate-bound checks. Freeze one exact tree/SHA and choose one broad gate using blast radius, reversibility, test confidence, and environment parity. Qualifying exact-candidate CI may replace the local gate only when its source-to-tested mapping, coverage, required jobs, and terminal success are authoritative; otherwise use the appropriate local gate.

Choose appropriate interaction evidence when changed behavior and risk require it; a special smoke request is not required. The active adapter preflights environment and side effects. Classify the requested endpoint as implementation-only, draft PR/MR create/update, or explicitly merge-ready; the shared [lifecycle](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) owns handoff provenance, endpoint completion, and final reporting. Provider delivery follows the explicit Create/update authority in [`merge-request`](../plugins/ant/skills/merge-request/SKILL.md); evidence gathering never expands authority, effects outside established authority require appropriate explicit authorization, and merge, release, and deployment retain separate authority. Completion uses the lifecycle's achieved/pending/blocked outcome with its evidence, gaps, and next permitted action. A draft artifact cannot complete a broader implementation, and an explicitly partial/WIP endpoint remains limited and truthful.
