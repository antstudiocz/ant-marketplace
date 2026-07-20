---
user-invocable: false
name: create-mr
description: Deprecated compatibility bridge that forwards PR/MR creation and update requests to ant:merge-request.
deprecated: true
---

# Create Merge Request Compatibility Bridge

**Announce at start:** "This legacy entrypoint now forwards PR/MR work to ant:merge-request."

This reference is retained for plugin `9.2` compatibility. It must not implement an independent PR/MR workflow.

## Forwarding Contract

1. Preserve the user's original request, repository path(s), and explicit delivery constraints without reinterpretation.
2. Invoke `ant:merge-request` and pass that context unchanged.
3. If an orchestrator delivery handoff manifest is present, pass it through unchanged.
4. Let `ant:merge-request` inspect the repository, detect the provider, resolve language and Draft/ready intent, draft the title and description, obtain confirmation, validate authorization, and execute any `glab` or `gh` command.
5. Return the canonical skill's result without creating a second preview, confirmation, or provider action.

Do not detect GitLab/GitHub here. Do not generate or modify a title or description. Do not choose a target branch, language, labels, assignee, Draft/ready state, or CLI command. Do not push or create/update a PR/MR from this bridge.

For merge conflicts, return to `ant:delivery-workflows` and load `references/merge-conflicts.md`; conflict-resolution ownership is unchanged.
