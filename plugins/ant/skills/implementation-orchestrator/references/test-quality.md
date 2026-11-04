# Test quality policy

This reference is the shared policy for [test-design](../../test-design/SKILL.md), [test-maintenance](../../test-maintenance/SKILL.md), and implementation-orchestrator. Repository instructions and the actual code define commands, framework conventions, and project-specific contracts.

## Decide whether to add a test

- Add automated coverage when a meaningful regression or boundary needs a repeatable oracle and the test protects behavior beyond checks already present.
- First inspect existing coverage and the changed behavior. Do not add a test solely to mirror implementation, satisfy a quota, or make every code change produce a test.
- Prefer the narrowest layer that can observe the contract with a reliable signal. Include fixture, database, browser, and external-process costs when comparing layers, and do not mock away the behavior or boundary the test must protect. Use higher-level coverage when lower layers cannot establish the user-visible or cross-component behavior at risk.
- State the trigger, expected result, and failure the test would catch. If no distinct regression risk or reliable oracle exists, explain why another test adds no value.

Coverage is not valuable by default. Cosmetic CSS or copy snapshots, static catalog dumps, trivial getters or helpers, and tests whose mock repeats the expected implementation are candidates for removal when they establish no meaningful contract. Keep product behavior, accessibility, authorization, persistence, event ordering, or other boundaries that would catch a real regression.

For example, a snapshot that only pins a button's color or an assertion that a helper returns its input may add no protection. A warning shown to a user, keyboard-accessible interaction, saved value after reload, denied unauthorized request, or surfaced provider failure can be meaningful contracts even when the check also mentions copy or visual state. Judge the behavior proved, not the assertion's surface form.

## Optimize test cost

Test quality and test performance are separate goals. Remove tests that provide no meaningful protection even when suite speed is unchanged. For a performance change, locate the cost in the test body, compilation, setup, SQL, external processes, shutdown, or CI queue/dependency wait, then choose a credible opportunity whose likely benefit justifies its implementation and maintenance risk.

Use existing CI evidence or a small matched sample when measurement is useful; do not build a benchmark harness for routine decisions. Define the metric and scope (for example, test time, job wall time, process RSS, or container/database memory), and report them separately. A faster job or lower summed job time alone does not establish a shorter pipeline; use its observed critical path for latency claims. Passing CI alone does not demonstrate a performance gain. Treat small, negative, or inconclusive samples as such; reassess the cost hypothesis and optimization within the agreed scope, and make no unsupported speed or memory claim. One noisy sample is a reason to reassess, not an automatic rollback rule. Do not infer suite-wide savings from a few fixtures.

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
- Choose the maintenance mode from the agreed scope. An optimization-only change is a **mechanical optimization**: preserve every meaningful original scenario, its inputs and per-case oracle, active setup effects, ordering or synchronization guarantees, and error paths. If a meaningful scenario must change or be removed, keep it or report the conflict unless cleanup or redesign is already in scope; do not relabel an optimization to drop distinct protection. Requested or otherwise in-scope **value-first cleanup or redesign** may remove, combine, or replace scenarios, including a whole suite, when inspection shows the removed checks add no distinct meaningful protection or the replacement retains the distinct meaningful contracts. Explain the distinct protection removed, retained, or combined; similar outputs alone do not make contracts duplicates. Keep real authorization, persistence, failure, accessibility, and other consequential boundaries. In either mode, do not hide a failure by removing or weakening assertions of a still-valid meaningful contract; change expectations only when the underlying contract is verified to have changed. Do not use skips, broader tolerances, or longer timeouts to hide failures. Do not shrink scenarios and call the count change itself a performance gain.
- For a rewritten test on an important path, consider a small intentional fault-sensitivity check when practical: temporarily introduce a plausible product-behavior fault and confirm the assertion fails for that behavior, then revert the fault before the final candidate. If the test still passes, strengthen the oracle or report the gap; do not claim protection. This check is optional and proportional; syntax, fixture, or setup failure does not show that the oracle detects the product fault. Do not require a mutation framework or blanket mutation-testing gate.
- After cuts, remove orphaned imports and helpers across the affected file and run the relevant lint, type, and formatting checks when available.
- For a requested broad audit, inventory executable test areas and provider/tooling boundaries, and classify bootstrap or setup checks separately from regression tests. State the inspected scope and evidence for completeness; do not infer full coverage from a sample or impose a test-count target.
- Classify failures using baseline, environment, and change evidence before calling them regressions.
- Run the smallest meaningful checks during repair and the repository's required affected gates before handoff. Use project-defined commands; record unavailable checks and unresolved failures accurately.
