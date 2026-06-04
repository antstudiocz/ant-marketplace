---
name: merge-request
description: "Create GitLab/GitHub merge requests or pull requests with a practical structured description, delivery checks, and an explicit language choice. Use when the user asks to create, prepare, draft, or update an MR/PR/merge request/pull request, including Czech requests like 'udělej MR', 'udělej PR', 'vytvoř merge request', 'připrav PR', or mistaken wording like 'merch request'."
---

# Merge Request

**Announce at start:** "Zkontroluju git kontext a zeptám se na jazyk PR/MR popisu."

Use this skill to turn the current branch changes into a GitLab Merge Request or GitHub Pull Request with a concise Conventional Commit title and a concrete description in the user's chosen language. Treat "merch request" in user wording as "merge request/MR".

## Baseline

- Respect repository instructions first, including package manager, branch naming, and delivery tool rules.
- Preserve unrelated user changes. Never stage files blindly when the worktree contains changes outside the MR scope.
- Prefer Draft MR unless the user explicitly says `ready`, `bez draft`, or equivalent.
- Use `glab` for GitLab repositories and `gh` for GitHub repositories. Detect the provider from `git remote -v`.
- Do not add `Generated with...`, `Co-Authored-By`, or similar footer lines to commits or MR descriptions.
- Do not force-push, reset, or rewrite history unless the user explicitly asks and the risk is clear.
- Always ask which language to use for the PR/MR description. Do not infer it silently from the conversation language.

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

2. Determine target branch from explicit user instruction, existing upstream/MR, or `origin` HEAD. If still ambiguous, ask before creating the MR.
3. Ask for the PR/MR description language before drafting the title/body. Use native question UI if available; otherwise ask directly in chat. Offer at least:
   - Czech
   - English
   - Another language, where the user names the language
4. Identify whether there are unstaged, staged, committed-but-unpushed, and unrelated changes. If committing is needed, propose exactly which files belong in the commit and use a short Conventional Commit message.
5. Inspect the diff enough to understand what changed, why, technical decisions, user impact, and validation gaps. Do not generate the MR from filenames only.
6. Run targeted validation appropriate to the change when feasible. Do not run project-disallowed commands.
7. Push only after checking branch/upstream and user intent. If no upstream exists, use `git push -u origin <branch>`.
8. Create or update the MR through `glab` or `gh`. Use Draft unless the user explicitly requested ready.
9. Return the MR/PR URL and a short summary of what was created.

## Language Selection

Always ask the language question, even when the current conversation language is obvious. The question prevents accidental Czech descriptions in English threads and English descriptions in Czech threads.

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

- If the user asks "udělej MR" and there are no commits for the branch yet, committing/pushing is allowed only after the context check shows the changed files belong together.
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

Write the description in the selected language. Be concrete and operational, not marketing-oriented. Separate user walkthrough from technical validation.

Use these sections. Translate section headings for other selected languages while preserving the meaning.

### Czech

````markdown
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

Prefer writing the description to a temporary file to avoid shell quoting problems.

GitLab:

```bash
glab mr create \
  --title "type(scope): short factual summary" \
  --description-file /tmp/mr-description.md \
  --target-branch <target-branch> \
  --assignee @me \
  --draft
```

GitHub:

```bash
gh pr create \
  --title "type(scope): short factual summary" \
  --body-file /tmp/pr-description.md \
  --base <target-branch> \
  --draft
```

If the MR/PR already exists, inspect it first and update only the intended fields:

```bash
glab mr view
glab mr update --description-file /tmp/mr-description.md
gh pr view
gh pr edit --body-file /tmp/pr-description.md
```

When `glab`, `gh`, or `git push` requires network/auth approval, request approval normally and explain that it is needed to push or create the MR/PR.
