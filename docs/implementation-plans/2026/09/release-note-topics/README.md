# Thematic release notes

Status: implementation. Endpoint: draft GitLab MR for deployer and draft GitHub PR for marketplace, no merge/deploy/publication. User approved the proposed parser, Luna, Astra, output and skill changes and requested PR delivery.

Continuity: deployer clean main evolved in feat/release-note-topics; marketplace isolated at /tmp/ant-marketplace-release-topics from current origin/master because original checkout has unrelated edits. Preserve them. No native Goal requested.

Acceptance: MR notes use canonical category H3 with optional topic H4; parser carries category/topic/source per bullet, including legacy ungrouped notes. Luna respects authored categories/groups and consolidates equivalent areas across MRs without merging unrelated topics/categories. Astra generates topic headings with concrete points, preserving coverage/actions without arbitrary three-detail truncation. UI/editor/publication preserve hierarchy and backward compatibility. No new service/schema migration unless demonstrated necessary.

Ownership: integration owner owns deployer source/tests/docs, bounded worker owns marketplace instruction/docs changes; root owns both plan bundles and delivery; independent Sol reviewer read-only. Children fresh Luna High, no nested delegation. Root coordinates consumer/producer contract.

Cadence: incremental, early parser-contract and output-shape inspection then focused tests, independent correctness/simplicity review, final broad backend/frontend gates and internal browser smoke. Restart existing local dev services when worker/code requires it; verify through proxy. No external release generation merely to test. Risks: category/topic leakage, nested bullet context loss, arbitrary cap omission, editable/output compatibility, provider schema drift. Mocked multi-MR pipeline coverage tests plus render/publication tests are decisive evidence.

Next: implement consumer and producer changes concurrently; review, repair, freeze exact commits and create draft PR/MR with bounded CI observation.

## Marketplace candidate checkpoint

Scoped change: provider-delivery.md only plus this plan. Optional H4 topic examples/guidance; flat atomic facts; legacy direct bullets; explicit consumer-first rollout. No version bump or release. Owner simplicity review and independent Sol review found no material issues. Both Claude plugin validation commands, all four manifest JSON parses/version equality, link checks and diff check passed. Freeze at the resulting scoped commit; final gate: plugin validation on that candidate. Deployment consumer remains a separate MR. Retrospective: isolated worktree preserved unrelated original changes and one canonical reference avoided duplicated instructions. Delivery observation budget: one immediate check and at most two minutes if checks exist; pending checks do not block draft delivery.
