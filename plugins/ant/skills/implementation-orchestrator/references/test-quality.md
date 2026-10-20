# Test quality policy

This reference is the shared policy for [test-design](../../test-design/SKILL.md), [test-maintenance](../../test-maintenance/SKILL.md), and implementation-orchestrator. Repository instructions and the actual code define commands, framework conventions, and project-specific contracts.

## Decide whether to add a test

- Add automated coverage when a meaningful regression or boundary needs a repeatable oracle and the test protects behavior beyond checks already present.
- First inspect existing coverage and the changed behavior. Do not add a test solely to mirror implementation, satisfy a quota, or make every code change produce a test.
- Prefer the narrowest layer that can observe the contract with a reliable signal. Include fixture, database, browser, and external-process costs when comparing layers, and do not mock away the behavior or boundary the test must protect. Use higher-level coverage when lower layers cannot establish the user-visible or cross-component behavior at risk.
- State the trigger, expected result, and failure the test would catch. If no distinct regression risk or reliable oracle exists, explain why another test adds no value.

Coverage is not valuable by default. Cosmetic CSS or copy snapshots, static catalog dumps, trivial getters or helpers, and tests whose mock repeats the expected implementation are candidates for removal when they establish no meaningful contract. Keep product behavior, accessibility, authorization, persistence, event ordering, or other boundaries that would catch a real regression.

## Optimize test cost

Test cleanup and performance are separate goals. Remove tests that provide no meaningful protection even when suite speed is unchanged. For a performance change, locate the cost in the test body, compilation, setup, SQL, external processes, or shutdown, then choose a credible opportunity whose likely benefit justifies its implementation and maintenance risk.

Use existing CI evidence or a small matched sample when measurement is useful; do not build a benchmark harness for routine decisions. Define the metric and scope (for example, test time, job wall time, process RSS, or container/database memory), and report them separately. Treat small, negative, or inconclusive samples as such; reassess the optimization instead of claiming a gain. Do not infer suite-wide savings from a few fixtures.

## Design reliable coverage

- Cover representative behavior and the relevant boundaries, including meaningful empty, failure, authorization, and concurrency cases where the change affects them.
- Reuse passive fixtures and setup when they provide inputs; account for callbacks, hooks, subscriptions, and other active behavior that may run during setup.
- Mock at external or nondeterministic boundaries. Keep the behavior under test real, and avoid mocks that duplicate the implementation or bypass the contract being claimed.
- Make expected outcomes independent of the implementation under test. Reusing a production constant can verify assembly or wiring, but it does not establish correctness when that same constant defines the expected value.
- Synchronize on observable state or completion signals. Do not replace a missing oracle with sleeps, arbitrary timeouts, or retries that can hide races.
- Keep each test's distinct protection clear. A test that passes without exercising the changed path is not evidence for it.

## Maintain existing coverage

- Treat cleanup, repair, or optimization as in scope only when requested or needed to complete the agreed work; do not begin a broad audit during unrelated implementation.
- Judge each test by the behavior and failure it can observe. A test with no meaningful regression protection may be deleted without replacement. When consolidating tests, establish that they cover the same contract at a suitable layer; similar outputs alone do not make authorization, payload, persistence, event-order, or integration cases duplicates. Retain layer coverage when a layer catches a distinct failure.
- Before deleting or simplifying tests, inspect the whole file and trace setup, fixtures, hooks, subscriptions, callbacks, and their ordering. Separate reusable passive setup from distinct behavior, and preserve active setup effects, implicit assertions, and synchronization guarantees when they matter. Do not preserve incidental DOM queries that establish no behavioral contract or needed synchronization.
- Search the approved scope for the same wasteful or redundant pattern and handle coherent instances together. Inspect enough surrounding code to establish that each instance has the same cause and contract; do not stop at the first examples or impose a file-count quota.
- Preserve the original regression intent and observable synchronization. Change expectations only when the underlying contract is verified to have changed; do not hide failures with skips, broader tolerances, reduced assertions, or longer timeouts.
- Preserve the tested inputs, their order, active setup effects, per-case oracles, and the actual error path. A smaller parameter set is a test-count change, not evidence of lower runtime. Do not replace distinct expected outcomes with one shared assertion that only confirms implementation wiring.
- After cuts, remove orphaned imports and helpers across the affected file and run the relevant lint, type, and formatting checks when available.
- For a requested broad audit, inventory executable test areas and provider/tooling boundaries, and classify bootstrap or setup checks separately from regression tests. State the inspected scope and evidence for completeness; do not infer full coverage from a sample or impose a test-count target.
- Classify failures using baseline, environment, and change evidence before calling them regressions.
- Run the smallest meaningful checks during repair and the repository's required affected gates before handoff. Use project-defined commands; record unavailable checks and unresolved failures accurately.
