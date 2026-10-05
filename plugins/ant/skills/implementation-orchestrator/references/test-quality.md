# Test quality policy

This reference is the shared policy for [test-design](../../test-design/SKILL.md), [test-maintenance](../../test-maintenance/SKILL.md), and implementation-orchestrator. Repository instructions and the actual code define commands, framework conventions, and project-specific contracts.

## Decide whether to add a test

- Add automated coverage when a meaningful regression or boundary needs a repeatable oracle and the test protects behavior beyond checks already present.
- First inspect existing coverage and the changed behavior. Do not add a test solely to mirror implementation, satisfy a quota, or make every code change produce a test.
- Prefer the narrowest layer that can observe the contract with a reliable signal. Use higher-level coverage when lower layers cannot establish the user-visible or cross-component behavior at risk.
- State the trigger, expected result, and failure the test would catch. If no distinct regression risk or reliable oracle exists, explain why another test adds no value.

## Design reliable coverage

- Cover representative behavior and the relevant boundaries, including meaningful empty, failure, authorization, and concurrency cases where the change affects them.
- Reuse passive fixtures and setup when they provide inputs; account for callbacks, hooks, subscriptions, and other active behavior that may run during setup.
- Mock at external or nondeterministic boundaries. Keep the behavior under test real, and avoid mocks that duplicate the implementation or bypass the contract being claimed.
- Synchronize on observable state or completion signals. Do not replace a missing oracle with sleeps, arbitrary timeouts, or retries that can hide races.
- Keep each test's distinct protection clear. A test that passes without exercising the changed path is not evidence for it.

## Maintain existing coverage

- Treat cleanup, repair, or optimization as in scope only when requested or needed to complete the agreed work; do not begin a broad audit during unrelated implementation.
- Separate duplicated setup from duplicated behavior. Consolidate setup when shared ownership remains clear; preserve distinct scenarios and their assertions when they protect different contracts.
- Before removing coverage or simplifying an assertion, identify its unique regression protection and verify that retained coverage still exercises the same contract at an appropriate layer. Preserve layer parity when that layer catches distinct integration failures.
- Preserve the original regression intent, hook/callback ordering, and synchronization guarantees. Change expectations only when the underlying contract is verified to have changed; do not hide failures with skips, broader tolerances, reduced assertions, or longer timeouts.
- Classify failures using baseline, environment, and change evidence before calling them regressions. Profile a reproducible cost to locate its source; compare bounded, comparable runs and report measurements without extrapolating unsupported speed claims.
- Run the smallest meaningful checks during repair and the repository's required affected gates before handoff. Use project-defined commands; record unavailable checks and unresolved failures accurately.
