---
name: merge-request
description: Prepare or deliver a GitHub PR or GitLab MR, observe its exact-head checks, or resolve local or remote merge conflicts.
---

# Merge Request

**Announce at start:** Say you will inspect git/provider context and handle only the requested preview, delivery, observation, or conflict mode.

This is the only skill for PR/MR delivery and conflict resolution. Inspect repository instructions, branch/status, remotes, target, and the relevant diff before choosing a mode. Preserve unrelated work.

## Modes

- **Preview:** prepare a title, readiness, and description without staging, committing, pushing, provider mutation, or pipeline observation.
- **Create/update:** explicit authority permits only the scoped commit/push/provider create-or-update chain and finite exact-head observation. Draft is the default; preserve existing readiness unless asked to change it.
- **Observe/status:** inspect provider metadata and checks for the current exact head. It is read-only: no fetch, retry, repair, worktree mutation, staging, commit, push, provider update, or readiness change.
- **Conflict resolution:** read [conflict-resolution.md](references/conflict-resolution.md). Conflict preparation does not imply staging, commit, push, provider mutation, or pipeline observation.

For Create/update or Observe/status, read [provider-delivery.md](references/provider-delivery.md). Keep provider source head and actual tested SHA separate. Missing, mismatched, skipped, neutral, timed-out, or incomplete checks are unverified. Observe/status failures are report-only and require a separate fix request before repair. During an already-authorized Create/update, an in-scope exact-head regression returns to `implementation-orchestrator` for bounded repair, targeted checks, independent review, and refreshed candidate evidence; retry authority, credentials, external state, and scope expansion remain blockers.

## Description and authority

- Use Conventional Commit titles and a concise English description built from the final target merge-base-to-`HEAD` snapshot: summary, rationale, material impact/risk, and truthful verification gaps.
- Resolve provider, target, language, and readiness from explicit instruction, repository rules, existing metadata, then safe defaults. Stop when a material choice remains ambiguous.
- Delivery never implies merge, release, deployment, tag, publication, or history rewrite. Rebase, force-push, reset, and merge require separate explicit authority.

## Completion

Report mode, provider URL/object, source head, tested SHA, target, readiness, actions performed, exact-head observation, verification gaps, and preserved unrelated state. State explicitly when no provider mutation occurred.
