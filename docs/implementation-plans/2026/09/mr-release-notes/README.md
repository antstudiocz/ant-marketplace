# MR release-note contract

## Scope and endpoint
User requested impacts before release notes, collapsed verification, and a plugin PR. Endpoint: reviewed draft PR targeting master. No release, version publication, merge, installation, or runtime changes. Isolated clone from clean de134f632f2ea5388e10f77433f500d692193130. Root owns this plan; integration worker owns scoped instruction and general documentation files. Native Goal was not requested.

## Acceptance and decisions
Descriptions represent the final merge-base-to-HEAD change: visible summary/rationale and impacts, then an exact Release notes section with optional New features, Improvements, Fixes, and Internal changes bullet categories. No release impact is explicit. Availability, default-off flags and necessary action belong in the entry. Verification and implementation evidence are collapsed after notes; material gaps stay visible. The notes section is bounded by next level-2 heading or details block. Keep the plugin instruction-only and policy in provider-delivery.md. The consuming app is implemented separately under its own plan.

## Evidence and review
Incremental cadence: inspect existing delivery rules and authoring invariants, implement the smallest coherent change, review normal/default-off/no-impact cases and links, then validate the exact candidate. Fresh Luna High worker implemented three files; independent Sol High reviewer found no material findings and confirmed producer boundaries, final-snapshot refresh, collapsible details, publication anchor and authority preservation. Source target remains master at the recorded baseline.

Owner checks passed: claude plugin validate for marketplace and plugin; jq parsing for all four manifests; git diff --check; manual feature-flag/no-impact/details-exclusion cases. Python quick validation was unavailable because PyYAML is absent; Ruby frontmatter validation passed. Root final gate uses the two plugin validators, manifest parsing and diff check on this candidate.

## Final checkpoint
Implementation and independent review complete. Freeze the scoped source and this root plan, run final gate, commit and create draft PR. Observe current-head provider checks within a finite 120-second budget and report actual status; no merge-ready claim is requested. Retrospective: a small human-readable section contract enables deterministic downstream composition without introducing plugin runtime or duplicate machine payloads. Delivery metadata and CI status are reported in the task to preserve the frozen candidate.
