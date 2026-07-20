# Evidence Policy

This file is the normative owner for evidence vocabulary, records, and completion strength.

## Evidence Levels

Use exactly these levels:

1. `claim` — an agent or user statement without direct observation.
2. `observed` — direct inspection or runtime output, but not yet checked against a named acceptance scenario.
3. `verified` — a relevant check passed against a named scenario with reproducible evidence.
4. `independently-reviewed` — a reviewer assessed the relevant implementation and evidence without being its writer.
5. `accepted-residual-risk` — a specifically named evidence gap or finding was explicitly accepted through the approval policy.

Completion must not rely only on `claim`. High-risk behavior normally needs `verified` plus `independently-reviewed`. `accepted-residual-risk` does not upgrade a failed or missing check; report it separately.

## Evidence Record

Startup discovery, planning, implementation, review, and final handoff use the same compact record:

```yaml
id: <stable-id>
scenario: <acceptance-or-risk-id>
subject: <behavior-or-artifact>
level: claim | observed | verified | independently-reviewed | accepted-residual-risk
result: pass | fail | blocked | not-applicable
method: <command-review-runtime-or-inspection>
source: <host-result-command-artifact-or-reviewer>
observedAt: <UTC/Zulu>
freshness: <base/head/range/version-or-time-boundary>
artifactRefs: [<workspace-relative-ref>]
limitations: [<named-gap>]
owner: <agent-id-or-role>
```

When integrity matters, add a digest or exact git range. Never label requested routing values, planned checks, or worker summaries as observed actual evidence.

## Evidence Rules

- Map each definition-of-done and relevant risk scenario to an evidence record or named residual risk.
- Treat worker reports as `claim` until supported by checks or independent review.
- Record failures and blocked checks; do not omit them from final evidence.
- Store timestamps in UTC/Zulu. Local timezone conversion is UI-only.
- A stale check does not prove a newer diff. Name base/head, changed paths, or freshness limits.
- Browser evidence names the URL/state, viewport when relevant, interactions, expected result, and captured artifact.
- Delivery evidence records current branch, target, intended file set, review state, checks, and provider result.

The required review input bundle is owned by `review-manifest.md`. Prompt shapes live under `references/templates/` and may not redefine these rules.
