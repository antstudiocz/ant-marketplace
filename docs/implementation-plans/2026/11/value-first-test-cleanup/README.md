# Value-first test cleanup guidance

## Scope and endpoint

Initial scope was a reviewed draft PR for the proposed test-skill updates. User later authorized completing prepared PR105 merge in MAIN (verified turn01a1a6a8-a7aa-7300-a1cb-797db3e90b95) and directly added “nezapomeň vydat v githubu release pro ten marketplace” in this chat. Current endpoint: reviewed version13.9.3 in PR105, normal merge to master after actual required checks/review, then published GitHub release v13.9.3 bound to the merged master commit and verified source-branch/own-checkout cleanup. Keep chat open. No app test cleanup, new runtime/tooling, production deploy or branch-protection bypass. Work from master80f885b881697da2ef4fbbebdf915b0c8b702377 in isolated `/private/tmp/ant-marketplace-test-policy-20261104`; do not touch the unrelated dirty Sites checkout.

## Acceptance and scenarios

- Authorized cleanup can redesign a whole test suite around meaningful behavior and remove valueless or redundant scenarios without one-for-one replacements.
- Mechanical cost optimization preserves distinct inputs/oracles/synchronization; explicit cleanup may remove or consolidate scenarios after explaining actual protection lost or retained. Do not weaken a real boundary to obtain green CI.
- Minimal examples distinguish cosmetic/implementation-mirroring checks from useful behavior, accessibility, persistence, authorization and failure contracts.
- Targeted fault sensitivity checks are optional and proportional for important rewritten coverage; no blanket mutation-testing gate or new harness.
- Green CI and correct measured profile data do not establish performance gains. Negative/inconclusive time/RAM evidence triggers reassessment with honest claims, not automatic rollback from one noisy sample.
- Both public test skills and the implementation orchestrator keep one shared policy owner; no duplicated checklists or new approvals.

## Ownership and cadence

Root owns only this plan and delivery. Fresh integration owner gpt-6-luna High owns the shared test-quality policy and a concise docs/skills summary update if needed. Independent opposite-provider Claude Opus High review is read-only. No nested delegation. One coherent instruction delta, proportional static/plugin checks, manual decision scenarios and final independent review; no browser, live app, or benchmark needed.

## Evidence, risks and status

Current master already permits deleting tests and separates critical-path latency from summed job time. Main risk: blanket preservation rules contradict intentional cleanup, or new wording allows deleting distinct business/security contracts. Validate this boundary, example exceptions, scope and links. Repo commands: both `claude plugin validate` commands and the documented JSON parsing gate. Skill frontmatter validation only for changed entrypoints. No automated prose-matching tests.

Phase: plan established; owner implementation next. No native Goal requested for this new task; preserve the unrelated prior Goal. Final source/model provenance, reviews, checks, disposition and provider PR snapshot will be recorded before freeze/delivery. Static checks and scenario review do not prove future agents' runtime adherence or actual pipeline/RAM savings.

## Review and validation checkpoint

Integration owner: fresh OpenAI gpt-6-luna High. Initial source review: fresh Anthropic Claude Opus5.5 High via signed-in first-party CLI, restricted Read/Grep/Glob, no MCP or file writes, no permission denials. Root confirmed F1 circular preservation/mode selection, F2 missing prohibition on dropping still-valid assertions to hide failures, F3 temporary fault cleanup/failed-oracle handling; owner repairs these in existing bullets. F4 overlapping mode bullets is a confirmed minor simplification included in repair. F5 potential loss of other meaningful contracts remains an unproven ambiguity: existing distinct-contract rules and the consequential-boundary requirement cover it; no blanket rule to retain all historical scenarios is intended.

Both plugin validators, four declared JSON manifests, 17 related relative links and diff whitespace pass. The existing nonfatal ICON_MISSING directory warning is unrelated and remains visible in PR verification. Manifest/version bytes are unchanged from master. No app, browser, runtime benchmark or prose-matching test applies. Existing unrelated working trees and native Goals remain untouched. Root requested one wording correction so passing CI is not described as proof of general correctness.

Next: inspect repaired source, obtain affected independent review, freeze final plan and exact candidate, commit/push the scoped branch and create one draft PR. No merge or release authority is inferred.

## Final candidate checkpoint

Repaired policy blob `70c9e2722bc475006edb4a2c6771091d3e5fb7bb`; skills-guide blob `e65fff6818e3278c354b2984b1c5809f8bcbc62f`. Fresh affected Anthropic Claude Opus5.5 High first-party re-review completed successfully with Read/Grep/Glob only, no MCP or permission denials. F1/F2/F3 resolved; F4 structural ordering/duplication repaired, remaining repeated distinct-contract reminder is nonblocking; F5 ambiguity resolved by replacement retaining distinct meaningful contracts. Root accepts the repair. Five manual decision scenarios cover the required authority/cleanup, mechanical optimization, fault sensitivity, cosmetic-vs-behavior and performance-claim boundaries. No new material finding or unjustified new complexity remains.

Affected link/whitespace checks pass; plugin/JSON gates remain valid because their manifests and routing structure are unchanged. Versions and release metadata unchanged. Root freezes this narrow reviewed policy/docs plus this plan; next delivery operations are scoped commit, normal push, one draft PR and exact-head provider readback. The requested draft-only endpoint does not imply merge readiness, merge or release. Provider URL/head/check snapshot belongs in the final delivery handoff; no empirical agent compliance or time/RAM benefit is claimed. Retrospective: a focused correction to existing shared rules was sufficient; do not add a new skill, framework, mandatory mutation gate, or prose-matching tests.


## Authorized release follow-up

Fresh GitHub readback: latest actual release v13.9.2 targets80f885b, current three metadata versions13.9.2. Select patch13.9.3 because this clarifies existing test guidance without a public workflow/API break. Scope: three synchronized version fields, new docs/releases/13.9.3.md and README release link; prior policy/docs blobs remain unchanged. History release notes are immutable. Same PR105, no new PR; new version source needs affected plugin/JSON/link checks, independent opposite-provider delta review and source-bound provider checks.

Current PR105 Ready has reviews=[] and REVIEW_REQUIRED: one code-owner approval is mandatory, author LeMatosDeFuk cannot approve their own PR, auto-merge disabled. Do not bypass protection/admin merge or contact other reviewers. MAIN owns communicating the concrete last human step; proceed with all independent release preparation first. Release remains pending until PR105 is actually merged and version/tag/commit inclusion verified. Publish only requested GitHub release, no installation/update of local cached plugins or production actions.

Release preparation ACCEPT: same fresh OpenAI/LunaHigh owner changed only3versionfields, README release link and new13.9.3 note. Root verified all other JSON fields unchanged, versions exactly13.9.3, prior policy/docs hashes unchanged, relative links and whitespace valid. Both plugin validators and4JSON gate PASS (same nonfatal icon warning). Fresh Anthropic claude-opus-5-5 High firstParty affected release review ACCEPT, no permissiondenials or material finding; note's restatement of measured-evidence guidance is true, optional wording polish deferred. No new policy review/benchmark needed. Historicalreleasev13.9.2 actualtagcommit80f885b verified; currentpublication remains pending behind realPRmerge. Freeze minimal release prep and this updated rootplan, commit/pushsamePR105, refresh currenthead Vercel/provider snapshot and request no additional GO. Required codeowner gate stays enforced; no admin bypass or production deploy.
