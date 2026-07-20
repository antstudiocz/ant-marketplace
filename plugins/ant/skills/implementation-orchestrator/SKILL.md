---
user-invocable: true
name: implementation-orchestrator
description: Use for end-to-end implementation work that requires repository discovery, user-needs brainstorming for new behavior, an explicitly approved implementation plan before tracked edits, delegated implementation, review, verification, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for features, fixes, refactors, migrations, and remediation that should end in a verified implementation. For a new application or major app-like surface, start with `ant:create-application` when available and hand the approved brief here.

## Operating Contract

- The root orchestrator is the user-facing coordinator. It inspects repository instructions and git/delivery context, delegates implementation work, integrates reports, and keeps the user informed. It does not make tracked implementation edits while this skill is active. If no writer-capable native delegation is available, stop before tracked edits and report the blocker; the root never becomes the fallback writer.
- Every implementation starts with read-only repository discovery, a proportional plan, and explicit user approval before tracked writes. Proportionality changes their depth, not whether they happen.
- For a new feature or materially new behavior, complete user-needs brainstorming and deeper technical analysis before preparing that plan. Read-only scouts are allowed before approval.
- Keep execution proportional after approval. A small change normally needs one implementation agent; add scouts, slices, or an independent reviewer only when scope or risk justifies them.
- Use the host's native planning, delegation, messaging, and recovery features. Do not create a custom orchestration runtime, state schema, event log, lease system, migration layer, or generated evaluator.
- Investigate the root cause before editing. Discover repository facts before asking the user, then ask every material product or technical question needed for an honest plan without an arbitrary question limit.
- Route agents by required capability, not by a model name embedded in shared instructions. Model and reasoning selection must work in both Claude Code and Codex.
- Reassess reasoning during the work. Escalate for new ambiguity, risk, contradictions, or repeated failures; de-escalate for bounded deterministic segments. Avoid rapid tier switching.
- Validate coherent work units with the smallest relevant checks. After the final tracked mutation and required review, run the repository's full suite once on the final tree before declaring the implementation complete, not after every edit or task. When delivery is requested, this is also the final pre-delivery suite.
- Treat user messages during implementation as live input. Status questions and details within approved behavior do not stop work. Batch related material changes or corrections received during the same active segment into one affected-scope discovery, brainstorming, analysis, delta-plan, and approval cycle at the next safe boundary while unaffected work continues; apply urgent stop or safety corrections immediately.
- Invoke plugin skills through the identifier visible in the active host: Claude Code `/ant:merge-request` or Codex `$merge-request` for every PR/MR creation or update, and Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only for merge-conflict resolution.
- Preserve unrelated user changes and obey repository-specific package, validation, branch, and delivery rules.

## Proportional Flow

1. Inspect instructions, git state, the relevant code path, and available validation commands without tracked edits.
2. For new or materially changed behavior, brainstorm the goal, users, workflows, edge cases, non-goals, options, and tradeoffs; ask all remaining material questions.
3. After the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply.
4. Produce a concrete proportional implementation plan and obtain explicit user approval. Do not dispatch a tracked writer before this gate.
5. Choose the smallest useful execution shape, route agents by capability, and delegate tracked edits to one implementation owner after approval.
6. Run targeted checks after coherent phases, review in proportion to risk, and fix the root cause of findings.
7. After the final tracked mutation and required review, run one final full validation on the final tree before declaring completion, then perform only the delivery actions the user requested.

A tiny mechanical change inside an already approved plan may use a compact discovery-and-plan cycle without asking for duplicate approval. A concrete user plan or an approved `create-application` brief may satisfy earlier product brainstorming after repository verification, but the implementation plan still requires approval before writes. Approval covers the stable plan or workstream, not every implementation phase.

## Reference Loading

Read `references/lifecycle.md` before the first delegation or implementation decision. It is the single internal reference for discovery, brainstorming, approval, workflow shape, routing, adaptive reasoning, user messages, validation, review, recovery, and delivery. Do not look for additional orchestrator role cards, templates, contracts, or evaluators.

## Completion

Finish with a concise summary of the outcome, changed areas, checks run, anything not verified, and delivery state. Do not claim success from an agent report alone; confirm it against the final repository state and validation evidence.
