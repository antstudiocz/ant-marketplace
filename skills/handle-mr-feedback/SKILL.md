---
user-invocable: true
name: handle-mr-feedback
description: Analyze GitLab MR review comments, validate them against code using subagents, and create an implementation plan for selected items. Use when user provides a GitLab MR URL and wants to handle reviewer feedback systematically.
---

# Handle MR Feedback

## Purpose

Systematically process GitLab MR review comments:
1. **Analyze** - Fetch and validate all review threads
2. **Select** - Let user choose which feedback to implement
3. **Plan** - Create implementation plan for selected items
4. **Execute** - Optionally proceed with implementation

## Step 1: Parse MR URL

GitLab URL formats:
- `https://gitlab.example.com/group/project/-/merge_requests/123`
- `https://gitlab.example.com/group/subgroup/project/-/merge_requests/123`

Extract:
- **hostname** (e.g., `gitlab.example.com`)
- **project_path** (e.g., `group/project` or `group/subgroup/project`)
- **mr_number** (e.g., `123`)

## Step 1.5: Find Local Repository and Checkout Branch (CRITICAL)

**Before doing anything else**, you MUST:

1. **Fetch MR details to get the source branch:**
```bash
glab api "projects/{URL_ENCODED_PROJECT}/merge_requests/{MR_NUMBER}" --hostname {HOSTNAME} | jq '{source_branch: .source_branch, target_branch: .target_branch}'
```

2. **Find the local repository** by matching git remote URL:

**First, check current working directory:**
```bash
# Check if current directory is the matching repo
remote=$(git remote get-url origin 2>/dev/null)
if echo "$remote" | grep -q "{project_path}"; then
  echo "Found: $(pwd)"
fi
```

**If not found, search common developer locations:**
```bash
# Search common locations for matching git remote
for base in ~/Sites ~/projects ~/code ~/repos ~/dev ~/workspace ~/src ~; do
  if [ -d "$base" ]; then
    for dir in "$base"/*/ "$base"/*/*/; do
      if [ -d "$dir/.git" ]; then
        remote=$(git -C "$dir" remote get-url origin 2>/dev/null)
        if echo "$remote" | grep -q "{project_path}"; then
          echo "$dir"
          break 2
        fi
      fi
    done
  fi
done
```

3. **Change to the repository directory** and checkout the branch:
```bash
cd {FOUND_REPO_PATH}
git fetch origin
git checkout {source_branch}
git pull origin {source_branch}
```

4. **Verify** you are on the correct branch:
```bash
git branch --show-current
```

**If repository not found:** Ask user for the path using `AskUserQuestion`:
```
"Nenašel jsem lokální repozitář pro {project_path}. Kde je umístěn?"

Options:
- [Current working directory if it's a git repo]
- Other (user provides path)
```

**IMPORTANT:** All subsequent file operations (reading, editing) must happen in this repository directory!

---

## Step 2: Fetch MR Threads

Use glab CLI to fetch all notes:

```bash
# Fetch all notes (comments) from the MR
glab api "projects/{URL_ENCODED_PROJECT}/merge_requests/{MR_NUMBER}/notes" --hostname {HOSTNAME}
```

Where `{URL_ENCODED_PROJECT}` is the project path with `/` replaced by `%2F`.

### Filter threads:
1. **Open threads**: `resolvable == true && resolved == false`
2. **General comments**: `resolvable == false && system == false && type == null`

Ignore:
- System messages (commits added, etc.)
- Already resolved threads

## Step 3: Validate Each Thread

For EACH thread, spawn a **subagent** (Task tool with Explore) to:

1. Read the referenced file and surrounding context
2. Analyze if the feedback is valid:
   - Does the issue actually exist in the code?
   - Is the suggested fix appropriate?
   - Are there any complications?
3. Provide assessment: **Valid** / **Partially Valid** / **Invalid** / **Needs Discussion**
4. Summarize the issue in one sentence

