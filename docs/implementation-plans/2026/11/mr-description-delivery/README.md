# PR/MR description delivery

## Scope and authority

The user approved the description changes and explicitly requested a PR and an
admin merge, plus a concise Czech message draft for colleagues. Port the agreed
instruction-only change onto current master, preserving unrelated upstream work.
Prepare patch metadata 13.9.4 and release notes so marketplace updates identify
this change. No separate GitHub release/tag or message sending is requested.

## Ownership and constraints

Root owns this plan and delivery. A fresh integration owner writes the scoped
skill, metadata and public documentation. Independent read-only review covers
current upstream compatibility, user-facing outcome and the complete candidate.
The current review policy requires opposite-provider coverage for source authors;
retain the user's Sol review preference alongside that coverage. No nested agents.
No private fixtures, internal project evidence or host-specific historical plans
belong in this public PR. Preserve the original dirty checkout and open PRs.

## Acceptance

- Short flat human bullets, captioned durable captures, stable descriptions without
  transient CI/MR snapshots; concrete functional risks and operator actions remain.
- Preserve upstream post-deployment action requirements, canonical review routing,
  exact-head observation semantics, release-note contracts and authority limits.
- Three version fields match 13.9.4; public documentation and release notes agree.
- Plugin/JSON/frontmatter/links/version/diff checks and independent review pass.
- Create a ready PR for the explicit merge request, observe its exact head with a
  finite budget, require passing exact-head checks, admin squash-merge that head
  and verify master inclusion. Admin authority bypasses only the provider approval
  requirement, not failed or pending required checks.
- Prepare a short colleague message; do not send it or claim automatic reliability.

## Status

The scoped integration and local final gate are complete: both plugin validators,
JSON/frontmatter/version/diff checks pass, with the existing missing-icon warning.
Upstream exact-head observation and release-note contracts are preserved, including
verified-none/unknown post-deployment action behavior. No runtime gate applies to
this instruction-only change. The candidate is frozen for independent provider-aware
review, followed by the authorized PR/admin merge. No native Goal requested/created.
Review and delivery readback are reported outside this frozen planning snapshot.

## Scenario and delivery checkpoint

- Review ordinary, supported-no-action and unknown-action descriptions against the
  same flat, visible post-deployment contract.
- Check header-first and unverified legacy parsers: unverified pre-note details
  use the captioned flat-list fallback until compatibility is established.
- Check no-UI/unavailable capture handling and keep real functional limitations.
- Keep CI/source attribution and failure state in the separate delivery report;
  failed or pending required gates leave merge-ready incomplete.

PR #106 is open on the first immutable candidate. Overall cross-provider review
requested bounded clarification of operator detail placement, parser compatibility,
and review/report scope; this repaired candidate contains those clarifications. The original
workspace and other PRs remain outside this change. No separate release/tag is
created by this delivery plan. Final exact-head review/merge readback is retained
in the delivery report after the planning snapshot is frozen.
