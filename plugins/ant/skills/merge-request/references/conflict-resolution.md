# Conflict Resolution

Use for local conflicts or conflicts reported by a remote GitHub PR/GitLab MR. Analyze both sides' intent; never blindly accept ours/theirs. Conflict-only mode never creates/updates a provider object or observes pipelines.

## Authority And Safety

- A local conflict-resolution request authorizes resolving conflict markers.
- Explicit remote conflict-resolution intent authorizes the clean-preflight fetch/checkout/safe fast-forward and the merge-generated index/worktree mutation needed to reproduce conflicts. That mechanical merge index state is not `git add` stage authority.
- Marking resolutions with `git add`, committing, and pushing each remain separately authorized. Never force-push, reset, rebase, or rewrite history without explicit authority.
- Conflict-only provider restrictions remain in force: do not create/update the PR/MR, change readiness, retry checks, or observe pipelines.
- Before remote work, require a clean index, tracked worktree, and untracked-file state. If dirty, stop and offer to continue after isolation.

## Detect And Inventory

Local mode:

```bash
git diff --name-only --diff-filter=U
```

Record the complete original unmerged set, read each file fully, inventory every marker block, and identify binary conflicts separately. If no paths are unmerged, report that and stop.

Remote mode:

1. Validate provider URL and clean state.
2. Read provider metadata for source, target, and current head.
3. Fetch exact refs, check out the source branch, update only by safe fast-forward, then run `git merge --no-commit --no-ff <target-ref>` to reproduce conflicts without creating a merge commit.
4. If clean, stop with the merge still in progress and report the merge-generated index state. Do not run `git add`, `git commit`, `git push`, or provider mutation/observation.

If preparation would overwrite work, switch repositories, or require history rewrite, stop and ask.

## Analyze And Resolve

For every file, explain its role; determine base/current/incoming intent; search callers, contracts, docs, and tests; classify simple complementary edits versus complex behavior/contract/schema/permission/error changes; and propose a resolution preserving compatible intent. Binary conflicts and semantic ambiguity require root/user adjudication before choosing a side or artifact. Delegate disjoint analysis only when explicitly permitted with fresh self-contained context; uncertain analysis is complex.

Apply simple resolutions only after blast-radius checks. Present complex conflicts to root with both intents, dependencies/tests, proposed code, tradeoffs, recommendation, and paused scope. Do not let the root become a tracked writer for unrelated implementation work.

## Validate And Report

Before any explicit `git add`, reread every original unmerged file, search for remaining markers, and inspect the complete working-tree resolution diff and status including unrelated changes. Run smallest relevant checks. Merge-generated index entries are not an explicit `git add`; for resolved text conflicts without stage authority, report worktree resolutions while intentionally retaining unmerged index/U entries.

Report resolved files, decisions, checks, gaps, and current merge state. If stage authority is absent, state explicitly that working-tree resolutions are prepared while the index remains unmerged. After authorized `git add`, verify no unmerged paths remain and inspect the scoped staged result; commit and push still require their own authority.

## Clean Merge Truth

A clean merge means only that Git produced no conflicts for the reproduced merge. It does not prove semantic correctness, passing checks, readiness, or delivery. Report the clean merge state and all unperformed actions truthfully.
