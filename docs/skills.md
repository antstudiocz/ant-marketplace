# Skills

The plugin exposes five public entry points. Choose the one that owns the requested outcome.

## `implementation-orchestrator`

Use for features, fixes, refactors, migrations, remediation, and new applications that need a reviewed and verified implementation. It establishes a root-owned durable plan, tracks required outcome scenarios, preflights the relevant checkout and target, selects proportional evidence, and preserves user delivery preferences through recovery. It delegates one integration owner, obtains independent whole-outcome review, repairs in-scope findings, and verifies one risk-appropriate candidate gate. Missing or stale required evidence remains pending. Read the [orchestrator guide](orchestrator.md) for the lifecycle and host adapters.

When automated coverage is proposed, changed, or reviewed, the orchestrator routes through [test-design](../plugins/ant/skills/test-design/SKILL.md) and the shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md). [test-maintenance](../plugins/ant/skills/test-maintenance/SKILL.md) applies only to requested or in-scope cleanup, repair, or optimization.

## `test-design`

Use to decide whether automated coverage adds distinct protection and design or review meaningful scenarios, oracles, test layers, mocks, and synchronization for a specific change. A test is not required for every change; the shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md) is canonical.

## `test-maintenance`

Use for requested cleanup, repair, or optimization of existing tests, or when required by the agreed implementation. It does not trigger broad cleanup during unrelated implementation. The shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md) allows deleting tests with no meaningful protection without replacement and defines how to preserve distinct contracts during consolidation.

## `merge-request`

Use for PR/MR Preview, Create/update, Observe/status, exact-head checks, and local or remote conflict resolution. Preview and Observe/status are read-only. An explicit Create/update request authorizes the safely scoped commit, push, provider create/update, and matching observation for the already agreed repository scope and targets resolved from the instructions, repository/provider context, or safe defaults. Conflict preparation, readiness change, merge, release, deployment, and history rewrite retain separate authority. The shared lifecycle owns implementation-only, draft, and explicit merge-ready completion; provider descriptions, parser-ready release notes, and finite exact-head observation are defined in the [provider-delivery reference](../plugins/ant/skills/merge-request/references/provider-delivery.md). See the [merge-request skill](../plugins/ant/skills/merge-request/SKILL.md) for mode routing.

## `brand-design`

Use for `(ant)` design direction, asset selection, or brand-fit review across websites, apps, UI, documents, decks, and visuals. The source manual and manifest are under `plugins/ant/skills/brand-design/assets/source/`. Implemented product work still follows the normal orchestrated repository workflow.
