# Asynchronous orchestrator questions

- Status: ready; phase: delivery.
- Objective: integrate capability-aware asynchronous clarification into planning and implementation, and update existing draft PR 74.
- Authority: user approved this proposed addition; continuing the previously authorized draft PR delivery. No merge, release or deployment.
- Continuity: in-place evolution on docs/astra-instruction-cleanup in the existing isolated marketplace worktree.
- Scope: shared lifecycle policy, Codex tool mapping and concise orchestrator user guide. Preserve three public skills, instruction-only architecture, routes, Goal gates and root-only user communication.
- Decisions: ask only material undiscoverable questions; continue independent authorized work while dependent scope waits. Optional preferences permit a stated reasonable assumption after a fair chance to answer; required decisions and approvals cannot be inferred from silence or default options. Async tools cannot expand Plan mode or permissions. Root records pending decision, affected scope and eventual answer in this plan format; no extra runtime/state system.
- Evidence: current host exposes request_user_input_async, which returns immediately and receives user answers as later messages. Tool availability and mode rules override plugin guidance. Synchronous request_user_input is mode-dependent; never force it or emulate unsupported capabilities.
- Ownership: Luna High integration owner writes lifecycle.md, codex.md and docs/orchestrator.md only; independent Sol High reviewer is read-only. Root alone writes this plan directory and adjudicates/delivers. No nested delegation.
- Acceptance: early concise root questions; dependency-scoped continuation; answer reconciliation before affected work; explicit optional/required distinction; host-neutral shared policy; capability fallback; concise documentation without duplicate rule ownership.
- Checks: independent semantic review including planning-only, no async tool, required answer, optional unanswered preference and late reply; affected skill metadata/local links and git diff --check. No synthetic test framework needed for instruction-only change.
- Risks: treating silence as permission, implementing during planning, racing a reply with child work, introducing tool-specific shared policy or blocking all independent work.
- Candidate: root finalizes this checkpoint before freeze; later tracked edits invalidate affected review/checks.
- Resume from here: owner implements bounded policy/doc change, then root records review readiness and dispatches independent review.
- Implementation checkpoint: owner changed only shared lifecycle, Codex adapter and user guide; both Claude validators, four JSON manifests and whitespace checks passed. Stable candidate awaiting independent focused review.
- Final review: independent Sol High approved after qualifying plan recording/reconciliation by implementation authority and removing session-specific wait timing from the adapter. No remaining findings.
- Final gate: affected skill validator, Markdown link existence and whitespace checks passed; owner also ran both Claude validators and JSON parsing. Instruction-only blast radius supports this targeted gate; no synthetic/runtime tests added.
- Retrospective: capability-specific UI must preserve read-only planning and use live host interaction rules; shared policy remains canonical. Freeze now, update draft PR 74 and report exact-head provider checks without further plan mutations.
