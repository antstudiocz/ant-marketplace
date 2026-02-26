---
user-invocable: true
name: merge-conflicts
description: Intelligently resolve git merge conflicts through deep contextual analysis. Use when merge conflicts are detected locally or in a GitLab MR. Never blindly accepts one side — always analyzes both sides' intent and proposes intelligent merging.
---

# Merge Conflicts

## Purpose

Intelligently resolve git merge conflicts by:
1. **Detect** — find all conflicted files (local or remote MR)
2. **Analyze** — deep contextual analysis of each conflict with subagents
3. **Classify** — categorize as simple (auto-resolve) or complex (interactive)
4. **Resolve** — auto-resolve simple conflicts, present complex ones for approval
5. **Finalize** — stage, commit, optionally push

**Announce at start:** "I'm using the merge-conflicts skill to intelligently resolve your merge conflicts."

## Iron Rule

**NEVER blindly accept one side of a conflict.** Every conflict — even "simple" ones — must be analyzed for intent. Auto-resolve means intelligently merging both sides, not picking a winner. If a user explicitly requests accepting one side on a complex conflict, that is their choice — but the skill never does it autonomously.

## Step 1: Detect Trigger Mode

Parse the user's command for arguments:
- `/merge-conflicts` (no args) → **Local mode** — resolve conflicts in current working directory
- `/merge-conflicts <GitLab MR URL>` → **Remote mode** — resolve conflicts from MR

If no arguments and no conflicts detected, also check if skill was triggered automatically (Claude detected conflicts during other work) → **Local mode**.

### Language Detection

Detect the language of the user's message. Use that language for ALL subsequent user-facing communication. If unclear, default to English.

## Step 2: Inventory Conflicts

### Local Mode

```bash
# List all conflicted files
git diff --name-only --diff-filter=U
```

If no files returned, inform user: "No merge conflicts found." and end.

### Remote Mode (GitLab)

Parse GitLab URL formats:
- `https://gitlab.example.com/group/project/-/merge_requests/123`
- `https://gitlab.example.com/group/subgroup/project/-/merge_requests/123`

Extract: **hostname**, **project_path**, **mr_number**

```bash
# Fetch MR details
glab api "projects/{URL_ENCODED_PROJECT}/merge_requests/{MR_NUMBER}" --hostname {HOSTNAME}
```

Extract `source_branch` and `target_branch`.

**Find local repository:**
1. Check if current directory has a git remote matching `{project_path}`
2. If not, search user's home directory for matching repos
3. If not found, ask user for path using `AskUserQuestion`

**Checkout and create conflicts locally:**
```bash
git fetch origin
git checkout {source_branch}
git pull origin {source_branch}
git merge origin/{target_branch}
```

If no conflicts after merge, inform user and end.

**Error handling:**
- `glab` not installed → instruct: "Install glab CLI and run `glab auth login --hostname {hostname}`"
- MR not found → verify URL format and permissions

### Inventory Summary

For all conflicted files:
1. Read each file and extract conflict blocks (between `<<<<<<<` and `>>>>>>>`)
2. Count total files and conflict blocks
3. Filter out binary files — report them separately as needing manual resolution

**If 20+ conflicted files:**
Use `AskUserQuestion`:
- Question: "{count} conflicted files detected. Analyze all or select a subset?"
- Options:
  - "All files"
  - "Let me select" → show file list for selection

Display summary:
```
Conflict inventory:
- {X} files with conflicts
- {Y} total conflict blocks
- {Z} binary files (need manual resolution)
```

## Step 3: Parallel Deep Analysis

For **each conflicted file**, spawn a subagent using the Task tool (subagent_type: Explore):

### Subagent Prompt Template

```
Analyze the merge conflict in file {file_path} in the repository at {repo_path}.

## Tasks

1. **Read the entire file** and understand its purpose, structure, and role in the project
2. **For each conflict block** (between <<<<<<< and >>>>>>>):
   - What does the HEAD (current) side change? What is its intent?
   - What does the incoming side change? What is its intent?
   - Are the changes complementary, contradictory, or overlapping?
3. **Map the blast radius:**
   - Search for files that import or reference this file
   - Search for code that calls the changed functions/methods/classes
   - Find test files related to this code
   - Identify affected types/interfaces
4. **Classify each conflict block:**
   - "simple" if: duplicate imports, whitespace/formatting, both sides adding to a list, rename without logic change
   - "complex" if: both sides change same logic/condition, function signature change vs call site change, structural refactoring vs new functionality, any change where both sides modify behavior
5. **Propose a resolution** for each block that intelligently merges both sides' intent

## Output Format

Return ONLY a JSON object (no markdown fences, no explanation):
{
  "file": "{file_path}",
  "purpose": "One sentence describing what this file does",
  "conflicts": [
    {
      "lines": "start-end line numbers of the conflict block",
      "type": "simple" or "complex",
      "head_intent": "What the HEAD side is trying to do",
      "incoming_intent": "What the incoming side is trying to do",
      "relationship": "complementary" or "contradictory" or "overlapping",
      "dependencies": ["list of files that depend on/use this code"],
      "tests": ["list of related test files"],
      "recommended_resolution": "Description of how to merge both sides",
      "resolved_code": "The actual resolved code to replace the conflict block"
    }
  ]
}
```

