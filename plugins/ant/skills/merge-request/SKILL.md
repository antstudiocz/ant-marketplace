---
name: merge-request
description: "Prepare a read-only GitLab/GitHub MR/PR proposal or create/update one with a practical final-diff description, safe delivery chain, and pipeline observation. Use when the user asks to create, prepare, draft, or update an MR/PR/merge request/pull request, including Czech requests like 'udělej MR', 'udělej PR', 'vytvoř merge request', 'připrav PR', or mistaken wording like 'merch request'."
---

# Merge Request

**Announce at start:** Say you will inspect the git context, resolve settled delivery choices, and either prepare a preview or create/update the PR/MR.

Use this skill to turn the current branch changes into a GitLab Merge Request or GitHub Pull Request with a concise Conventional Commit title and a concrete description in the resolved language. Treat "merch request" in user wording as "merge request/MR".

This skill is the sole owner of provider detection, description language, Draft/ready intent, title, description, creation/update commands, and pipeline observation. Other skills may supply verified context, but must not maintain an alternate creation workflow or use this skill as a code writer.

## Baseline

- Respect repository instructions first, including package manager, branch naming, and delivery tool rules.
- Preserve unrelated user changes. Never stage files blindly when the worktree contains changes outside the MR scope.
- Prefer Draft only when creating a new MR/PR unless the user explicitly says `ready`, `bez draft`, or equivalent. Preserve an existing MR/PR's readiness on an ordinary update; change it only on an explicit request.
- Use `glab` for GitLab repositories and `gh` for GitHub repositories. Detect the provider from `git remote -v`.
- Do not add `Generated with...`, `Co-Authored-By`, or similar footer lines to commits or MR descriptions.
- Do not force-push, reset, or rewrite history unless the user explicitly asks and the risk is clear.
- Resolve each choice in this order: the explicit current user instruction; target-repository instructions and existing MR/PR state; git/provider metadata; then safe documented defaults. Ask only when a material choice remains unresolved or these sources conflict. Conversation language alone is not a choice.
- Repository instructions or an existing MR/PR can settle the description language and target branch; do not ask again when they do. In their absence, use English as the safe documented default.
- Classify the request before delivery: **preparation intent** (for example, “prepare a proposal”, “draft the title/body”, or “show a PR preview”) returns only a read-only title/body preview. **Creation/update intent** (for example, “create”, “make”, “do”, “open”, `udělej MR`, or `vytvoř MR`) authorizes the safe necessary chain of a scoped commit when needed, source-branch push, new-MR/PR Draft creation unless ready was explicit, ordinary-update readiness preservation, and pipeline observation. “Draft” modifies readiness only when creation/update intent is otherwise clear.
- Creation/update intent never authorizes merge, release, tag/publish, Draft-to-ready conversion unless `ready` was explicit, force-push, rebase, reset, or any history rewrite.
- Treat every created or updated description as a snapshot of the final change from the target branch merge base to final `HEAD`, not as a diary of work performed on the branch.

## Workflow

1. Inspect context before mutating anything:

   ```bash
   git status --short --branch
   git branch --show-current
   git remote -v
   git remote show origin
   git diff --stat
   git diff --name-status
   git diff
   git diff --cached --stat
   git diff --cached --name-status
   git diff --cached
   git diff HEAD --stat
   git diff HEAD --name-status
   git diff HEAD
   git log --oneline --decorate --max-count=20
   ```

