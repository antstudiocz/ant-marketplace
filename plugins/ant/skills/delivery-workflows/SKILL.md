---
user-invocable: true
name: delivery-workflows
description: Use for Git/GitLab delivery workflows: creating merge requests, handling MR feedback, resolving merge conflicts, and executing or routing existing implementation plans.
---

# Delivery Workflows

Use this skill for repository delivery work around merge requests, review feedback, conflicts, and plan execution. It is not the primary implementation orchestrator; use `implementation-orchestrator` for end-to-end feature/fix work from brainstorming through verification.

Reference files may contain original skill frontmatter. Treat it as reference metadata, not as separate skill invocation.

## Reference Selection

- Create a GitLab merge request from local changes: `references/create-mr.md`.
- Analyze and address GitLab MR review feedback: `references/handle-mr-feedback.md`.
- Resolve local or MR merge conflicts with context: `references/merge-conflicts.md`.
- Execute an existing implementation plan or route legacy plan execution: `references/execute-plan.md`; prefer `implementation-orchestrator` when the work needs planning, delegation, review, or verification.

## Baseline

- Inspect `git status --short --branch` before mutating git state.
- Preserve unrelated user changes.
- Use the repo's required delivery tool, such as `glab` for GitLab.
- Do not push, create branches, create MRs, resolve conflicts, or mark feedback done without enough context and user intent.
- Prefer draft MRs unless the user explicitly asks for ready-for-review.
- Do not turn review feedback into blind edits; verify each comment against the current code path.

## Workflow

1. Identify the delivery task and load the matching reference.
2. Confirm branch, dirty state, target branch, and remote provider.
3. Inspect the diff or conflict context before deciding on changes.
4. For MR feedback, separate valid findings, outdated comments, questions, and non-actionable suggestions.
5. For conflicts, understand both sides and the intended final behavior before editing.
6. Run targeted validation before creating or updating delivery artifacts.

## Review Focus

Look for:

- unrelated changes staged or included in an MR;
- generated or noisy descriptions that hide the real change;
- conflict resolutions that simply choose one side without preserving intent;
- MR feedback fixes that satisfy the comment text but break the real behavior;
- missing validation evidence before push/MR handoff.
