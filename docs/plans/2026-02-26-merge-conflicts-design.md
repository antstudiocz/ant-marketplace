# Merge Conflicts Skill — Design Document

## Overview

Skill `merge-conflicts` for intelligent resolution of git merge conflicts. Never blindly accepts one side — always performs deep contextual analysis and proposes intelligent merging of both sides' intent.

## Triggering

### Manual
- `/merge-conflicts` — resolve local git conflicts
- `/merge-conflicts <GitLab MR URL>` — resolve remote MR conflicts

### Automatic
- Claude detects merge conflicts during other work (files with `<<<<<<<` markers, `git status` showing "both modified")

## Architecture: Sequential with Parallel Subagents

```
Detection → Parallel Analysis (subagents) → Classification → Auto-resolve simple → Present complex → Stage + Commit
```

## Flow

### Step 1: Detection & Inventory

**Local flow:**
- `git diff --name-only --diff-filter=U` for conflicted files list
- Extract conflict blocks (between `<<<<<<<` and `>>>>>>>`)
- Summary: file count, conflict block count

**Remote (GitLab) flow:**
- Parse MR URL → extract hostname, project_path, mr_number
- `glab` CLI to fetch MR details (source_branch, target_branch)
- Find local repo, checkout source branch
- `git merge target_branch` locally → analyze conflicts

### Step 2: Parallel Deep Analysis (Subagents)

For **each conflicted file**, spawn a subagent (Task tool, type Explore):

1. Read entire file — understand purpose and structure
2. Analyze both sides — what HEAD vs incoming changes, and why
3. Map blast radius:
   - Who imports this file/function?
   - Who calls changed functions/methods?
   - Do tests exist for this code?
   - What types/interfaces are affected?
4. Classify each conflict block: `simple` or `complex`
5. Propose resolution

#### Subagent returns JSON:
```json
{
  "file": "path/to/file",
  "purpose": "File purpose in one sentence",
  "conflicts": [
    {
      "lines": "10-25",
      "type": "simple|complex",
      "head_intent": "What HEAD changes",
      "incoming_intent": "What incoming changes",
      "dependencies": ["files depending on this code"],
      "tests": ["relevant test files"],
      "recommended_resolution": "Description of proposed resolution",
      "resolved_code": "Final merged code"
    }
  ]
}
```

### Step 3: Classification & Resolution

#### Simple (auto-resolve):
- Duplicate imports → merge both, remove duplicates
- Whitespace/formatting → accept side consistent with surrounding code
- List additions → include items from both sides
- Renames without logic change → accept newer naming

Display summary:
```
Auto-resolved (3 files, 5 blocks):
  src/utils/index.ts — merged imports
  package.json — merged dependencies
  src/config.ts — whitespace normalization
```

#### Complex (interactive):
For each complex conflict, present:
1. **Context** — file purpose, what each side changes, why
2. **Blast radius** — who depends on this code, what tests exist
3. **Proposed resolution** — concrete code combining both sides' intent
4. **Alternatives** — if multiple valid approaches exist

User options per complex conflict:
- Accept proposal
- Modify — user describes desired changes
- Accept HEAD (explicit user choice only)
- Accept incoming (explicit user choice only)

#### Iron Rule
Skill **never** accepts one whole side on complex conflicts. Always proposes intelligent merge. One-side acceptance requires explicit user choice.

### Step 4: Finalization & Commit

1. **Apply** — write resolved code, replace conflict markers
2. **Validate** — verify no remaining `<<<<<<<`/`=======`/`>>>>>>>` markers
3. **Review** — `git diff` of resolved files shown to user
4. **Stage** — `git add` all resolved files
5. **Commit** — generate descriptive commit message:
   ```
   merge: resolve X conflicts from {source} into {target}

   Auto-resolved (simple):
   - file1.ts — merged imports

   Manually resolved (complex):
   - file3.ts — combined auth logic from both branches
   ```
6. User approves/edits commit message → commit
7. **Remote only:** Ask to push to remote

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No conflicts found | Inform user, end |
| Remote MR without conflicts | Inform user, end |
| `glab` not installed/authenticated | Instruct: `glab auth login --hostname {hostname}` |
| Subagent failure | Classify file as `complex`, present for manual resolution |
| Binary files | Skip analysis, inform user these need manual resolution |
| 20+ conflicts | Warning + ask user to analyze all or select subset |

## Communication

- Language auto-detected from user's input
- Platform: GitLab only (via `glab` CLI)

## Dependencies

- **git** — conflict detection and resolution
- **glab CLI** — GitLab MR integration (optional, only for remote flow)
- **Task tool (Explore subagents)** — parallel deep analysis
