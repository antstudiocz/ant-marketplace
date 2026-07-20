# Implementation Orchestrator Evaluation Baseline

This directory defines synthetic specification fixtures for legacy `9.0.9`
behavior hypotheses and `9.2.0` regression expectations. Checked-in fixtures
are not captured host runs and never prove production behavior. The suite is
additive: it does not execute or alter production prompts, state, delivery
tools, or host agents.

## Run

```bash
bun plugins/ant/skills/implementation-orchestrator/evals/scripts/run-evals.ts
```

To adjudicate external traces that mirror the paths under `golden/`, pass both
their directory and a provenance manifest:

```bash
bun plugins/ant/skills/implementation-orchestrator/evals/scripts/run-evals.ts \
  --trace-root /absolute/path/to/traces \
  --provenance-manifest /absolute/path/to/provenance.json
```

The runner validates fixture shape and context, normalizes only declared
nondeterministic values, compares each normalized trace to an independently
stored SHA-256 manifest, and performs structural assertions. It also executes
semantic approval replay scenarios and a negative control for
requested-as-actual routing evidence. A golden file alone is never a pass
condition.

Run the command twice and compare stdout to demonstrate deterministic output.
The report intentionally has no generated timestamp. It identifies the trace
source, evidence mode, and whether provenance represents live-host capture.
Supplying `--trace-root` without provenance fails.

## Fixture contract

Each `cases/*.json` fixture contains:

- `input`: the user/request state relevant to the scenario;
- `hostCapabilities`: synthetic capability input, not a claim about a live host;
- `expected`: required question IDs, event types, action types, and forbidden
  action types;
- `classification`: one of `expected`, `known-defect`, or `must-change`;
- `golden`: a workspace-relative path to the synthetic expected trace;
- `structuralAssertions`: assertions that must pass independently of snapshot
  equality.

Synthetic traces preserve routing request and simulated actual evidence in
separate fields, with evidence sources explicitly prefixed `synthetic-`.
`normalization` may remove only values that are genuinely nondeterministic
(`traceId`, externally captured `recordedAt`, and declared attempt IDs); it must
not remove requested/actual routing, history mode, action result, approval
decision, or capability evidence.

`rubrics/golden-digests.json` is reviewed separately from the specification
traces. A trace edit without an explicit digest-manifest update fails. This
detects fixture drift; it does not prove runtime behavior. The runner also
uses each case's `input` and `hostCapabilities` to validate replay context and
host consistency; an actual routing value copied from the request without host
evidence fails the semantic negative control.

## Classification and adjudication

See [behavior classification](rubrics/behavior-classification.md) and the
[reviewer rubric](rubrics/reviewer-adjudication.md). The read-only
[normative rule inventory](rubrics/rule-inventory.md) maps duplicated current
rules to the baseline cases without changing their production ownership.

- `expected` is an invariant that must remain true.
- `known-defect` documents a legacy limitation hypothesis without promoting it
  to observed live behavior or a correct invariant.
- `must-change` is a required future behavior; synthetic specification is allowed, but
  it cannot be presented as production approval or release evidence.

Safety/approval regressions have a zero budget. Wording-only changes require a
rubric pass and reviewer adjudication. Updating a golden requires an explicit
reason, classification review, structural assertion review, and independent
reviewer approval; do not update a golden merely to make the suite green.

## Coverage

The synthetic specification covers DOD-01 through DOD-09 and DOD-13 where a
static case can test evaluator semantics: Codex native and flattened routing, Claude Code flat
named subagents and background permissions, no-history failure, low/medium/high
startup quality, metadata-only authorization denial, missing review context,
canonical MR handoff, follow-up, compaction recovery, review-fix, unavailable
browser, and declined delivery. Contract fixtures include one valid `1.0.0`
state/event pair and a clearly labelled synthetic invalid `edge.type` negative
fixture. The latter is not an observed producer defect.

Post-9.2 authorization replay covers valid scoped edit, out-of-scope push,
expiry, revoke, supersede, unverified cross-host resume, and revalidated
cross-host resume. The canonical Codex event example is also digest-checked and
semantically validates supersede/revoke target id plus digest binding.

Adaptive reasoning regression coverage includes `low`, `medium`, and `high`
complexity across Codex and Claude Code; supported-observed,
supported-unobservable, unsupported, and unknown capability states; resume
reclassification/revalidation; requested host-value plus fresh mapping
evidence; and a permission-sensitive foreground fallback that cannot mutate or
authorize the reasoning tier.

## Limits

The checked-in default is synthetic specification evidence, not a live Codex
or Claude Code smoke test. External traces require a provenance manifest;
`liveHostEvidence` is true only for `kind: live-host-capture` with capture-tool
and host-run entries. This change set has no such manifest and makes no
fresh-host claim. Host capabilities, permissions, and real routing must be
independently exercised before release.