2. Detect the provider from the remote URL. Use GitLab only for a GitLab remote and GitHub only for a GitHub remote. If the remote is missing, unsupported, or ambiguous, stop and ask instead of guessing.
3. Resolve target, language, existing MR/PR state, and Draft/ready state using the precedence above. Determine target branch from explicit user instruction, the existing PR/MR, repository instructions, or `origin` HEAD. For a new MR/PR, Draft is the default; preserve existing readiness unless an explicit request changes it. Ask only if a choice remains materially ambiguous or conflicting. Ensure the target ref is current enough to establish the real merge base; a source branch merely behind target is not a reason to rebase, update it, or ask.
4. Identify whether there are unstaged, staged, committed-but-unpushed, and unrelated changes from the separate staged, unstaged, and `HEAD` views. For preparation intent, inspect only. For creation/update intent, commit only clearly MR-scoped files when necessary. Never commit pre-staged unrelated files or mixed hunks merely because creation intent permits a scoped commit; stop and ask if staging cannot safely isolate the MR scope.
5. Compute the merge base between the target branch and current `HEAD`, then inspect that diff deeply enough to understand final behavior, technical decisions, user impact, and validation gaps. If clearly scoped working-tree changes must be committed for creation/update intent, include them in the proposed preview and repeat this inspection from the real final `HEAD` after the commit. Verify any orchestrator summary against the final snapshot; do not generate the PR/MR from filenames, individual commits, or conversation history alone.
6. Run targeted validation appropriate to the change when feasible. Do not run project-disallowed commands.
7. Draft the final title, description, target, provider, and readiness behavior. For an update, inspect the existing PR/MR first, preserve its readiness unless explicitly changed, and identify exactly which fields will change.
8. For preparation intent, return the complete read-only preview and stop. For creation/update intent, present the same concise preview as status, including any necessary scoped commit and push, then continue without a duplicate confirmation.
9. Commit and push the source branch for creation/update intent after checking branch, upstream, and remote target. When a commit was needed, recompute the merge base and rebuild the description from the real final `HEAD` before the provider command. If no upstream exists, use `git push -u origin <branch>`.
10. Create or update through `glab` or `gh`. Use Draft for a new MR/PR unless the user explicitly selected ready; leave existing readiness unchanged unless explicitly requested.
11. Identify checks for the exact created/updated MR/PR head, monitor its matching pipeline/check set to a terminal state, and return the URL plus a concise delivery and pipeline summary.

## Preview And Questions

For preparation intent, return this as the final preview. For creation/update intent, show it as a non-blocking status before performing the safe delivery chain:

- provider and repository;
- source and target branches;
- create versus update intent;
- final title;
- selected description language;
- new-MR/PR Draft or ready state, or existing-MR/PR readiness preservation/change;
- full description preview or the exact fields being updated;
- validation gaps and unrelated-worktree warnings.

Do not seek a second confirmation for creation/update intent. Ask only for a real blocker: unrelated or ambiguous changes that cannot be scoped safely, conflicting instructions, unsupported or ambiguous provider, unresolved target, destructive history operation, or materially risky scope expansion. Do not treat PR/MR intent as permission to merge or release.

## Language Resolution

Use the precedence rules above. Never infer language only from the conversation language, but do not ask when the repository instructions, existing MR/PR, or safe English default already settles it. Ask only when higher-priority sources conflict or the required language is materially unresolved.

Recommended wording:

```text
V jakém jazyce mám připravit PR/MR popis?
- Čeština
- English
- Jiný jazyk
```

If language is genuinely unresolved and the user picks "another language", ask for the exact language name. Use the resolved language for:

- PR/MR description headings;
- bullet content;
- user walkthrough;
- test notes;
- final PR/MR summary.

Keep the Conventional Commit title in English unless the repository convention or user explicitly prefers another language.

## Commit And Push Rules

- Preparation intent never commits, pushes, creates, updates, or monitors a provider object. Creation/update intent includes the scoped commit and source-branch push needed to deliver the requested MR/PR; do not ask again just because either is necessary.
- If unrelated files or mixed staged hunks are present, stage only MR-relevant files explicitly or ask the user to split scope. Never include pre-staged unrelated changes in the commit.
- Use a Conventional Commit message: `feat(scope): short summary`, `fix(scope): short summary`, `refactor(scope): short summary`, `docs(scope): short summary`, `test(scope): short summary`, or `chore(scope): short summary`.
- Keep commit and MR titles short, factual, lower-case after the colon, without a trailing period.

## MR Title

Use Conventional Commit style:

```text
type(scope): short factual summary
```

Rules:

- Prefer the branch prefix or dominant diff area for `type` and `scope`.
- Keep it under 72 characters when practical.
- Append a ticket ID only when it is already present in branch, commits, issue, or user instruction.
- Use English for the title unless the repository convention or selected language clearly requires otherwise.

Examples:

```text
feat(checkout): add delivery slot selection
fix(auth): preserve invite redirect after login
refactor(api): split organization registration actions
docs(skills): add merge request workflow
```

## MR Description

