# Conflict resolution

Use for local conflicts or conflicts reported by a GitHub PR/GitLab MR. Analyze both sides' intent; never accept ours/theirs blindly. Conflict-only mode never creates/updates a provider object or observes pipelines.

## Authority and preparation

- A local request authorizes resolving conflict markers. `git add`, commit, push, readiness changes, and provider mutation remain separate authorities.
- Explicit remote conflict intent authorizes clean-state preflight, resolving the provider source branch, target ref, and current head, fetching those exact refs, checking out the source branch, fast-forwarding it safely to the provider head, and creating the merge-generated index/worktree needed to reproduce conflicts. It does not authorize staging or history rewrite.
- Before remote work, require a clean tracked worktree, index, and untracked-file state. If dirty, stop and request isolation.
- Never force-push, reset, rebase, or rewrite history without explicit authority.

## Analyze and resolve

1. Inventory all local unmerged paths with `git diff --name-only --diff-filter=U`; read each file fully and identify binary conflicts.
2. For remote work, validate provider metadata, fetch the exact source and target refs, check out the source branch, fast-forward it safely to the provider head, and run `git merge --no-commit --no-ff <target-ref>`. If clean, leave the merge in progress and report it.
3. For each conflict, determine base/current/incoming intent, inspect callers/contracts/docs/tests, and classify simple complementary edits versus semantic or contract changes.
4. Apply only resolutions supported by that analysis. Escalate binary, permission, schema, behavior, or otherwise ambiguous conflicts for adjudication.

## Validate and report

Before staging, reread every original conflict file, search for remaining markers, and inspect the complete resolution diff and status. Run the smallest relevant checks. If staging is unauthorized, leave intentional working-tree resolutions with unmerged index entries and say so. After authorized `git add`, verify no unmerged paths remain; commit and push still need their own authority.

A clean merge proves only that Git found no textual conflicts. Report resolved files, decisions, checks, gaps, and the current merge/index state without implying semantic correctness or delivery.
