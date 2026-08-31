# Skills

The plugin exposes exactly three public entry points. Use the narrowest one that owns the requested outcome.

## `implementation-orchestrator`

Use for work that should finish as a reviewed and verified implementation: new applications, features, fixes, refactors, migrations, and remediation.

It:

- classifies analysis-only, implementation-authorized, or ambiguous intent;
- discovers the repository and presents a proportional native Plan before tracked edits;
- captures essential product/architecture decisions for new applications without a separate brief ceremony;
- records explicit integrated-replacement semantics when selected;
- keeps root user-facing and coordination-only while a delegated integration owner writes;
- routes by strong/balanced/fast capability with supported effort capped at High and requires fresh isolated task-local context for every child and nested child;
- leaves the Codex root model and effort to the developer (`gpt-5.6-sol` at High is recommended) while requiring explicit, enforceable child routes;
- for authorized implementation, requires an independent strong review, targeted checks, then one final broad suite;
- keeps implementation readiness separate from optional delivery.

Analysis-only work ends with read-only evidence/findings and no readiness verdict. For implementation, use runtime/visual smoke only when acceptance criteria, changed executable behavior, or repository rules make it relevant. See the [canonical orchestrator guide](orchestrator.md) for host routes, recursive capsules, Goal/preflight behavior, and review invalidation.

## `merge-request`

Use for GitHub PR/GitLab MR Preview, Create/update, Observe/status, exact-head observation, and merge-conflict resolution.

- Preview intent is read-only.
- Explicit create/update intent authorizes only a safely scoped commit/push/create-or-update chain and matching pipeline observation.
- New objects are Draft by default; ordinary updates preserve readiness.
- Titles use Conventional Commit style; descriptions are rebuilt from the final target merge-base-to-`HEAD` snapshot.
- Visible descriptions contain a plain-language summary, rationale, and material impact/risk. Optional technical and verification evidence may be collapsed, but status and gaps remain truthful.
- Observe/status is read-only and reports failures without retry or repair. Conflict-only mode never creates/updates a provider object or watches pipelines. Resolution, staging, committing, and pushing have distinct authority; remote conflict work starts only from a clean tracked tree/index.
- In-scope pipeline regressions during an already-authorized Create/update flow return to `implementation-orchestrator` for repair/review/validation before replacement-head observation. Standalone Observe/status only reports or recommends a handoff; it requires a separate user fix request and never invokes repair or retry.

## `brand-design`

Use for `(ant)` design direction or brand-fit review across websites, apps, UI, documents, decks, and visuals.

The skill covers black/white/mint brand primitives, typography, logo selection, editorial layout, product UI patterns, responsive/accessibility handoff, visual QA, and bundled assets. The canonical public manual and manifest are under `plugins/ant/skills/brand-design/assets/source/`.

For implemented product/design work, combine its brand requirements with the normal orchestrated repository workflow rather than a separate frontend entry point.
