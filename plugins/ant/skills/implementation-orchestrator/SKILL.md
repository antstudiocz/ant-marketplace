---
name: implementation-orchestrator
description: Use for end-to-end implementation work that requires repository discovery, user-needs brainstorming for new behavior, an explicitly approved implementation plan before tracked edits, delegated implementation, review, verification, an execution retrospective, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for features, fixes, refactors, migrations, and remediation that should end in a verified implementation. For a new application or major app-like surface, start with `ant:create-application` when available and hand the approved brief here.

## Operating Contract

- The root orchestrator is the user-facing coordinator. It inspects repository instructions and git/delivery context, delegates implementation work, integrates reports, and keeps the user informed. It does not make tracked implementation edits while this skill is active. If no writer-capable native delegation is available, stop before tracked edits and report the blocker; the root never becomes the fallback writer.
- Every implementation starts with read-only repository discovery, a proportional plan, and explicit user approval before tracked writes. Proportionality changes their depth, not whether they happen.
- For a new feature or materially new behavior, complete user-needs brainstorming and deeper technical analysis before preparing that plan. Read-only scouts are allowed before approval.
- Keep execution proportional after approval. A small change normally needs one implementation agent plus the required final independent reviewer; add scouts, slices, or specialist review only when scope or risk justifies them.
- Use the host's native planning, delegation, messaging, and recovery features. Do not create a custom orchestration runtime, state schema, event log, lease system, migration layer, or generated evaluator.
- Investigate the root cause before editing. Discover repository facts before asking the user, then ask every material product or technical question needed for an honest plan without an arbitrary question limit.
- Keep the root on the active host's strongest capability and maximum available reasoning effort for the entire run. If that control is not exposed or settable, use the strongest available root setting and state the limitation without claiming it is maximum.
- Select every child's native model and, where the model supports it, reasoning effort explicitly, independently, and through the active host's adapter. No child may exceed `High`; never allow root maximum effort to leak through inheritance. If the host cannot safely enforce that ceiling, report the limitation and do not dispatch the child.
- Validate coherent work units with the smallest relevant checks. After the final tracked mutation and required review, run the repository's full suite once on the final tree before declaring the implementation complete, not after every edit or task. When delivery is requested, this is also the final pre-delivery suite.
- After the final suite, the root performs a bounded retrospective before completion or delivery. Use only observable evidence already available from the run, check correctness and total token/resource efficiency, and surface at most three findings without reconstructing hidden reasoning or inventing usage figures.
- Turn only a material, actionable, plausibly generalizable process finding into a sanitized upstream feedback candidate. Search the canonical repository's open and closed issues and PRs first, perform at most one feedback action per run, and require explicit current or clearly applicable standing approval for any issue write. Never auto-create a PR from the retrospective.
- Treat user messages during implementation as live input. Status questions and details within approved behavior do not stop work. Batch related material changes or corrections received during the same active segment into one affected-scope discovery, brainstorming, analysis, delta-plan, and approval cycle at the next safe boundary while unaffected work continues; apply urgent stop or safety corrections immediately.
- Invoke plugin skills through the identifier visible in the active host: Claude Code `/ant:merge-request` or Codex `$merge-request` for every PR/MR creation or update, and Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only for merge-conflict resolution.
- Preserve unrelated user changes and obey repository-specific package, validation, branch, and delivery rules.

## Proportional Flow

1. Inspect instructions, git state, the relevant code path, and available validation commands without tracked edits.
2. For new or materially changed behavior, brainstorm the goal, users, workflows, edge cases, non-goals, options, and tradeoffs; ask all remaining material questions.
3. After the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply.
4. Produce a concrete proportional implementation plan and obtain explicit user approval. Do not dispatch a tracked writer before this gate.
5. Choose the smallest useful execution shape, reuse active coverage, and dispatch materially distinct work with the active host adapter's explicit native model and, where supported, effort; delegate tracked edits to one implementation owner after approval.
6. Run targeted checks after coherent phases, complete Strong-at-High final code review plus any risk-based specialist review, and fix the root cause of findings.
7. After the final tracked mutation and required review, run one final full validation on the final tree before declaring completion.
8. Perform the bounded root retrospective, correct any current implementation gap, and handle at most one qualified upstream feedback candidate within the user's external-write authority; then perform only the delivery actions the user requested.

A tiny mechanical change inside an already approved plan may use a compact discovery-and-plan cycle without asking for duplicate approval. A concrete user plan or an approved `create-application` brief may satisfy earlier product brainstorming after repository verification, but the implementation plan still requires approval before writes. Approval covers the stable plan or workstream, not every implementation phase.

## Reference Loading

Before the first delegation or model/effort decision, read `references/lifecycle.md` and then exactly one active-host adapter: `references/codex.md` in Codex or `references/claude.md` in Claude Code. The lifecycle owns shared discovery, approval, workflow shape, dispatch, validation, review, recovery, retrospective, and delivery rules; the adapter owns the host-specific routing details. Do not load the inactive adapter or look for additional orchestrator role cards, templates, contracts, or evaluators.

## Completion

Finish with a concise summary of the outcome, changed areas, checks run, anything not verified, retrospective outcome, any material upstream feedback URL/candidate/blocker, and delivery state. Do not claim success from an agent report alone; confirm it against the final repository state and validation evidence.
