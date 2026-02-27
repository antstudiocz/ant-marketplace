---
user-invocable: true
name: create-mr
description: Create a GitLab Merge Request with proper Conventional Commits title, structured description, labels, and assignees. Analyzes branch changes to auto-generate MR content. Accepts optional instructions for custom behavior (e.g., "create for all 3 repos", "mark as draft", "target staging branch").
---

# Create Merge Request

**Announce at start:** "Analyzuji větev a připravuji Merge Request..."

## Purpose

Analyze the current branch and create a properly structured GitLab MR with:
- Conventional Commits title
- Structured description (What / Why / How to test)
- Labels, assignee, target branch

## Step 0: Read Extra Instructions

If the user passed arguments alongside the command (e.g. `/ant:create-mr Udělej to pro všechna 3 repa`), extract them and keep them in mind throughout the entire process. These instructions **override defaults** where applicable.

Examples of what extra instructions can affect:
- **Multiple repos** → run the full flow for each repo sequentially
- **Draft MR** → always create as draft without asking
- **Target branch** → use the specified branch instead of auto-detected one
- **Skip description** → create MR with minimal description
- **Specific reviewers** → assign the mentioned people
- **Custom labels** → apply specified labels

## Step 1: Analyze Branch

```bash
# Current branch name
git branch --show-current

# Detect default target branch
git remote show origin | grep "HEAD branch"

# Commits on this branch vs target
git log origin/{target_branch}..HEAD --oneline

# Changed files summary
git diff origin/{target_branch}..HEAD --name-status

# Current git remote URL (to detect GitLab hostname and project path)
git remote get-url origin
```

Extract from results:
- **Branch name** → type, scope, ticket reference
- **Commits** → what was done
- **Changed files** → affected areas of the codebase
- **Remote URL** → GitLab hostname + project path for `glab` calls

## Step 2: Determine MR Type and Scope

Map branch prefix to Conventional Commits type:

| Branch prefix | Conventional type | GitLab label |
|--------------|-------------------|--------------|
| `feature/`   | `feat`            | `type::feature` |
| `fix/`       | `fix`             | `type::bug` |
| `hotfix/`    | `fix`             | `type::bug` |
| `refactor/`  | `refactor`        | `type::refactor` |
| `chore/`     | `chore`           | `type::chore` |
| `docs/`      | `docs`            | `type::docs` |
| `test/`      | `test`            | `type::test` |
| `perf/`      | `perf`            | `type::performance` |
| `release/`   | `chore`           | `type::release` |

**Scope** — extract from branch name or changed files:
- Branch `feature/auth-google-login` → scope `auth`
- Branch `fix/TASK-123-checkout-double-submit` → scope `checkout`, ticket `TASK-123`
- If unclear, check the most-changed directory for scope hint

## Step 3: Generate MR Title

Format: `type(scope): short imperative description`

Rules:
- **Imperative mood**: "add", "fix", "update" — NOT "added", "fixes", "updating"
- **Lowercase** after colon
- **No period** at the end
- **Max 72 characters** total
- If ticket number found in branch (e.g. `TASK-123`, `ANT-42`): append ` [TASK-123]` at end
- If multiple unrelated changes: use the most significant one and note the rest in description

Good examples:
```
feat(auth): add Google OAuth login [ANT-42]
fix(checkout): prevent double submission on payment form
refactor(api): extract ArticleRepository from ArticleController
chore(deps): upgrade Laravel to 12.x
feat: initial project scaffolding
```

## Step 4: Generate MR Description

Fill this template based on commits and changed files:

```markdown
## What
<!-- One paragraph: what was done. Be specific. -->

## Why
<!-- Why this change was needed. Link to task/ticket if applicable. -->
<!-- Asana: https://app.asana.com/... -->
<!-- Issue: #123 -->

## How to test
1. <!-- Step by step reproduction/verification steps -->
2.
3. **Expected result:** <!-- What should happen -->

## Screenshots
<!-- Include for any visual/UI changes. Remove section if not applicable. -->

## Notes
<!-- Technical decisions, known limitations, follow-up tasks, or anything reviewers should know. Remove if empty. -->
```

Populate each section:
- **What** — summarize the commits in plain language
- **Why** — infer from branch name, commit messages, or ticket reference
- **How to test** — derive from changed files (e.g. auth changes → test login flow)
- **Screenshots** — remind user if frontend files were changed
- **Notes** — include any migration steps, env variable changes, or breaking changes

## Step 5: Confirm with User

Present the proposed MR and ask for confirmation using `AskUserQuestion`:

```
"Připravený MR:"

Title: feat(auth): add Google OAuth login [ANT-42]
Target: main
Draft: No

--- Description preview ---
## What
Added Google OAuth as a second login option...
...

Options:
- Vytvořit MR (doporučeno)
- Vytvořit jako Draft
- Upravit title
- Upravit popis
- Zrušit
```

If user chooses to edit title or description, ask them for the new value directly (no fixed options needed — just ask for text input).

## Step 6: Create the MR

```bash
glab mr create \
  --title "{title}" \
  --description "{description}" \
  --target-branch {target_branch} \
  --assignee @me \
  [--draft]
```

After creation, print the MR URL so the user can open it directly.

---

## Branch Naming Convention (Reference)

When asked, also guide users on proper branch naming:

```
{type}/{ticket-id}-short-description-in-kebab-case
```

Examples:
```
feature/ANT-42-google-oauth-login
fix/ANT-123-checkout-double-submit
refactor/extract-article-repository
hotfix/payment-gateway-null-pointer
chore/upgrade-laravel-12
```

Rules:
- Use the same type prefixes as the Conventional Commits table above
- Include ticket ID when available (Asana, Jira, GitLab issue)
- Description in **kebab-case**, lowercase
- Keep it short — 3–5 words max after the ticket ID
- No slashes inside the description part

---

## Multiple Repos Mode

If extra instructions mention multiple repositories (e.g. "for all 3 repos"), run the full flow for each:

1. Ask user to confirm the list of repo paths if not obvious
2. For each repo: switch to it, run Steps 1–6
3. Titles and descriptions can differ per repo — adapt based on each repo's branch and commits
4. After all MRs are created, print a summary with all MR URLs

---

## Critical Rules

1. **Imperative mood** in title — always
2. **No trailing period** in title
3. **Max 72 chars** in title
4. **Link tasks** — if ticket number found in branch name, include it in title and description
5. **Never force-push** or modify branch during this flow
6. **Respect extra instructions** — user-provided args override any default behavior
7. **Czech output** — use Czech for all questions and confirmations unless user writes in English

## Error Handling

- **glab not installed**: `brew install glab`
- **glab not authenticated**: `glab auth login --hostname {hostname}`
- **Branch not pushed**: Run `git push -u origin {branch}` first, then retry
- **No commits vs target**: Warn user — "Větev neobsahuje žádné nové commity oproti `{target_branch}`"
- **Diverged from target**: Suggest rebasing before creating MR

## Dependencies

- **glab CLI**: Must be installed and authenticated for the target GitLab instance
- **git**: For analyzing branch changes