Write the description in the selected language. Be concrete and operational, not marketing-oriented. The description must start with a short plain-language summary of what was actually done, then a horizontal rule, then the detailed structured sections. Separate user walkthrough from technical validation.

### Final Snapshot Rule

- Establish the target branch first. For an existing PR/MR, use its actual base branch.
- Compute the merge base and inspect the complete diff from that point to final `HEAD`, for example with `git merge-base <target-ref> HEAD` followed by `git diff <merge-base>..HEAD`.
- Describe only the net behavior and files that remain in that final diff. Intermediate commits, abandoned approaches, temporary artifacts, and add-then-remove work do not belong in the description.
- Mention branch history only when it remains materially relevant to migration, rollout, compatibility, data safety, or reviewer understanding of the final result.
- Apply this rule on updates too: rebuild the description from the current base-to-final-`HEAD` snapshot instead of appending a changelog of edits made since the previous description.

Use these sections. Translate section headings for other selected languages while preserving the meaning.

### Czech

````markdown
## Stručně

- ...

---

## Co se změnilo

- ...

## Proč

- ...

## Proč je to řešené takhle

- ...

## Dopady

- Uživatelé: ...
- Technicky: ...

## Jak to proklikat

1. ...
2. ...
3. Očekávaný výsledek: ...

## Jak to technicky otestovat

```bash
...
```

- Očekávaný výsledek: ...

## Co nešlo ověřit

- ...

## Na co se má reviewer zaměřit

- ...
````

### English

````markdown
## Summary

- ...

---

## What changed

- ...

## Why

- ...

## Why this approach

- ...

## Impact

- Users: ...
- Technical: ...

## How to click through

1. ...
2. ...
3. Expected result: ...

## How to test technically

```bash
...
```

- Expected result: ...

## What could not be verified

- ...

## Reviewer focus

- ...
````

### Description Guidance

- In "Summary" / "Stručně", write concise plain-language bullets for a non-technical reviewer. Cover every materially distinct delivered outcome from the final diff exactly once, and combine overlapping outcomes. Omit implementation details, file names, recovery history, and vague process wording. Do not target, prefer, minimize, maximize, pad to, or cap a bullet count; use exactly as many bullets as coverage requires. Before finalizing, verify that no important outcome is missing and no two bullets describe the same outcome.
- Put `---` directly after the summary section so the quick summary is visually separated from the detailed review notes.
- In "What changed" / "Co se změnilo", summarize the actual diff by behavior and touched areas, not only file names.
- In "Why" / "Proč", connect the change to the user problem, task, regression, workflow need, or technical debt visible from context.
- In "Why this approach" / "Proč je to řešené takhle", explain concrete decisions, tradeoffs, and why the implementation shape is appropriate.
- In "Impact" / "Dopady", explicitly mention UI, API, auth, data, permissions, cache, background jobs, workflows, migrations, and compatibility when affected.
- In "How to click through" / "Jak to proklikat", write real user scenarios step by step. Include roles/accounts or permissions when relevant.
- In "How to test technically" / "Jak to technicky otestovat", include exact commands run or recommended. Keep this separate from UX clicking.
- In "What could not be verified" / "Co nešlo ověřit", state blockers plainly, for example missing credentials, unavailable service, sandbox/network limitation, no seed data, or command intentionally skipped by project rule.
- In "Reviewer focus" / "Na co se má reviewer zaměřit", call out risk areas, assumptions, edge cases, and files or flows needing careful review.
- Before finalizing, compare every claim with the merge-base-to-`HEAD` diff and remove claims about reverted, abandoned, or otherwise absent work.

If a section truly does not apply, keep it with a localized equivalent of `- Not applicable.` rather than deleting it, except screenshots or optional links requested by the repo convention.

## Provider CLI

Prefer writing the description to a temporary file to avoid shell quoting problems. Current `glab mr create/update` accepts description text rather than a description-file flag, so read the file into a task-specific shell variable. Current `gh pr create/edit` accepts `--body-file` directly.

GitLab:

```bash
mr_description="$(< /tmp/mr-description.md)"
glab mr create \
  --title "type(scope): short factual summary" \
  --description "$mr_description" \
  --target-branch <target-branch> \
  --assignee @me \
  --draft \
  --yes
```

For a ready GitLab MR, omit `--draft`. For an existing MR, update content without changing readiness:

