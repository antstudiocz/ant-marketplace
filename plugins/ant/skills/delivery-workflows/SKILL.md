---
user-invocable: true
name: delivery-workflows
description: "Use for resolving Git merge conflicts with repository context, preserving both sides' intent, and validating the result."
---

# Delivery Workflows

Use this skill only for repository merge-conflict resolution. Use `implementation-orchestrator` for end-to-end implementation and `ant:merge-request` for every PR/MR creation or update.

Reference files may contain original skill frontmatter. Treat it as reference metadata, not as separate skill invocation.

Load `references/merge-conflicts.md` before resolving local or remote-branch conflicts.

## Baseline

- Inspect `git status --short --branch` before mutating git state.
- Preserve unrelated user changes.
- Use the repo's required delivery tool, such as `glab` for GitLab.
- Do not push or create branches without enough context and user intent.
- Do not resolve conflicts by blindly accepting one side; understand both sides' intent first.

## Workflow

1. Load `references/merge-conflicts.md` and identify the exact conflict scope.
2. Confirm branch, dirty state, target branch, and remote provider.
3. Inspect the diff or conflict context before deciding on changes.
4. For conflicts, understand both sides and the intended final behavior before editing.
5. Run validation targeted to the resolved areas before completing the conflict operation.

## Review Focus

Look for:

- unrelated changes staged or pulled into the resolution;
- conflict resolutions that simply choose one side without preserving intent;
- missing validation evidence before push/MR handoff.
