---
name: merge-request
description: Prepare or deliver a GitHub PR or GitLab MR, observe its exact-head checks, or resolve local or remote merge conflicts.
---

# Merge Request

This skill owns PR/MR delivery and conflict resolution. State the requested mode briefly. Resolve repository, source/target, language and readiness from the user's instructions, repository rules, then provider metadata and safe defaults. Preserve unrelated work; resolve only material ambiguity before dependent actions.

## Modes

- **Preview:** prepare title, description and readiness without mutations or pipeline observation. Read the [description rules](references/provider-delivery.md#description).
- **Create/update:** an explicit request authorizes the safely scoped commit/push/provider create or update and bounded observation for the already agreed repository scope and targets resolved from the instructions, repository/provider context, or safe defaults. New PRs/MRs default to draft; preserve existing readiness unless a readiness change is explicitly authorized. It does not authorize unrelated repositories, merge, release, deployment, or history rewrite. Read [provider delivery](references/provider-delivery.md).
- **Observe/status:** inspect current-head provider metadata and checks only. No fetch, retry, repair or local/provider mutation. Read [exact-head observation](references/provider-delivery.md#exact-head-observation).
- **Conflict resolution:** follow [conflict resolution](references/conflict-resolution.md). Conflict preparation alone grants no staging, commit, push, provider-update or pipeline-observation authority.

## Authority and completion

Existing action-specific authority carries forward. Delivery does not imply merge, release, tag, publication, deployment or history rewrite; rebase, force-push and reset require explicit authority. For an authorized release, read the [release-note rules](references/provider-delivery.md#release-notes).

The orchestrator's [lifecycle](../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate) owns implementation, repair, review and endpoint criteria. Distinguish draft delivery from an explicit merge-ready request; neither local checks nor an observation timeout proves the latter complete.

Report the requested outcome, provider URL when applicable, actions, decisive evidence, material gaps and next step. Use the observation reference for CI evidence; report the merge/index state for conflicts. State when no provider mutation occurred.