```bash
mr_description="$(< /tmp/mr-description.md)"
glab mr update <id-or-branch> \
  --title "type(scope): short factual summary" \
  --description "$mr_description" \
  --yes

# Only when explicitly requested:
glab mr update <id-or-branch> --draft --yes
glab mr update <id-or-branch> --ready --yes
```

GitHub:

```bash
gh pr create \
  --title "type(scope): short factual summary" \
  --body-file /tmp/pr-description.md \
  --base <target-branch> \
  --draft
```

For a ready GitHub PR, omit `--draft`. Change an existing PR's content without changing its review state:

```bash
gh pr edit <number-or-url-or-branch> \
  --title "type(scope): short factual summary" \
  --body-file /tmp/pr-description.md

# Only when explicitly requested:
gh pr ready <number-or-url-or-branch>
gh pr ready <number-or-url-or-branch> --undo
```

If the MR/PR already exists, inspect it first and update only the intended fields:

```bash
glab mr view
gh pr view
```

When `glab`, `gh`, or `git push` requires network/auth approval, request approval normally and explain that it is needed to push or create the MR/PR.

## Pipeline Observation And Remediation Handoff

After every create or update, resolve the exact MR/PR head and observe only its matching checks/pipeline to a terminal state by default. This is part of creation/update intent, not a separate confirmation.

- Set a finite registration deadline using repository/provider guidance when available; otherwise use a safe bounded window. Announce the wait concisely. If matching checks or a pipeline are still absent at the deadline, collect the head and provider evidence, report `no pipeline/checks registered` as an unverified external-state outcome, and ask or stop as repository instructions require—never report green or wait indefinitely.
- For GitHub, resolve the created/updated PR's `headRefOid` first. Within the registration window, wait for its checks rollup to register checks for that OID; an empty rollup is pending, not success. Then use `gh pr checks <id> --watch`. An exit status of `8` means checks are still pending; continue bounded observation rather than treating it as a failure. Re-read `headRefOid` after observation; if it changed, restart observation for the newer head instead of reporting the prior head green.
- For GitLab, resolve the MR's current head SHA (for example `diff_refs.head_sha`), wait within the registration window for a matching pipeline, and prefer the repository-correct MR pipeline source—normally `merge_request_event`. Capture that pipeline's exact ID and poll or observe that ID to terminal. `glab ci view --pipelineid` can inspect a known pipeline, but non-interactive API polling by pipeline ID is acceptable when it is more reliable.
- While checks are pending or running, send one concise waiting status and continue monitoring at bounded intervals so the user receives an update at least every 60 seconds. Do not narrate unchanged snapshots.
- On success, report that the exact MR/PR pipeline is green. On failure or cancellation, collect the failing check/job identity and relevant provider diagnostic logs or evidence before classifying the cause as an MR-diff regression, flaky/infrastructure issue, credentials issue, or external-state blocker.
- A safe provider retry is allowed only for a classified flaky/infrastructure failure when provider support and repository/user instructions permit it. Monitor the retried run. Never weaken, skip, or silently ignore checks.
- For credentials or external-state blockers, a materially risky scope expansion, or any conflicting instruction, report the evidence and ask for direction. Never imply authorization to merge, release, rebase, force-push, reset, or rewrite history.

### Repair Ownership

`merge-request` owns provider observation and the diagnostic bundle; it never makes tracked code repairs.

- When an implementation-orchestrator run is active and the evidence shows an in-scope MR-diff regression, return that bundle to its implementation/review/validation loop. The orchestrator dispatches the bounded repair, targeted validation, independent review, and required final-suite refresh, then re-enters this skill only to commit/push/update and monitor the replacement pipeline.
- For standalone creation/update intent, hand off the same bounded regression evidence to `implementation-orchestrator`. The original creation/update intent authorizes repair only while it remains within the MR's established scope and risk. The orchestrator performs discovery, a proportional repair plan, tracked repair delegation, review, validation, and the final-suite refresh before returning to this skill for the updated MR/PR and pipeline observation.
- Repeat that repair-and-observation loop until the exact pipeline is green or there is a genuine blocker or material scope/risk change. This is a caller handoff, not a circular invocation: this skill reports evidence upward or starts the orchestrator handoff; the orchestrator resumes this skill only after repair work is ready for delivery.
