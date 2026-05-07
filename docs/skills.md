# Skills

This marketplace exposes a small set of public skills. Detailed topic guidance lives under each skill's `references/` folder and is loaded only when relevant.

## `implementation-orchestrator`

End-to-end implementation flow for features, fixes, refactors, migrations, audits, and remediation work.

How it works:

- starts with git/delivery setup: current branch, target branch, dirty state, branch/worktree choice, and MR preference;
- for medium+ work, keeps concise local ignored orchestration checkpoints so a later session can resume;
- clarifies the goal with the user and asks blocking questions instead of inventing intent;
- delegates read-only scouting when codebase facts are needed;
- after scouting, asks the user about unresolved product, data, rollout, validation, or architecture decisions before finalizing direction;
- uses cheaper/faster model tiers for bounded scouts and mechanical helper tasks when the host supports it;
- challenges weak approaches with code evidence and asks for direction approval;
- creates an `implementation-plan.md` checklist through a plan writer;
- delegates implementation to an implementation lead, which may use slice workers for parallel backend/frontend/data/test work;
- finishes with integration, targeted validation, review/fix loops, and final evidence.

Use it when the user wants a task driven from idea to working, verified implementation.

## `frontend-best-practices`

Frontend quality and architecture guidance for React, Next.js, TypeScript, accessibility, forms, i18n, responsive UI, semantic HTML, performance, skeleton loading states, React 19 APIs, and composition patterns.

How it works:

- acts as the single public frontend entrypoint;
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

Git/GitLab delivery workflows for creating merge requests and resolving merge conflicts with repository context.

How it works:

- inspects branch and dirty state before mutating git state;
- loads the matching reference for MR creation or conflict resolution;
- preserves unrelated user changes;
- uses the repository's expected delivery tool, such as `glab` for GitLab;
- validates changes before push/MR handoff.

Use it for delivery operations around an already-scoped code change.

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
