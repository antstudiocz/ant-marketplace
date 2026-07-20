---
user-invocable: true
name: implementation-orchestrator
description: Use for end-to-end implementation work from git and runtime discovery through clarification, planning, delegated implementation, independent review, verification, and optional delivery.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator to coordinate a durable, delegated implementation workflow.

Use this skill for features, fixes, refactors, migrations, audits, and remediation that should end in verified implementation. For a new application or app-like surface, start with `ant:create-application` when available, then hand the approved brief here.

## Core Invariants

- Root is user-facing and dispatch-only. It may inspect git/delivery state and orchestration artifacts, but it does not inspect application implementation files or make implementation edits.
- Every implementation, follow-up, review fix, debugging change, and polish edit is delegated through a verified fresh-context path.
- `references/lifecycle.md` alone owns lifecycle order and gates.
- `state.json` and `events.jsonl` under `.ant/orchestrator/<run-id>/` are the machine source of truth. Markdown is a concise human resume layer.
- Before first delegation, preflight current host capabilities. Unknown is recorded as `unknown`, never guessed.
- Host-neutral routing asks for capabilities, never fixed model slugs. Requested and host-observed actual values remain distinct.
- Every delegated packet is classified `low`, `medium`, or `high` under the adaptive reasoning policy; adapters translate the requested tier through current host capabilities.
- Mutation and delivery fail closed under `references/policies/approval-policy.md`; metadata and prompt memory are never authorization.
- Completion requires scenario-linked evidence and the review manifest defined under `references/policies/`.
- Store timestamps in UTC/Zulu. Convert to local time only in UI rendering.

## Lazy Reference Loading

Read `references/lifecycle.md` first, then load only what the next action needs:

| Next action | Load |
|---|---|
| terminology or transition decision | `references/policies/vocabulary.md`, `references/policies/approval-policy.md` |
| first delegation, complexity classification, or host/surface change | `references/policies/reasoning-policy.md`, `references/runtime/capability-routing.md`, then the detected host adapter |
| planning or implementation delegation | the matching `references/*-role.md` and `references/templates/task-packet.md` |
| task-scoped work | `references/task-scoped-execution.md` |
| validation, review, or completion | `references/policies/evidence-policy.md`, `references/policies/review-manifest.md`, reviewer card, review template |
| phase close or delivery | matching template plus approval policy |

Do not load every role, template, and host adapter up front.

## High-Level Flow

1. Recover or bootstrap the run and discover repository, git, delivery, and runtime facts.
2. Ask all and only unresolved user-owned blocking questions, grouped without an arbitrary cap or repeats.
3. Classify cycle risk, challenge weak directions, and obtain strategy/direction decisions.
4. Create and review a concrete plan when risk warrants it.
5. Persist a scoped approval, then delegate implementation using capability routing.
6. Integrate, validate scenarios, independently review, fix findings, and re-review as required.
7. Close with evidence and an explicit delivery handoff; delivery itself remains separately authorized.

Follow `references/lifecycle.md` for exact transitions, stop conditions, recovery, and completion criteria.
