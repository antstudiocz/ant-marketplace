# Skills

The plugin exposes five public entry points. Choose the one that owns the requested outcome.

## `implementation-orchestrator`

Use for features, fixes, refactors, migrations, remediation, and new applications that need a reviewed and verified implementation. It establishes a root-owned durable plan, derives the original goal and completion criteria, selects proportional outcome evidence from the changed surface and risk, applies the host's route rules and any applicable Goal rules, delegates one integration owner, obtains independent whole-outcome review, repairs in-scope findings, runs proportional checks, and verifies one final candidate gate. For target-project code, it also applies the canonical [simplicity and architecture review](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#simplicity-and-architecture) before freeze. On Codex, missing or unavailable optional Goal support never blocks otherwise-authorized work under the durable plan; an explicitly requested Goal remains pending until established and verified. Analysis-only work remains read-only while investigating accessible unknowns. Ordinary findings, capability failures, safety denials, and explicitly permitted recovery notices follow the shared [blocker adjudication policy](../plugins/ant/skills/implementation-orchestrator/references/lifecycle.md#blocker-adjudication-and-scope). Read the [orchestrator guide](orchestrator.md) for the lifecycle and host adapters.

When automated coverage is proposed, changed, or reviewed, the orchestrator routes through [test-design](../plugins/ant/skills/test-design/SKILL.md) and the shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md). [test-maintenance](../plugins/ant/skills/test-maintenance/SKILL.md) applies only to requested or in-scope cleanup, repair, or optimization.

## `test-design`

Use to decide whether automated coverage is needed and design or review meaningful scenarios, oracles, test layers, mocks, and synchronization for a specific change. Existing coverage and repository conventions come first. The shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md) is canonical.

## `test-maintenance`

Use for requested cleanup, repair, or optimization of existing tests, or when required by the agreed implementation. It does not trigger broad cleanup during unrelated implementation. Follow the shared [test-quality policy](../plugins/ant/skills/implementation-orchestrator/references/test-quality.md) when preserving distinct regression protection and classifying failures.

## `merge-request`

Use for PR/MR Preview, Create/update, Observe/status, exact-head checks, and local or remote conflict resolution. Preview and Observe/status are read-only. An explicit Create/update request authorizes the safely scoped commit, push, provider create/update, and matching observation for the already agreed repository scope and targets resolved from the instructions, repository/provider context, or safe defaults. Conflict preparation, readiness change, merge, release, deployment, and history rewrite retain separate authority. The shared lifecycle owns implementation-only, draft, and explicit merge-ready completion; provider descriptions, parser-ready release notes, and finite exact-head observation are defined in the [provider-delivery reference](../plugins/ant/skills/merge-request/references/provider-delivery.md). See the [merge-request skill](../plugins/ant/skills/merge-request/SKILL.md) for mode routing.

## `brand-design`

Use for `(ant)` design direction, asset selection, or brand-fit review across websites, apps, UI, documents, decks, and visuals. The source manual and manifest are under `plugins/ant/skills/brand-design/assets/source/`. Implemented product work still follows the normal orchestrated repository workflow.