**If a subagent fails:** classify all conflicts in that file as `complex` and note the failure. The file will be presented for manual resolution.

## Step 4: Auto-Resolve Simple Conflicts

For each conflict block classified as `simple`:

1. Replace the entire conflict block (from `<<<<<<<` to `>>>>>>>` inclusive) with the `resolved_code` from the subagent
2. Track what was auto-resolved

**After all simple conflicts are resolved, display summary:**
```
Auto-resolved ({X} files, {Y} blocks):
  {file1} — {description}
  {file2} — {description}
  ...
```

## Step 5: Present Complex Conflicts

For each conflict block classified as `complex`, present to the user:

### Presentation Format

```
### {file_path} (block {N}/{total})

**File purpose:** {purpose}

**HEAD (current) changes:** {head_intent}
**Incoming changes:** {incoming_intent}
**Relationship:** {relationship}

**Blast radius:**
- Dependencies: {list}
- Tests: {list}

**Proposed resolution:**
```{language}
{resolved_code}
```

**Reasoning:** {recommended_resolution}
```

Use `AskUserQuestion` for each complex conflict:
- Question: "How to resolve this conflict?"
- Options:
  - "Accept proposed resolution"
  - "Modify — I'll describe changes"
  - "Accept HEAD (current) side"
  - "Accept incoming side"

If user selects "Modify", ask them to describe the desired changes, then generate updated resolution and present again.

## Step 6: Validate Resolution

After ALL conflicts are resolved:

1. **Verify no remaining conflict markers:**
   ```bash
   grep -rn "^<<<<<<<\|^=======\|^>>>>>>>" {files}
   ```
   If any remain, report and re-present those files.

2. **Show final diff:**
   ```bash
   git diff {resolved_files}
   ```
   Display to user for review.

3. **Optional validation:**
   If project has linter/typecheck configured, suggest running it:
   "Resolved files are ready. Want to run linter/typecheck to verify?"

## Step 7: Stage and Commit

1. **Stage all resolved files:**
   ```bash
   git add {all_resolved_files}
   ```

2. **Generate commit message:**
   ```
   merge: resolve {X} conflicts from {source} into {target}

   Auto-resolved (simple):
   - {file} — {description}

   Manually resolved (complex):
   - {file} — {description}
   ```

3. **Present commit message** to user for approval/editing

4. **Commit** with approved message

5. **Remote mode only:** Ask user:
   - Question: "Push resolved conflicts to remote?"
   - Options:
     - "Yes, push to {source_branch}"
     - "No, keep local only"

## Critical Rules

1. **NEVER blindly accept one side** — always analyze both sides' intent and propose intelligent merge
2. **ALWAYS use subagents** for analysis — never guess without reading actual code and dependencies
3. **ALWAYS present complex conflicts** to user — never auto-resolve anything that changes behavior
4. **Verify zero remaining markers** — no conflict markers may remain in any file after resolution
5. **Auto-detect language** — communicate in the user's language
6. **Binary files** — skip analysis, inform user they need manual resolution

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No conflicts found | Inform user, end gracefully |
| Remote MR without conflicts | Inform user, end gracefully |
| `glab` not installed/authenticated | Instruct: `glab auth login --hostname {hostname}` |
| Subagent failure for a file | Classify as `complex`, present for manual resolution with warning |
| Binary files in conflicts | Skip analysis, list separately, inform user |
| 20+ conflicted files | Warning + ask user to analyze all or select subset |
| Remaining markers after resolution | Re-present unresolved blocks |

## Dependencies

- **git** — conflict detection and resolution
- **glab CLI** — GitLab MR integration (optional, only for remote flow)
- **Task tool (Explore subagents)** — parallel deep analysis
- **AskUserQuestion** — user interaction for complex conflicts and options
