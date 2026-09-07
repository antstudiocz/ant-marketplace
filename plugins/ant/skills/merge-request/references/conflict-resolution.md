# Conflict resolution

Use for local conflicts or conflicts reported on a GitHub PR/GitLab MR. The [skill entrypoint](../SKILL.md) owns mode and authority boundaries.

## Preparation

A local conflict request permits resolving the conflicted files. Explicit remote conflict intent also permits fetching the exact provider source/target refs, safely fast-forwarding the source checkout to the provider head, and reproducing the target integration with `git merge --no-commit --no-ff <target-ref>`.

Use a clean tracked worktree, index and untracked-file state before remote reproduction; isolate unrelated work first. If the merge is clean, leave it in progress unless completing it is already authorized. These preparation permissions do not grant staging or history rewrite.

## Resolution and evidence

- Inventory every unmerged path, including binary conflicts. Determine base/current/incoming intent and relevant contracts before resolving; never accept ours/theirs blindly.
- Apply only supported resolutions. Escalate binary conflicts and unresolved permission, schema, behavior or contract choices for adjudication.
- Before staging, reread the original conflict files, check for remaining markers, inspect the complete resolution diff and run the smallest relevant checks.
- Without staging authority, leave intentional working-tree resolutions with unmerged index entries and report them. After authorized staging, verify no unmerged paths remain; commit and push still require their own authority.

Report resolution decisions, checks, gaps and current merge/index state. A clean textual merge alone proves neither semantic correctness nor delivery.
