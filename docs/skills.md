# Skills

The plugin exposes exactly three public entry points. Choose the one that owns the requested outcome.

## `implementation-orchestrator`

Use for features, fixes, refactors, migrations, remediation, and new applications that need a reviewed and verified implementation. It establishes a root-owned durable plan, applies the host's Goal and route rules, delegates one integration owner, obtains independent review, runs proportional checks, and verifies one final candidate gate. Analysis-only work remains read-only. Read the [orchestrator guide](orchestrator.md) for the lifecycle and host adapters.

## `merge-request`

Use for PR/MR Preview, Create/update, Observe/status, exact-head checks, and local or remote conflict resolution. Preview and Observe/status are read-only. Create/update, conflict preparation, staging, commit, push, readiness change, and merge each retain their own authority. See the [merge-request skill](../plugins/ant/skills/merge-request/SKILL.md) for mode routing.

## `brand-design`

Use for `(ant)` design direction, asset selection, or brand-fit review across websites, apps, UI, documents, decks, and visuals. The source manual and manifest are under `plugins/ant/skills/brand-design/assets/source/`. Implemented product work still follows the normal orchestrated repository workflow.
