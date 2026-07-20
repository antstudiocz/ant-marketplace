---
name: merge-request
description: "Create GitLab/GitHub merge requests or pull requests with a practical structured description, delivery checks, and an explicit language choice. Use when the user asks to create, prepare, draft, or update an MR/PR/merge request/pull request, including Czech requests like 'udělej MR', 'udělej PR', 'vytvoř merge request', 'připrav PR', or mistaken wording like 'merch request'."
---

# Merge Request

**Announce at start:** Say you will inspect the git context and prepare the PR/MR in the selected language.

Use this skill to turn the current branch changes into a GitLab Merge Request or GitHub Pull Request with a concise Conventional Commit title and a concrete description in the user's chosen language. Treat "merch request" in user wording as "merge request/MR".

This skill is the sole owner of PR/MR creation and update behavior. It owns provider detection, description language, Draft/ready intent, title, description, confirmation, and the provider CLI commands. Other skills may supply verified context, but must not maintain an alternate creation workflow.

## Baseline

- Respect repository instructions first, including package manager, branch naming, and delivery tool rules.
- Preserve unrelated user changes. Never stage files blindly when the worktree contains changes outside the MR scope.
- Prefer Draft MR unless the user explicitly says `ready`, `bez draft`, or equivalent.
- Use `glab` for GitLab repositories and `gh` for GitHub repositories. Detect the provider from `git remote -v`.
- Do not add `Generated with...`, `Co-Authored-By`, or similar footer lines to commits or MR descriptions.
- Do not force-push, reset, or rewrite history unless the user explicitly asks and the risk is clear.
- Ask which language to use unless the user already chose it in the current task or the orchestrator passes that explicit choice.
- Treat commit, push, PR/MR creation, Draft-to-ready conversion, merge, and release as distinct delivery actions. Perform only the actions the user requested.

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
   git log --oneline --decorate --max-count=20
   ```

2. Detect the provider from the remote URL. Use GitLab only for a GitLab remote and GitHub only for a GitHub remote. If the remote is missing, unsupported, or ambiguous, stop and ask instead of guessing.
3. Determine target branch from explicit user instruction, existing upstream/PR/MR, or `origin` HEAD. If still ambiguous, ask before creating or updating the PR/MR.
4. Resolve the PR/MR description language before drafting the title/body. Reuse an explicit choice from the current task; otherwise use native question UI if available or ask directly in chat. Offer at least:
   - Czech
   - English
   - Another language, where the user names the language
5. Identify whether there are unstaged, staged, committed-but-unpushed, and unrelated changes. If committing is needed but was not requested, propose exactly which files and commit message would be used before acting.
6. Inspect the diff enough to understand what changed, why, technical decisions, user impact, and validation gaps. Verify any orchestrator summary against the repository; do not generate the PR/MR from filenames alone.
7. Run targeted validation appropriate to the change when feasible. Do not run project-disallowed commands.
8. Draft the final title, description, target, provider, and Draft/ready state. For an update, inspect the existing PR/MR first and identify exactly which fields will change.
9. Present the complete preview unless the user already requested the exact title/body/update and readiness. Do not add an unnecessary second confirmation for settled choices.
10. Push only when requested, after checking branch, upstream, and remote target. If no upstream exists, use `git push -u origin <branch>`.
11. Create or update through `glab` or `gh`. Use Draft unless the user explicitly selected ready.
12. Return the PR/MR URL and a short summary of what was created or updated.

## Confirmation

Before the provider command, show:

- provider and repository;
- source and target branches;
- create versus update intent;
- final title;
- selected description language;
- Draft or ready state;
- full description preview or the exact fields being updated;
- validation gaps and unrelated-worktree warnings.

Offer `Create/update as Draft`, `Create/update as ready`, `Edit title`, `Edit description`, and `Cancel` when the user's current instructions have not already settled those choices. Do not treat PR/MR intent as permission to merge or release.

## Language Selection

Ask the language question when the user has not already selected a language for this PR/MR. Never infer it only from the conversation language, but do not ask twice after a clear answer.

Recommended wording:

```text
V jakém jazyce mám připravit PR/MR popis?
- Čeština
- English
- Jiný jazyk
```

If the user picks "another language", ask for the exact language name. Use the selected language for:

- PR/MR description headings;
- bullet content;
- user walkthrough;
- test notes;
- final PR/MR summary.

Keep the Conventional Commit title in English unless the repository convention or user explicitly prefers another language.

## Commit And Push Rules

- If the user asks only to prepare or create a PR/MR and commits or a remote branch are missing, explain the required commit/push actions and obtain the missing intent before performing them. A request such as "do it completely, including push" already settles those actions.
- If unrelated files are present, stage only MR-relevant files explicitly or ask the user to split scope.
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

- In "Summary" / "Stručně", write 1-3 short bullets for a non-technical reviewer. Say what was actually delivered in plain language. Avoid implementation details, file names, recovery history, and vague process wording.
- Put `---` directly after the summary section so the quick summary is visually separated from the detailed review notes.
- In "What changed" / "Co se změnilo", summarize the actual diff by behavior and touched areas, not only file names.
- In "Why" / "Proč", connect the change to the user problem, task, regression, workflow need, or technical debt visible from context.
- In "Why this approach" / "Proč je to řešené takhle", explain concrete decisions, tradeoffs, and why the implementation shape is appropriate.
- In "Impact" / "Dopady", explicitly mention UI, API, auth, data, permissions, cache, background jobs, workflows, migrations, and compatibility when affected.
- In "How to click through" / "Jak to proklikat", write real user scenarios step by step. Include roles/accounts or permissions when relevant.
- In "How to test technically" / "Jak to technicky otestovat", include exact commands run or recommended. Keep this separate from UX clicking.
- In "What could not be verified" / "Co nešlo ověřit", state blockers plainly, for example missing credentials, unavailable service, sandbox/network limitation, no seed data, or command intentionally skipped by project rule.
- In "Reviewer focus" / "Na co se má reviewer zaměřit", call out risk areas, assumptions, edge cases, and files or flows needing careful review.

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

For a ready GitLab MR, omit `--draft`. For an existing MR, update the intended fields and readiness explicitly:

```bash
mr_description="$(< /tmp/mr-description.md)"
glab mr update <id-or-branch> \
  --title "type(scope): short factual summary" \
  --description "$mr_description" \
  --draft \
  --yes

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

For a ready GitHub PR, omit `--draft`. Change an existing PR's content and review state with separate explicit commands:

```bash
gh pr edit <number-or-url-or-branch> \
  --title "type(scope): short factual summary" \
  --body-file /tmp/pr-description.md

gh pr ready <number-or-url-or-branch>
gh pr ready <number-or-url-or-branch> --undo
```

If the MR/PR already exists, inspect it first and update only the intended fields:

```bash
glab mr view
gh pr view
```

When `glab`, `gh`, or `git push` requires network/auth approval, request approval normally and explain that it is needed to push or create the MR/PR.
