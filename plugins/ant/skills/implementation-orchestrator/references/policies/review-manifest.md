# Review Manifest

This file is the normative owner for the evidence bundle required before plan, task, implementation, and delivery review.

## Required Fields

Provide one manifest with:

- review kind and scope;
- original goal, approved non-goals, acceptance scenarios, and risk scenarios;
- run id, current cycle/phase, risk tier, and preferred language;
- runtime capability artifact and relevant route decisions with requested, actual/unknown, fallbacks, and evidence source;
- confirmed target branch, base/head or exact diff range, changed paths, dirty-state constraints, and unrelated-change decision;
- approved plan and relevant phase/task briefs;
- run startup contract plus authoritative approval ids, digests, and artifact refs;
- implementation/task reports and material rationale checkpoints;
- evidence records from `evidence-policy.md`;
- current findings and their disposition;
- known blocked checks and residual risks;
- required artifacts with path, availability, freshness, digest/range when relevant, and owner.

For medium+ persisted runs, include or explicitly mark unavailable: `state.json`, `events.jsonl`, run index/state/decisions/rationale/handoff, current phase files, approved plan, relevant findings/options, verification, and worker reports. Task review additionally requires task brief, worker report, focused diff/range, and task evidence.

## Missing Context

Do not review from a diff alone. For every missing or stale item, record `available: false` or its freshness limitation.

- Return `Cannot verify` when missing context prevents a verdict.
- Raise P1 when scope, authorization, data/permission safety, delivery, or acceptance cannot be verified.
- Raise P2 when review can proceed but material rationale or evidence is weakened.
- Treat intentionally omitted low-risk markdown as residual risk only when structured state and task evidence remain sufficient.

## Verdicts

Plan/integrated review returns `Approved`, `Needs fixes`, or `Cannot verify`.

Task review returns both:

```text
Spec compliance: Approved | Needs fixes | Cannot verify
Engineering quality: Approved | Needs fixes | Cannot verify
```

P0/P1/P2 findings block completion until fixed, verified, and re-reviewed, or accepted through a finding-specific authoritative approval. The review handoff template is only a shape; this file owns manifest requirements.
