---
name: merge-request
description: Prepare, create, or update a GitHub PR/GitLab MR; observe its exact-head pipeline; or intelligently resolve local and remote merge conflicts.
---

# Merge Request

**Announce at start:** Say you will inspect git/provider context and handle only the requested preview, delivery, Observe/status, or conflict mode.

This is the sole public skill for PR/MR delivery and merge-conflict resolution. It may deliver verified work but is never the tracked implementation writer.

## Classify Intent

Choose exactly one mode before acting:

1. **Preview:** prepare/propose/show a title or body. Read-only; never stage, commit, push, create/update a provider object, or observe pipelines.
2. **Create/update:** explicitly create/open/make/update a PR/MR. This authorizes only the safely scoped commit/push/create-or-update chain and exact-head observation. It does not authorize merge, release, tag, publish, deployment, rebase, force-push, reset, or history rewrite.
3. **Observe/status:** inspect an existing GitHub PR/GitLab MR's provider metadata and boundedly observe checks for its current exact head. Load [provider-delivery.md](references/provider-delivery.md). Never stage, commit, push, create, update, change readiness, retry checks, or mutate the worktree. An observed failure reports diagnostics; it does not authorize repair or retry.
4. **Conflict resolution:** resolve local or remote merge conflicts. Load [conflict-resolution.md](references/conflict-resolution.md). Conflict edits do not imply staging, committing, pushing, provider mutation, or pipeline observation; each remains separately authorized.

Treat mistaken “merch request” as merge request only when context is clear. Ask only when the mode or another material choice remains ambiguous.

## Baseline And Inspection

- Follow repository instructions and preserve unrelated work. Detect GitHub/GitLab from `git remote -v`; stop if unsupported or ambiguous. Observe/status is purely diagnostic and read-only: dirty unrelated work is non-blocking because this mode performs no worktree/provider mutation.
- Resolve target, language, provider object, and readiness in this order: explicit instruction, repository rules/existing object, metadata, safe defaults. New objects are Draft by default; ordinary updates preserve readiness.
- Before any mode-specific action, inspect branch, status, remotes/upstream, staged and unstaged changes, recent commits, target, existing provider object, and relevant diff. Observe/status may inspect dirty-state diagnostics but must additionally resolve the existing object's current head and inspect only provider metadata and remote checks; it never mutates or requires cleaning the worktree/provider.
- Never stage blindly. If mixed or pre-staged unrelated work cannot be isolated for create/update, stop and ask. Preview and Observe/status never stage.

## Final Snapshot And Description

For create/update, every title and description is a snapshot of the final target merge-base-to-`HEAD` diff. Establish the target and merge base, inspect the complete net diff plus clearly scoped working-tree changes, derive behavior/rationale/impact/risk/verification from that snapshot, and rebuild after any commit. Metadata-only updates do not imply a source commit or push when no scoped source change needs delivery.

Use a concise human-first description: plain-language Summary, rationale or proven Root cause and rationale, material Impact and risk, then optional collapsed technical context and truthful verification. Never hide failed or unrun checks or describe abandoned work. Titles use Conventional Commit style in English unless repository/user policy says otherwise; do not add AI attribution or co-author trailers.

## Mode Workflows

- **Preview:** return the read-only provider/branch/title/readiness/body preview and stop.
- **Create/update:** run feasible targeted validation, stage only scoped paths/hunks, commit and push only when needed and authorized, rebuild the final snapshot, create/update while preserving readiness rules, then follow [provider-delivery.md](references/provider-delivery.md) for one finite exact-head observation budget. When this is the orchestrator's separately authorized pre-gate candidate publication for a CI broad gate, publish the frozen candidate without changing readiness (Draft remains the default), then observe its exact tested SHA. Reuse fresh candidate-bound validation when the operation makes no content change; a changed candidate requires refreshed evidence through `implementation-orchestrator`.
- **Observe/status:** load [provider-delivery.md](references/provider-delivery.md), resolve the object's current head, and boundedly observe only checks/pipeline matching that head under one finite total budget. If no checks register, report unverified absence. A failure is diagnostic only; it may describe or recommend a future repair handoff, but it must not invoke orchestrator repair, retry, fetch, or any mutation without a separate user fix request.
- **Conflict resolution:** follow [conflict-resolution.md](references/conflict-resolution.md). Conflict-only mode never creates/updates a provider object or watches pipelines.

## Pipeline Repair Handoff

This skill observes provider state and collects diagnostics; it never repairs tracked code. Create/update and Observe/status do not authorize retrying a failed check. Observe/status reports a recommended repair handoff only; a separate user fix request is required before invoking `implementation-orchestrator`. For an exact-head in-scope regression during an authorized create/update flow, return the failing check/job, provider source head, and actual tested SHA to `implementation-orchestrator`, which owns bounded repair, targeted checks, independent review, and candidate-bound broad-gate refresh before returning here. Credentials, external state, and material expansion remain blockers.

## Completion

Report the URL when one exists, provider source head SHA, target, actual tested SHA (including any authoritative synthetic test-merge/merged-result SHA), mode, readiness, actions actually performed, exact-head observation result, verification gaps, unrelated state preserved, and actions not authorized. Never imply that creation or clean conflict preparation means merged, green, or delivered. Observe/status must explicitly say no provider mutation occurred.
