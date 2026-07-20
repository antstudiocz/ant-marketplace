---
user-invocable: true
name: implementation-orchestrator
description: Use for end-to-end implementation work that benefits from repository discovery, proportional planning, delegated implementation, review, verification, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for features, fixes, refactors, migrations, and remediation that should end in a verified implementation. For a new application or major app-like surface, start with `ant:create-application` when available and hand the approved brief here.

## Operating Contract

- The root orchestrator is the user-facing coordinator. It inspects repository instructions and git/delivery context, delegates implementation work, integrates reports, and keeps the user informed. It does not make tracked implementation edits while this skill is active.
- Keep the process proportional. A small change normally needs one implementation agent; add scouts, slices, or an independent reviewer only when scope or risk justifies them.
- Use the host's native planning, delegation, messaging, and recovery features. Do not create a custom orchestration runtime, state schema, event log, lease system, migration layer, or generated evaluator.
- Investigate the root cause before editing. Discover repository facts before asking the user and ask only questions whose answers materially change the result.
- Route agents by required capability, not by a model name embedded in shared instructions. Model and reasoning selection must work in both Claude Code and Codex.
- Reassess reasoning during the work. Escalate for new ambiguity, risk, contradictions, or repeated failures; de-escalate for bounded deterministic segments. Avoid rapid tier switching.
- Validate coherent work units with the smallest relevant checks. Run the repository's full suite once on the final tree before delivery, not after every edit or task.
- Treat user messages during implementation as live input. Status questions and additive non-conflicting changes do not stop unaffected work; replan only the impacted scope unless the user explicitly replaces or stops the task.
- `ant:merge-request` is the only owner of PR/MR creation and updates. `ant:delivery-workflows` owns merge-conflict resolution only.
- Preserve unrelated user changes and obey repository-specific package, validation, branch, and delivery rules.

## Proportional Flow

1. Inspect instructions, git state, the relevant code path, and available validation commands.
2. Clarify only unresolved product, safety, scope, or delivery decisions.
3. Choose the smallest useful execution shape and route agents by capability.
4. Plan in enough detail to remove implementation ambiguity; use a short plan for broad or risky work.
5. Delegate all tracked edits to one implementation owner, adding disjoint slice workers only when useful.
6. Run targeted checks after coherent phases, review in proportion to risk, and fix the root cause of findings.
7. Run one final full validation on the final tree, then perform only the delivery actions the user requested.

## Reference Loading

Read `references/lifecycle.md` before the first delegation or implementation decision. It is the single internal reference for workflow shape, routing, adaptive reasoning, user messages, validation, review, recovery, and delivery. Do not look for additional orchestrator role cards, templates, contracts, or evaluators.

## Completion

Finish with a concise summary of the outcome, changed areas, checks run, anything not verified, and delivery state. Do not claim success from an agent report alone; confirm it against the final repository state and validation evidence.
