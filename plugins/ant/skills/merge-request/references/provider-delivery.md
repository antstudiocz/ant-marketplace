# Provider delivery and observation

Read only the sections relevant to the requested mode. The [skill entrypoint](../SKILL.md) owns mode and authority boundaries.

## Description

Use Conventional Commit titles and concise English by default, subject to the resolved repository/user language. Build the description from the complete final target merge-base-to-`HEAD` diff and refresh it, including its evidence, when that snapshot changes. Never add AI attribution or co-author trailers.

The body has two layers, identical whichever host or model writes it: short visible bullets and a captioned [screenshot section](#screenshots) before the release notes, followed by concise technical details. Use a pre-release-note `<details>` wrapper for screenshots only when downstream consumer compatibility supports it; technical details after release notes may remain collapsed.

Treat the entire body, including collapsed details, as a stable description of the change. Describe durable behavior, rationale, material user/data/security/platform effects, required operator actions, and concrete functional limitations that affect a decision. Keep transient CI or gate results, job counts, per-check source/test revision accounting, Draft/Ready/merged state, merge or deployment history, and generic current-production-state disclaimers in the provider UI and separate delivery or readiness report. This does not change the evidence required to assess readiness; a specific unresolved product behavior or functional verification limit remains a description concern.

Every PR/MR body has visible level-2 `Summary`, `Rationale`, `Impact/risk`, and `Verification screenshots` sections in that order, followed by the exact `## Release notes` section. Surround the complete release-notes block with standalone Markdown `---` rules, with blank lines around each rule: place one after the screenshot section, before `## Release notes`, and one after its final release-note line, before any following details block. Localized headings are fine for the visible human-facing sections, but the release-note headings below remain exact English for deterministic extraction. New authoring uses the canonical headings `Added`, `Changed`, `Fixed`, and `Internal changes`. Consumers should add canonical-heading support before a producer switches its default, while continuing to read the legacy aliases `New features`, `Improvements`, and `Fixes` for existing content during rollout. Add consumer support for H4 topic headings before using them in release notes; until then, keep bullets directly under their category heading. Consumers must continue to accept those ungrouped category bullets.

In `Summary`, `Rationale`, and `Impact/risk`, use flat unordered bullets only: no nesting or umbrella items. Prefer concise plain-language bullets; 20–25 words is a soft upper target, not a quota. Shorter is fine, and material facts take priority. Lead with the reader outcome or key reason; group facts when they share a practical consequence, and avoid semicolon chains. Aim for one to three `Summary` and `Rationale` bullets. Keep `Impact/risk` brief—typically three to five bullets, with no hard cap—by grouping related risks, required actions, and concrete functional evidence gaps around their practical consequence. Prioritize what changed, what decision or action follows, and any material limitation, especially destructive data effects or recovery limits; do not create separate bullets for each diagnostic or qualifier. The visible layer is a selective decision brief; keep the full functional verification method and operator trace in technical details. Move exact variables, counts, commands, identifiers, paths, and full operator steps and completion conditions to technical details unless their precision changes the decision. Visible actions still name the responsible owner or dependency and the next step. Example: `The form saves your draft automatically.`

- **Summary:** what changed and the practical behavior or benefit.
- **Rationale:** why the change is needed and the key decisions or tradeoffs.
- **Impact/risk:** practical user and technical impact, compatibility or rollout risk, safeguards, required deployment actions, and material verification gaps that affect a decision.

Visibility rules for these bullets:

- Keep material scope expansions and security, platform, or operational constraints visible in plain language; put exact requirements and diagnostics in details unless their precision affects the decision. State causes and outcomes only as strongly as the sources support. Report missing records as undocumented and unavailable operations as unavailable; neither proves refusal, an unperformed check, or unsupported provider capability.
- Call work a scope expansion only when it exceeds the agreed scope, and call it approved only with evidence of that approval; a new dependency is neither by default.
- Keep material product behavior limits, human decisions, required deployment actions, and functional verification gaps visible in `Impact/risk`, grouped by consequence where they relate. State what remains uncertain and the action or dependency it creates; put supporting method and detail in technical details as appropriate.
- Before drafting, resolve the current provider/source snapshot from authoritative metadata and compare it with the prior description and available functional evidence. Make a brief private coverage note of material behavior changes, concrete operations and affected or derived data, required actions, recovery limits, and functional checks and their scope; assess check applicability for the separate delivery/readiness report.
- For data-changing work, name the operation and the specific data it affects, including original versus copied data when that distinction changes the outcome; state the practical consequence or recovery limit when material. Vague labels such as “cleanup” must not obscure whether data is replaced or removed.
- Draft `Impact/risk` from the evidence, then `Summary` and `Rationale`. Preserve qualifiers needed for a truthful decision, state each once in concise plain language, and keep functional and operator trace in details. Preserve the rendered section order above. Before returning, verify all three human sections contain only standalone `- ` bullets—no bare prose, nesting, or numbered items.
- Include one standalone flat bullet in `Impact/risk` beginning with the localized equivalent of `Post-deployment actions:`. Name the required operator action or dependency; say none are required only when the final diff and relevant deployment procedure support that conclusion. If requirements are unknown, state the concrete check needed. Put full steps and completion or verification conditions in collapsed details or a linked runbook. Describing actions grants no authority to perform them; see the [skill’s authority boundaries](../SKILL.md#authority-and-completion).

### Whole-description review

As part of the lifecycle's existing [independent whole-outcome review](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate), perform a proportionate description-fidelity review of the complete final body, including screenshot captions and technical details. Check available authoritative source and provider evidence, material effects and data targets, required operator steps and completion or verification conditions, functional evidence and its scope, and consistency across the body. Report review state and unverified coverage in the separate delivery/readiness report, not the body. Explicitly identify unavailable source or functional evidence there. A stored description or metadata alone does not establish review of code, remote state, or production; missing source evidence does not create authority or a requirement to fetch it. Keep transient provider state and exact CI/source-to-test attribution in the separate report. The author repairs findings and refreshes affected evidence, then obtains affected re-review under the lifecycle. If review is unavailable, report that coverage as unverified. This review grants no provider-write authority.

### Release notes section

Write release notes from the final target merge-base-to-`HEAD` snapshot. Refresh them when the scope changes; do not append an implementation diary or preserve notes for removed work. The section has this shape:

```markdown
---

## Release notes

### Added
#### Deployment history
- Adds a timeline that shows deployment status and completion time.
- Adds filters for deployment environment and outcome.

### Changed
#### Deployment history
- Preserves the selected filters when a user opens a deployment and returns to the timeline.

### Fixed
#### Activity feed
- Shows events that were missing after the page refreshed.

### Internal changes
- Moves deployment-event cleanup into a scheduled worker.

---
```

Use only the category headings that have entries. Within a category, use an H4 topic heading to group related notes when it makes them easier to scan; otherwise, put bullets directly under the category. Keep bullets flat and atomic, with each one understandable on its own and retaining any required user action, limitation, availability, or off-by-default flag. Give each topic a concise, meaningful feature or area name and use the same label for that area across categories. Repeat a topic under another category only for distinct changes in that area; do not repeat facts across categories or group unrelated changes together. Do not add empty topics or deeper heading or bullet levels. Classify a new capability as `Added`, a deliberate change to existing behavior, design, or performance as `Changed`, and a documented deviation from expected behavior as `Fixed`. Visual regressions, timeout handling, and similar repairs belong in `Fixed` when they correct expected behavior; do not frame them as improvements. For new notes, classify from the final diff's intent and expected-behavior evidence. When synthesizing existing notes, preserve an explicit source category; require manual review only when the evidence conflicts or remains genuinely ambiguous. Keep entry prose in the selected description language while preserving the exact English headings. `Internal changes` is separate from public delivery and is excluded by public consumers. When the final snapshot has no release impact, use exactly `No release impact.` under `## Release notes`, still surrounded by the same blank-line-separated `---` rules, and omit all category headings. Never infer no impact from a missing, malformed, or ambiguous section; require manual review instead.

Do not put JSON, a custom schema, duplicated machine payload, a level-2 heading, or a details block inside the release-note content. The consumer locates the exact `## Release notes` heading first and ends the section at the next level-2 heading or HTML `<details>` block after it, so place implementation context and detailed verification after the release notes in collapsed blocks such as:

```html
<details>
<summary>Implementation details</summary>

...enduring mechanisms, contracts, tradeoffs, and links...
</details>

<details>
<summary>Functional verification</summary>

...functional method and scope, scenarios, expected and actual behavior, material limits...
</details>
```

The `...` lines are placeholders: replace them with actual content or omit the block. Keep broad gate inventories and pass/fail digests in the separate delivery/readiness report.

### Technical details

- Include enduring mechanisms and contracts, nontrivial tradeoffs, required operator steps with their completion or verification conditions, and useful verifiable links such as issues, documentation, or pipelines.
- Omit a repeated summary, exhaustive path, SHA, or log lists, a chronology of attempts, and host- or model-specific templates. Keep only identifiers essential for traceability.

### Verification evidence

- Briefly describe the functional verification method and scope, reproducible scenarios or steps, expected versus actual behavior, and material limits. Choose scenarios by the change's risk rather than a fixed test scope, and write no technical diary. Assess CI/gate state and exact revision mapping separately.
- Label each item's kind: real application, backend, or runtime; provider mock or stub; fixture or prototype; API output; or automated test or report. A screenshot of a report or rendered API output does not prove the actual application, and neither CI nor screenshots replace the functional checks the change needs.
- Assess check applicability against the provider's current source snapshot using authoritative metadata for the separate delivery/readiness report; a “current” or “final” label in prior prose is not evidence. Keep exact tested revisions and per-check source mapping there, not in the MR description.
- For documentation, backend, or other changes without meaningful UI, say so briefly and give fitting functional evidence, such as command output that exercises behavior, API responses, or links to rendered documents. Report test and gate inventories separately.

### Screenshots

Before using a `<details>` group before `## Release notes`, verify that each downstream consumer finds that exact heading before applying its terminators. If compatibility is unverified or a consumer stops at the first `<details>`, put the same flat caption-and-image list directly under the screenshot heading without `<details>`; use the closed group only after compatibility is verified. This is a compatibility guard, not a claim that consumers have been checked. Each capture remains one list item: its caption, a blank line, then its indented image:

```markdown
## Verification screenshots

<details>
<summary>Capture kind and scenario applicability</summary>

- Short result visible in the first capture

  ![Short description](durable-attachment-url)

- Short result visible in the next capture

  ![Short description](durable-attachment-url)

</details>
```

The summary, captions, and URLs are placeholders.

For an unverified or legacy consumer that may stop at the first `<details>`, omit the wrapper and keep the same list directly under the heading:

```markdown
## Verification screenshots

- Short result visible in the capture

  ![Short description](durable-attachment-url)
```


- When reformatting existing screenshot evidence without new captures, preserve each media target and its sequence. Change the order only when new evidence or the user's request justifies it, and keep each caption attached to its capture.
- For UI or user-flow changes, embed relevant captures of the actual tested application in the PR/MR through the provider's supported durable attachment mechanism. Never use local filesystem paths, ephemeral or inaccessible URLs, or fabricated, generated, or decorative images.
- Caption each capture with one brief plain-language result phrase. Say what was done or seen and the result; omit boilerplate such as "demonstrates" or "verifies," and obvious control descriptions. Mention desktop or mobile only when the layout matters.
- State the capture kind, scenario or candidate applicability, and shared limits once in plain language in the summary or one concise line before the list, as required under [Verification evidence](#verification-evidence). Put revision identifiers in the separate delivery/readiness report, and add only a capture-specific limit as a brief clause on its bullet.
- Prefer synthetic test data. Before upload, redact secrets, credentials, and private, personal, or customer data, then inspect the actual redacted file being uploaded.
- Upload only within an authorized Create/update. Preview stays read-only and lists pending captures and uploads instead.
- Evidence collection grants no extra authority for external or provider test writes, production access, or deployment.
- Without meaningful UI, or when a browser, capture, or durable upload is unavailable or unauthorized, write one brief bullet under the heading instead of the group, giving the honest reason and the useful evidence that exists, and add no substitute imagery or empty disclosure. Include an unavailable capture in `Impact/risk` only when it changes the review or rollout decision, grouped with its related consequence.

## Create/update

Stage only scoped paths/hunks. If mixed or pre-staged work cannot be safely isolated, pause the affected write. Validate the candidate or reuse fresh candidate-bound evidence under the [lifecycle](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate).

Use structured arguments or a temporary UTF-8 file for multiline bodies so shell interpolation cannot alter their content. Keep temporary files outside the worktree. Metadata-only updates need no source commit or push.

## Exact-head observation

Report these observations separately from the PR/MR description, in the delivery/readiness report.

- Set one finite registration-and-observation budget per attempt. Source or target changes consume the remaining budget; re-read provider state and refresh affected evidence rather than resetting the timer.
- Record provider source SHA and actual tested SHA separately, with authoritative mapping between them. GitHub exposes the PR `headRefOid` and check commit, possibly a test-merge commit; GitLab may test the MR head or a merged result. A pipeline's name, branch or success alone does not establish that mapping.
- Missing mapping or required test-merge evidence, absent/pending checks, and skipped, neutral, timed-out or mismatched results are unverified. Claims that no checks are required, or that CI replaces a local gate, must meet the [lifecycle's candidate criteria](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate).
- Report source/tested SHA, target, pipeline/check identity, status and useful failure diagnostics. Classify failures as current-diff, infrastructure, credentials or external state; observation itself never retries or repairs.
- Observe/status failures are report-only and need a separate fix request. During Create/update, hand an in-scope regression to the orchestrator only under existing implementation/repair authority; otherwise leave repair pending. Its lifecycle owns repair, review and escalation. Retry permission and scope expansion remain separate decisions.
- When the finite observation budget expires before a terminal provider result, end that observation attempt and keep the broader endpoint pending. Return a snapshot to the owning root with provider source SHA, tested SHA and mapping, target, each required check state, remaining work, and observed blocker.
- The root reconciles remaining work and selects any continuation permitted by the host, without resetting the exhausted provider-observation budget. It may continue independent authorized work or receive a result through an already-permitted native continuation when host rules allow it. Expiry itself does not authorize a new polling window, Goal, or automation. If no continuation is permitted, report which host mechanism or rule prevents it; budget expiry alone is not a capability failure.
- Classify terminal failed or otherwise non-passing required gates; they leave an explicitly merge-ready endpoint pending, or blocked only under the lifecycle criteria. Repair only under existing authority in Create/update. Read-only Observe/status reports terminal failures without repair or retry; if that result informs a broader endpoint requiring a passing gate, keep that endpoint pending. An explicitly requested draft-create/update endpoint may finish when the requested draft exists and its source-head state and material gaps are reported truthfully; green checks are not required for that draft-only endpoint.

## Release publication

For an authorized release, link the relevant merged PRs/MRs included in the released commit. Verify both merged state and inclusion. When several contributed, also link a comparison of the verified previous and current release tags. With no previous release, omit that comparison. Keep the notes concise; links provide the detail.
