# Skills

The plugin exposes exactly three public entry points. Choose the one that owns the requested outcome.

## `implementation-orchestrator`

Use for features, fixes, refactors, migrations, remediation, and new applications that need a reviewed and verified implementation. It establishes a root-owned durable plan, derives the original goal and completion criteria, selects proportional outcome evidence from the changed surface and risk, applies the host's route rules and any applicable Goal rules, delegates one integration owner, obtains independent whole-outcome review, repairs in-scope findings, runs proportional checks, and verifies one final candidate gate. On Codex, missing or unavailable optional Goal support never blocks otherwise-authorized work under the durable plan; an explicitly requested Goal remains pending until established and verified. Analysis-only work remains read-only while investigating accessible unknowns. Read the [orchestrator guide](orchestrator.md) for the lifecycle and host adapters.

## `merge-request`

Use for PR/MR Preview, Create/update, Observe/status, exact-head checks, and local or remote conflict resolution. Preview and Observe/status are read-only. An explicit Create/update request authorizes the safely scoped commit, push, provider create/update, and matching observation for the already agreed repository scope and targets resolved from the instructions, repository/provider context, or safe defaults. Conflict preparation, readiness change, merge, release, deployment, and history rewrite retain separate authority. The shared lifecycle owns implementation-only, draft, and explicit merge-ready completion; provider descriptions and finite exact-head observation are defined in the [provider-delivery reference](../plugins/ant/skills/merge-request/references/provider-delivery.md). See the [merge-request skill](../plugins/ant/skills/merge-request/SKILL.md) for mode routing.

## `brand-design`

Use for `(ant)` design direction, asset selection, or brand-fit review across websites, apps, UI, documents, decks, and visuals. The source manual and manifest are under `plugins/ant/skills/brand-design/assets/source/`. Implemented product work still follows the normal orchestrated repository workflow.