### Subagent prompt template:

```
Analyze this MR review comment and validate it against the actual code.

**File**: {file_path}
**Line**: {line_number}
**Comment**: {comment_body}
**Author**: {author}

Tasks:
1. Read the file {file_path} around line {line_number}
2. Understand the reviewer's concern
3. Check if the issue is valid
4. Assess the suggested solution (if any)

Return a JSON object:
{
  "valid": "yes" | "partial" | "no" | "discuss",
  "summary": "One sentence summary of the issue",
  "analysis": "Brief explanation of your assessment",
  "file": "{file_path}",
  "line": {line_number}
}
```

## Step 4: Generate Report

Create a markdown table with all findings:

```markdown
## MR Review Analysis: {MR_TITLE}

| # | File | Line | Author | Issue | Valid? |
|---|------|------|--------|-------|--------|
| 1 | ArticleResolver.php | 160 | dan.kop | DRY - create helper for translatable fields | ✅ Yes |
| 2 | ArticleResource.php | 125 | dan.kop | Move hardcoded URL to config | ✅ Yes |
| 3 | ... | ... | ... | ... | ⚠️ Partial |

### General Comments (not file-specific):
- **dan.kop**: Create `setLocaleFromArgs()` method in base class - ✅ Valid

### Summary:
- Total threads: X
- Valid: Y
- Needs discussion: Z
```

## Step 5: User Selection (CHECKPOINT)

Use `AskUserQuestion` with multiselect to let user choose:

```
"Které položky z review chceš zapracovat?"

Options (multiselect):
☑ [1] ArticleResolver.php:160 - DRY helper for translatable fields
☑ [2] ArticleResource.php:125 - Move URL to config
☐ [3] ...
☑ [4] General: setLocaleFromArgs() trait
```

If user selects nothing or cancels, end the skill gracefully.

## Step 6: Create Implementation Plan

For selected items, invoke the `/superpowers:writing-plans` skill:

```
Call Skill tool with:
  skill: "superpowers:writing-plans"
  args: (context about selected MR feedback items)
```

Provide context to the planning skill:
- List of selected issues with file paths and line numbers
- The reviewer's suggestions
- Any relevant code context

## Step 7: Implementation Confirmation (FINAL CHECKPOINT)

After plan is created, ask user:

```
"Plán je připraven. Chceš pokračovat s implementací?"

Options:
- Ano, implementovat
- Ne, jen uložit plán
- Upravit plán
```

If user chooses to implement, proceed with the plan execution.

## Critical Rules

1. **ALWAYS find and checkout the correct branch FIRST** - before validating any code, you must be in the correct repository on the correct branch
2. **ALWAYS use subagents** for code validation - don't guess without reading the actual code
3. **NEVER skip the user selection step** - user must approve what gets implemented
4. **Summarize clearly** - reviewer comments can be verbose, distill to actionable items
5. **Respect resolved threads** - only show open/unresolved items
6. **Handle general comments** - not all feedback is tied to specific lines
7. **Use Czech** for all user-facing output (unless user writes in English)

## Error Handling

- **glab not authenticated**: Instruct user to run `glab auth login --hostname {hostname}`
- **MR not found**: Verify URL format and permissions
- **No open threads**: Report "Žádné otevřené review komentáře" and end

## Example Usage

```
User: /handle-mr-feedback https://git.antstudio.cz/ange/project/-/merge_requests/52

Claude:
1. Fetches 4 open threads
2. Validates each with subagents
3. Shows analysis table
4. Asks: "Které položky chceš zapracovat?" [multiselect]
5. User selects items 1, 2, 4
6. Creates implementation plan
7. Asks: "Chceš pokračovat s implementací?"
8. User confirms → implements
```

## Dependencies

- **glab CLI**: Must be installed and authenticated for the target GitLab instance
- **Git**: For accessing the codebase
- **/superpowers:writing-plans**: For creating implementation plans
