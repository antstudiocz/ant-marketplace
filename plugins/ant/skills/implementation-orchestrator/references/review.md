# Independent review

This reference owns review selection, independence, assessment scope, findings, and review evidence for plan and candidate review. The shared [lifecycle](lifecycle.md) owns implementation authority, review-workflow selection and timing, candidate freeze, repair, and final outcome.

## Plan review

- Use this phase only when the [selected review workflow](lifecycle.md#selected-review-workflow) includes it. A fresh, isolated, read-only reviewer receives the proposed plan, base, relevant source, and contracts, without author assurances.
- Assess architecture, viable alternatives, ownership, dependencies, operability, and whether targeted verification can show the outcome. Apply the same [assessment scope](#assessment-scope) where the plan determines it.
- Record the actual plan author and reviewer providers and routes. Implementation authorship sets the opposite-provider rule; a same-provider plan review satisfies this phase when it was explicitly selected and independence is verified.
- Record the plan input hash and base, each finding's disposition, the decision, and the accepted plan revision.

## Select reviewers

- Assign one independent overall reviewer to assess the objective, required scenarios, candidate, contracts, and evidence. The review covers the whole outcome, not only changed lines, and assesses its concept and architecture as well as functional evidence.
- Record implementation authorship from the actual owner route and substantive changes, not root's provider. For a single-provider candidate, the overall reviewer must be from the other provider: OpenAI-authored work is reviewed by Anthropic, and Anthropic-authored work by OpenAI. For mixed authorship, route review so each consequential contribution is covered by an opposite-provider reviewer; report any uncovered segment.
- The active adapter owns the concrete route and preflight. Verify provider/model identity, availability, and required read-only capability before dispatch. Preserve an explicit user model choice even when it conflicts with the cross-provider requirement: report the unmet requirement to root, who honors the choice and records the coverage gap. Do not silently substitute a model, change route, use an unapproved external route, or bypass a host control. Ask the user only if a consequential decision remains genuinely unresolved. If cross-provider review cannot be enforced, report that coverage as unavailable or unverified and leave the required review outcome pending; other authorized implementation and checks may continue.
- Root selects a specialist only when the actual change or risk needs focused expertise, and briefly states why each selected specialty applies or why overall-only review is sufficient. Keep that rationale proportional; no special form is required. Possible areas include architecture; data; SQL/performance; locking/concurrency; cache; security/tenant isolation; frontend/accessibility; integration/recovery; migration/operations; and test quality. Each specialist gets a concrete question, the relevant candidate paths/contracts plus any related read-only paths, and the evidence that would support an answer. Use the [dispatch capsule](lifecycle.md#dispatch-capsule) for the rest of the assignment. Use relevant existing skills as applicable and report expertise or evidence gaps; avoid generic prompts such as “check performance.” The overall reviewer remains accountable for the whole outcome; specialists add targeted evidence, not votes.
- The overall review's first pass receives the objective/task, immutable candidate, relevant contracts, and evidence. Do not include implementer assurances or peer-review conclusions. Specialists likewise inspect their assigned question independently before receiving others' conclusions.

## Assessment scope

- Evaluate, where relevant to the change: repository standards; security, tenant isolation, and contracts; concurrency and failure handling; tests; maintainability with the [simplicity and architecture review](lifecycle.md#simplicity-and-architecture) and proportionate SOLID/DRY; and, for UI or product help and guidance, the project's design system, accessibility, and responsive behavior.
- General principles alone do not justify unrelated refactoring. Reviewers stay independent and read-only.

## Findings and repair

- A useful finding states the trigger, impact, affected source or contract with its revision, supporting evidence, and the smallest repair that resolves it. Assess severity from the evidenced trigger and plausible impact, not reviewer count or confidence scores. Give a bounded reproduction or measurement when direct evidence needs one; distinguish observation from inference.
- The implementer verifies each finding and proposes or makes any in-scope repair. The independent reviewer verifies the repair. Root adjudicates evidence disputes and decides whether the acceptance criteria are met; reviewer agreement, votes, or confidence scores are not proof.
- Disposition each finding as **confirmed**, **refuted**, or **unverified**, with the evidence and reason. Keep credible potentially material unverified findings visible for root adjudication. Do not mark the affected outcome achieved or merge-ready solely because a finding could not be reproduced or was raised by one reviewer. A draft may proceed under its existing authority with the material gap stated; the affected broader outcome remains pending until root resolves the evidence or the risk.
- Bound review and repair to the evidence: do not repeat a round without a material new finding, changed candidate, or new evidence. Escalate unresolved evidence disputes to root. This does not waive a proven unmet outcome or broaden implementation authority.
- A candidate change invalidates review and evidence only where its impact can reach. Re-review and rerun affected checks; preserve unrelated evidence with a concrete impact rationale. Review after a tracked mutation must identify the candidate it covers.

## Outcome evidence

- Match each claim to evidence for the actual changed behavior and candidate. A `200` response, screenshot, passing test, or other proxy alone does not establish an end-user flow.
- For changed user flows, interact with the running product through each relevant final scenario. Distinguish create from reuse and repeat/idempotent behavior, UI behavior from provider end-to-end processing, and synthetic fixtures from production data. Follow the active adapter's browser route. Report unavailable access or side-effect limits as gaps.
- Preserve prior browser evidence after a test-only change only when the affected behavior is demonstrably unchanged; state the impact rationale. Keep evidence tied to candidate and environment when that can affect the result.
- Before handoff, state the final candidate and runtime/environment identity, or why runtime evidence does not apply; each actual reviewer's provider/model, available effort evidence, phase, and scope, plus unavailable or unverified route coverage; checks performed or not applicable; and browser-flow coverage or why it does not apply. This is a concise evidence inventory, not a required artifact format.
- Apply the separate [worked review scenarios](review-scenarios.md) as manual decision examples. Their inputs and expected decisions are instructional examples, not evidence that a review, test, or browser flow was actually run.

Consider a compact sample of historical pull requests for future calibration only when evidence supports the need; this policy does not claim measured reviewer accuracy or prescribe an evaluation system.
