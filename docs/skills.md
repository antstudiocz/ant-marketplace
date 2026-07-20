# Skills

This marketplace exposes a small set of public skills. Detailed topic guidance lives under each skill's `references/` folder and is loaded only when relevant.

## `create-application`

Product and architecture intake for new applications, MVPs, prototypes, internal tools, dashboards, automation UIs, full-stack products, and new app-like surfaces inside existing products such as administration, backoffice, client portals, reporting, or major modules.

How it works:

- clarifies goal, users, workflows, data, auth, integrations, background work, deployment, and expected lifetime;
- asks for the requester's technical level and adapts wording for beginner, intermediate, or advanced users, including plain-language explanations for infrastructure terms such as cron, Supabase, workers, queues, and managed services;
- checks the requester's local development environment, including whether Docker is available, by inspecting the local machine directly when the host supports it;
- guides the requester through missing Git, package manager/runtime, or Docker setup from a dedicated local-dev setup reference before implementation planning, while allowing npm when Bun is unavailable;
- always compares a TypeScript-only path with a Docker-based multi-language path in non-technical language;
- keeps the first intake round short while continuing with every genuinely blocking question needed for an honest decision status;
- decides whether the app should be a TypeScript frontend/content app, TypeScript full-stack app, CMS-backed app, Dockerized modular app, new surface inside an existing app, or existing platform/module change;
- selects frameworks and CMS options by project shape, preferring TanStack Start over Next.js for new app-like TypeScript products unless Next.js has a concrete project fit;
- challenges inconsistent goals, unsafe assumptions, and mismatched technology choices before asking for approval;
- validates decisions repeatedly, optionally with an independent reviewer/subagent for medium/high-risk app choices;
- asks explicit questions about authorization, database/storage, auditability, deployment, and production expectations instead of making assumptions;
- checks whether an admin/backoffice/client-portal surface can reuse the existing stack or needs a separate frontend/backend/security boundary;
- makes mock data, prototype scope, persistence, secrets, and production-readiness tradeoffs explicit;
- prepares an approved application brief with acceptance criteria and non-goals;
- hands only captured, approved brief fields to `implementation-orchestrator`; missing git/delivery startup choices remain open for the orchestrator instead of being invented;
- leaves planning depth, capability-driven delegation, implementation, review, verification, and delivery to `implementation-orchestrator`.

Use it when the user wants to create a new app from an idea before writing code.

## `implementation-orchestrator`

End-to-end implementation flow for features, fixes, refactors, migrations, audits, and remediation work.

How it works:

- inspects repository instructions, git state, relevant code, and validation commands before asking questions or editing;
- asks only for unresolved choices that materially change behavior, architecture, safety, scope, or delivery;
- chooses a proportional shape: one writer for simple work, one lead plus optional scout/reviewer for standard work, and independent review for high-risk work;
- routes children by Strong, Balanced, and Fast capabilities instead of hardcoded model names;
- reassesses reasoning while work is active, escalating for new ambiguity or risk and lowering it at safe deterministic boundaries;
- delegates all tracked edits and keeps write scopes disjoint when work is parallel;
- accepts mid-flight status, corrections, and additive requests without pausing unaffected work;
- runs checks targeted to coherent implementation phases instead of repeatedly running the full suite;
- runs one full suite on the final tree before delivery and refreshes it once only if a later relevant edit occurs;
- uses `merge-request` for PR/MR creation or updates and `delivery-workflows` only for merge conflicts;
- finishes with changed areas, checks run, unverified items, and delivery state.

Use it when the user wants a task driven from idea to working, verified implementation.

## `brand-design`

Brand design guidance for creating or reviewing websites, apps, decks, documents, social visuals, email signatures, and other visual outputs against the `(ant)` identity.

How it works:

