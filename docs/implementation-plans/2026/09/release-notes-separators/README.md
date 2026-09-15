# Release notes separators

## Authorized delivery follow-up

User requested PR creation, admin merge, and release. Use a clean worktree from current origin/master (499b8e8), preserve original checkout changes, publish patch v13.5.2 after v13.5.1. Owner scope expands to the three version manifests, README release link, and new docs/releases/13.5.2.md. Root owns this plan. Owner and reviewer retain their explicit isolated routes and boundaries. Both Claude validations, JSON syntax, version consistency, and independent expanded review passed. Branch protection requires review but no status checks; user explicitly authorized admin merge. Freeze this candidate, commit/push PR, inspect exact-head provider gates within five minutes, admin merge the reviewed head, and publish the release at its verified merge commit with a verified PR link. No native Goal requested. Status: reviewed local release candidate; provider completion will be recorded in the task without mutating the frozen candidate.

- Request: visually separate the complete PR/MR release notes block above and below.
- Scope: canonical provider-description instructions and Markdown example; implementation-only, no publication or version change.
- Acceptance: standalone `---` with blank lines before the release heading and after all entries, before details; also applies to `No release impact.`. Preserve exact headings and extraction boundaries.
- Continuity/cadence: in-place, one proportional final sweep. Existing untracked `plugin-13-5-0` plan is unrelated and preserved.
- Ownership: root owns this plan; fresh Luna High integration owner edits provider-delivery.md; fresh Sol High reviewer is read-only. No nested delegation.
- Evidence: inspect normal and no-impact formatting, independent simplicity/contract review, then `git diff --check` as final gate. No runtime changes; full plugin suites unnecessary.
- Goal: not requested or created.
- Status: implementation complete; Luna owner and independent Sol reviewer verified populated and no-impact instructions, preserved headings and extraction terminators, and found no material simplicity or contract issues. Public docs already link the canonical reference. No render/runtime test was required for this instruction-only change.
- Final checkpoint: freeze scoped files by SHA-256 after this checkpoint and run `git diff --check`; results reported in the task. No delivery requested. Retrospective: one canonical rule and its existing example were sufficient; no extra framework or duplicated template needed.
