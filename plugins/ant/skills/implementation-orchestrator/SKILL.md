---
name: implementation-orchestrator
description: Use for end-to-end implementation work that classifies execution intent, requires repository discovery and a proportional plan before tracked edits, brainstorms new behavior, delegates implementation, review, verification, an execution retrospective, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for features, fixes, refactors, migrations, and remediation that should end in a verified implementation. For a new application or major app-like surface, start with `ant:create-application` when available and hand the approved brief here.

## Operating Contract

- The root orchestrator is the user-facing coordinator. It inspects repository instructions and git/delivery context, delegates implementation work, integrates reports, and keeps the user informed. It does not make tracked implementation edits while this skill is active. If no writer-capable native delegation is available, stop before tracked edits and report the blocker; the root never becomes the fallback writer.
- At intake, classify the request as **analysis-only**, **implementation-authorized**, or **ambiguous**. Explicit execution language—such as fix, implement, change, or test—authorizes implementation after discovery and plan presentation unless the user also says to propose a plan or wait for approval. Analysis-only stays read-only; for genuinely ambiguous requests, ask early which outcome the user wants before deep analysis.
- Every implementation starts with read-only repository discovery and a proportional plan before tracked writes. Presenting the plan is mandatory; waiting for another approval is required only when execution was not already authorized or a safety gate is reached. Proportionality changes depth, not whether discovery and planning happen.
- For implementation-authorized or later-approved work, establish the active host's native goal envelope after the objective and plan are stable and before dispatching a tracked writer. Do not create one for analysis-only or unresolved ambiguous work. It records the outcome, acceptance conditions, constraints, checks, and only delivery already authorized; it complements rather than replaces native planning or authorization. Close it only after the scoped implementation, required review, final validation, retrospective, and any included delivery are actually complete.
- For a new feature or materially new behavior, complete user-needs brainstorming and deeper technical analysis before preparing that plan. Read-only scouts are allowed before the execution gate.
- Keep execution proportional after the execution gate. A small change normally needs one implementation agent plus the required final independent reviewer; add scouts, slices, or specialist review only when scope or risk justifies them.
- Use the host's native planning, delegation, messaging, and recovery features. Do not create a custom orchestration runtime, state schema, event log, lease system, migration layer, or generated evaluator.
- Investigate the root cause before editing. Discover repository facts before asking the user, then ask every material product or technical question needed for an honest plan without an arbitrary question limit.
- Keep the root on the active host's strongest capability and maximum available reasoning effort for the entire run. If that control is not exposed or settable, use the strongest available root setting and state the limitation without claiming it is maximum.
- Select every child's native model and, where the model supports it, reasoning effort explicitly, independently, and through the active host's adapter. No child may exceed `High`; never allow root maximum effort to leak through inheritance. Every child and nested child receives a concise, self-contained assignment with the task-relevant facts; do not rely on inherited conversation history. If the host cannot safely enforce that ceiling or isolation, report the limitation and do not dispatch the child.
- Validate coherent work units with the smallest relevant checks. After the final tracked mutation and required review, run the repository's full suite once on the final tree before declaring the implementation complete, not after every edit or task. When delivery is requested, this is also the final pre-delivery suite.
- After the final suite, the root performs a bounded retrospective before completion or delivery. Use only observable evidence already available from the run, check correctness and total token/resource efficiency, and surface at most three findings without reconstructing hidden reasoning or inventing usage figures.
- Turn only a material, actionable, plausibly generalizable process finding into a sanitized upstream feedback candidate. Search the canonical repository's open and closed issues and PRs first, perform at most one feedback action per run, and require explicit current or clearly applicable standing approval for any issue write. Never auto-create a PR from the retrospective.
- Treat user messages during implementation as live input. Status questions and details within authorized behavior do not stop work. Batch related material changes or corrections received during the same active segment into one affected-scope discovery, brainstorming, analysis, delta-plan, and approval cycle at the next safe boundary while unaffected work continues; apply urgent stop or safety corrections immediately.
- Invoke plugin skills through the identifier visible in the active host: Claude Code `/ant:merge-request` or Codex `$merge-request` for every PR/MR creation or update, and Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only for merge-conflict resolution.
- When `merge-request` reports an in-scope MR/PR pipeline regression, own the bounded repair loop: delegate tracked remediation, targeted validation, independent review, and required final-suite refresh, then return delivery to `merge-request` for the update and replacement-pipeline observation. Do not make the root a tracked writer or turn `merge-request` into one.
- Preserve unrelated user changes and obey repository-specific package, validation, branch, and delivery rules.

## Proportional Flow

1. Classify intake as analysis-only, implementation-authorized, or ambiguous. Do only the minimal inspection needed to route the request and protect unrelated work; for ambiguous intent, ask whether the user wants analysis only or implementation too before substantive or deep discovery.
2. For analysis-only work, perform the appropriate read-only investigation and report. For implementation-authorized or clarified work, inspect repository instructions, git state, the relevant code path, and available validation commands without tracked edits.
3. For new or materially changed behavior, brainstorm the goal, users, workflows, edge cases, non-goals, options, and tradeoffs; ask all remaining material questions.
4. After the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply.
5. Produce and present a concrete proportional implementation plan. If execution was explicitly authorized and the plan remains within the original scope and risk, treat this as a progress checkpoint and continue; otherwise obtain explicit approval. Do not dispatch a tracked writer before presenting the plan.
6. Establish or reuse the host-native goal envelope through the active adapter, then choose the smallest useful execution shape, reuse active coverage, and dispatch materially distinct work with the active host adapter's explicit native model and, where supported, effort; delegate tracked edits to one implementation owner once the applicable execution gate has passed.
7. Run targeted checks after coherent phases, complete Strong-at-High final code review plus any risk-based specialist review, and fix the root cause of findings.
8. After the final tracked mutation and required review, run one final full validation on the final tree before declaring completion.
9. Perform the bounded root retrospective, correct any current implementation gap, and handle at most one qualified upstream feedback candidate within the user's external-write authority; then perform only the delivery actions the user requested.

A tiny mechanical change inside an already approved or otherwise authorized plan may use a compact discovery-and-plan cycle without asking for duplicate approval. A concrete user plan or an approved `create-application` brief may satisfy earlier product brainstorming after repository verification, but neither alone grants implementation authorization. An explicit end-to-end execution request can do so after plan presentation. Approval or authorization covers only the stable plan or workstream, not delivery or every implementation phase.

## Reference Loading

Before the first delegation or model/effort decision, read `references/lifecycle.md` and then exactly one active-host adapter: `references/codex.md` in Codex or `references/claude.md` in Claude Code. The lifecycle owns shared discovery, authorization, native-goal semantics, workflow shape, dispatch, validation, review, recovery, retrospective, and delivery rules; the adapter owns the host-specific goal and routing details. Do not load the inactive adapter or look for additional orchestrator role cards, templates, contracts, or evaluators.

## Completion

Finish with a concise summary of the outcome, changed areas, checks run, anything not verified, retrospective outcome, any material upstream feedback URL/candidate/blocker, and delivery state. Do not claim success from an agent report alone; confirm it against the final repository state and validation evidence.
