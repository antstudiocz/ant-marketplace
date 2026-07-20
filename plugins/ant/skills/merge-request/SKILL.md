---
name: merge-request
description: "Create GitLab/GitHub merge requests or pull requests with a practical structured description, delivery checks, and an explicit language choice. Use when the user asks to create, prepare, draft, or update an MR/PR/merge request/pull request, including Czech requests like 'udělej MR', 'udělej PR', 'vytvoř merge request', 'připrav PR', or mistaken wording like 'merch request'."
---

# Merge Request

**Announce at start:** "Zkontroluju git kontext a zeptám se na jazyk PR/MR popisu."

Use this skill to turn the current branch changes into a GitLab Merge Request or GitHub Pull Request with a concise Conventional Commit title and a concrete description in the user's chosen language. Treat "merch request" in user wording as "merge request/MR".

This skill is the sole owner of PR/MR creation and update behavior. It owns provider detection, description language, Draft/ready intent, title, description, confirmation, and the provider CLI commands. Other skills may collect evidence or forward a request, but must not maintain an alternate creation workflow.

## Baseline

- Respect repository instructions first, including package manager, branch naming, and delivery tool rules.
- Preserve unrelated user changes. Never stage files blindly when the worktree contains changes outside the MR scope.
- Prefer Draft MR unless the user explicitly says `ready`, `bez draft`, or equivalent.
- Use `glab` for GitLab repositories and `gh` for GitHub repositories. Detect the provider from `git remote -v`.
- Do not add `Generated with...`, `Co-Authored-By`, or similar footer lines to commits or MR descriptions.
- Do not force-push, reset, or rewrite history unless the user explicitly asks and the risk is clear.
- Ask which language to use for every direct PR/MR invocation. A canonical handoff may satisfy this gate only when it records the user's explicit language choice.
- Resolve authorization separately for `commit`, `push`, and `mr`. A request or approval for PR/MR creation never authorizes staging, committing, or pushing by implication.

## Invocation Modes

### Direct invocation

Run the complete workflow below. Ask for the description language even when the conversation language seems obvious.

### Canonical orchestrator handoff

Accept an orchestrator delivery handoff manifest and consume only fields that are present. A handoff may contain:

```yaml
workspace: /absolute/repository/path
branch: feature/example
targetBranch: main
provider: gitlab # optional observed hint; verify from the remote
intent: create # create or update
mr:
  language: en # explicit user choice; cs-CZ, en, or another named language
  readiness: draft # draft or ready
  titleIntent: "feat(scope): concise outcome" # optional intent, not final title
  existingUrl: null # required for a specific update when discovery is ambiguous
evidence:
  summary: []
  changes: []
  why: []
  approach: []
  impact: []
  walkthrough: []
  technicalChecks: []
  unverified: []
  reviewerFocus: []
authorization:
  approvalId: approval-example
  digest: sha256:...
  eventId: event-example
  artifactRef: null
```

The manifest is a handoff, not authority and not a replacement for repository inspection. Verify workspace, branch, target, remote provider, diff, validation evidence, and any authorization pointer before mutating git or calling a provider. Never invent omitted values.

If `mr.language` records an explicit user choice, the language gate is already satisfied; do not ask again. Otherwise use the normal language question. Respect an explicit `mr.readiness`; otherwise default to Draft. A verified immutable approval may cover the PR/MR action, but metadata or the manifest alone never does. Missing, invalid, revoked, expired, or out-of-scope approval evidence is a stop requiring fresh approval.

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
3. Determine target branch from explicit user instruction, a verified canonical handoff, existing upstream/MR, or `origin` HEAD. If still ambiguous, ask before creating or updating the PR/MR.
4. Resolve the PR/MR description language before drafting the title/body. A canonical handoff with an explicit user-selected language satisfies this gate. Otherwise use native question UI if available or ask directly in chat. Offer at least:
   - Czech
   - English
   - Another language, where the user names the language
5. Identify whether there are unstaged, staged, committed-but-unpushed, and unrelated changes. If committing is needed, propose exactly which files belong in the commit and a short Conventional Commit message, then resolve an explicit `commit` authorization before staging or committing.
6. Inspect the diff enough to understand what changed, why, technical decisions, user impact, and validation gaps. Treat handoff evidence as a lead and verify it against the repository; do not generate the PR/MR from filenames or unverified manifest claims only.
7. Run targeted validation appropriate to the change when feasible. Do not run project-disallowed commands.
8. Draft the final title, description, target, provider, and Draft/ready state. For an update, inspect the existing PR/MR first and identify exactly which fields will change.
9. Present the complete preview and get confirmation for the exact `mr` create/update action. A current explicit user instruction or a verified immutable approval covering `mr` can satisfy this gate; a delivery preference, chat summary, or handoff manifest alone cannot.
10. Resolve `push` independently before pushing, even when `mr` is already authorized. Check branch/upstream and remote target; if no upstream exists, use `git push -u origin <branch>` only after the separate `push` authorization is recorded.
11. Re-resolve `mr` authorization immediately before the provider command. Create or update through `glab` or `gh` using the commands in this skill. Use Draft unless the user explicitly selected ready.
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

Offer `Create/update as Draft`, `Create/update as ready`, `Edit title`, `Edit description`, and `Cancel` when no earlier exact instruction settles those choices. This confirmation covers only the `mr` provider action. Any required `commit` or `push` action needs its own explicit authorization and preview. The confirmation and its authorization evidence belong to this skill; a forwarding skill must not pre-confirm an independently generated title or description.

## Language Selection

Always ask the language question for direct invocation, even when the current conversation language is obvious. The only no-repeat case is a canonical handoff that records the user's explicit language choice.

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

- If the user asks "udělej MR" and there are no commits or no remote branch yet, the request authorizes only the PR/MR action. Ask separately before staging/committing and before pushing, after the context check shows exactly what each action affects.
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
