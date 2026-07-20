---
user-invocable: true
name: delivery-workflows
description: "Use for Git delivery workflows: resolving merge conflicts with repository context and forwarding legacy MR creation requests to ant:merge-request."
---

# Delivery Workflows

Use this skill for repository delivery work around merge conflict resolution. It is not the primary implementation orchestrator; use `implementation-orchestrator` for end-to-end feature/fix work from brainstorming through verification.

PR/MR creation is owned exclusively by `ant:merge-request`. The historical create-MR entrypoint remains in `references/create-mr.md` as a deprecated forwarding bridge for compatibility in plugin `9.2`; it does not own provider, language, Draft/ready, title, description, confirmation, or provider-command logic.

Reference files may contain original skill frontmatter. Treat it as reference metadata, not as separate skill invocation.

## Reference Selection

- Legacy request to create or update a PR/MR: `references/create-mr.md`, which forwards to `ant:merge-request`.
- Resolve local or MR merge conflicts with context: `references/merge-conflicts.md`.

## Baseline

- Inspect `git status --short --branch` before mutating git state.
- Preserve unrelated user changes.
- Use the repo's required delivery tool, such as `glab` for GitLab.
- Do not push, create branches, create MRs, or resolve conflicts without enough context and user intent.
- Prefer draft MRs unless the user explicitly asks for ready-for-review.
- Do not resolve conflicts by blindly accepting one side; understand both sides' intent first.

## Workflow

1. Identify the delivery task and load the matching reference.
2. Confirm branch, dirty state, target branch, and remote provider.
3. Inspect the diff or conflict context before deciding on changes.
4. For conflicts, understand both sides and the intended final behavior before editing.
5. Run targeted validation before resolving conflicts or hand the untouched PR/MR request to `ant:merge-request`.

## Review Focus

Look for:

- unrelated changes staged or included in an MR;
- generated or noisy descriptions that hide the real change;
- conflict resolutions that simply choose one side without preserving intent;
- missing validation evidence before push/MR handoff.