- selects the right brand mode for the medium: core editorial, product/UI, campaign/social, or endorsement;
- uses the source brand primitives: black/white contrast, mint `#5bffc4`, approved grays, Aktiv Grotesk EX for headline character, Inter for body/UI text, and correct logo variants;
- loads only the relevant brand references for colors, typography, visual language, digital UI patterns, asset usage, or review;
- treats bracketed labels, hard rules, typographic hierarchy, and `(ant) crafted` as system elements rather than decoration;
- pairs with `frontend-best-practices` when implementation quality, accessibility, responsiveness, or framework behavior is in scope;
- flags missing source assets, unavailable licensed fonts, weak contrast, generic SaaS styling, and misuse of logo or mint-heavy palettes.

Use it when a task asks for an `(ant)` branded design, a redesign toward the `(ant)` identity, or a brand-fit review.

## `frontend-best-practices`

Frontend quality and architecture guidance for React, Next.js, TypeScript, accessibility, forms, i18n, responsive UI, semantic HTML, performance, skeleton loading states, React 19 APIs, and composition patterns.

How it works:

- acts as the single public frontend engineering entrypoint;
- identifies the relevant frontend surface before loading extra context;
- loads only the needed references, such as `components.md`, `forms.md`, `accessibility.md`, `next-best-practices/overview.md`, `react-19.md`, or specific rule files;
- checks UI structure, type boundaries, translations, accessibility, loading states, responsive behavior, and framework-specific Server/Client boundaries.

Use it for frontend implementation, refactoring, and review.

## `laravel-best-practices`

Laravel 12+ backend guidance for architecture, controllers/actions/services, DTOs, Eloquent performance, queues, caching, invalidation, HTTP caching, and backend code review.

How it works:

- acts as the single public Laravel entrypoint;
- starts with ownership and layer placement before optimizing details;
- loads architecture, caching, and performance references only as needed;
- checks thin controllers, action/service boundaries, explicit data contracts, query behavior, cache ownership, invalidation, queues, UTC time handling, and targeted validation.

Use it for Laravel implementation, refactoring, performance work, caching work, and review.

## `delivery-workflows`

Git delivery workflow for resolving merge conflicts with repository context.

How it works:

- inspects branch and dirty state before mutating git state;
- loads focused conflict-resolution guidance;
- preserves unrelated user changes;
- understands both sides before choosing the resolved behavior;
- validates the affected areas before completing the conflict operation.

Use it for merge-conflict resolution. Invoke `merge-request` directly for every PR/MR creation or update.

## `merge-request`

GitHub/GitLab Pull Request and Merge Request workflow for creating practical titles and descriptions from the current branch.

How it works:

- checks git status, branch, target branch, remote provider, diff, and recent commits before mutating delivery state;
- asks which language to use unless the current task already contains an explicit choice;
- verifies any orchestrator summary against the repository instead of requiring a handoff schema;
- uses `glab` for GitLab repositories and `gh` for GitHub repositories;
- prefers Draft MR unless the user explicitly asks for ready/bez draft;
- performs only the commit, push, PR/MR, readiness, merge, or release actions the user requested;
- uses a short Conventional Commit style title;
- writes the description in the selected language with sections for what changed, why, chosen decisions, user and technical impact, UX walkthrough, technical testing, unverified items, and reviewer focus.
- owns the final preview/confirmation and all `glab`/`gh` create or update commands.

Use it when the user asks to create or prepare an MR/PR and needs a structured practical description.

## `google-docs`

Google Docs ingestion workflow for reading and extracting content from a Google Docs URL.

How it works:

- accepts Google Docs document URLs;
- extracts document text and relevant structure;
- routes the extracted content into the current task, for example requirements analysis or implementation context;
- uses native connector/file access when available and falls back to the host's available document-reading flow.

Use it when the user provides a Google Docs URL and wants to read, analyze, or work from that content.

## `asana-task-analyzer`

Asana task analysis workflow for turning an Asana task into implementation-ready context.

How it works:

- accepts an Asana task URL;
- reads the task body, comments, attachments, and linked context when available;
- extracts goals, requirements, acceptance criteria, unknowns, and implementation hints;
- highlights blockers or missing product decisions before implementation starts.

Use it when the user provides an Asana task and wants to understand what needs to be built or fixed.

## Internal References

Files under `references/` are not public skills. They preserve detailed guidance from older narrow skills while keeping the public skill list small and easier for Claude Code and Codex to choose from.
