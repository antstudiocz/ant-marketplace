---
user-invocable: true
name: create-application
description: Use when a user wants to create a new application, MVP, prototype, internal tool, dashboard, automation UI, full-stack product, or a new app-like surface inside an existing product such as administration, backoffice, client portal, reporting area, or major module. Guides thorough product intake, developer environment checks, TypeScript-only versus Docker/multi-language implementation path comparison, database options, existing-app reuse versus separate stack decisions, and handoff into implementation-orchestrator before coding.
---

# Create Application

Use this skill as the product and architecture intake layer for new application work and new app-like product surfaces inside an existing application. It does not replace `implementation-orchestrator`; it prepares a clear application brief and then hands execution to the orchestrator.

**Announce at start:** "Using the create-application skill to clarify the app shape, choose the right architecture, and hand off to implementation orchestration."

## Core Rule

Do not implement application code directly from this skill.

Create the app brief, make the architecture recommendation, get user approval, then invoke `ant:implementation-orchestrator` with the approved handoff. The orchestrator owns git setup, planning depth, subagent strategy, implementation, review, verification, and delivery.

## Reference Selection

- Intake questions and scope discovery: `references/intake.md`.
- User technical level and communication style adaptation: `references/communication-level.md`.
- Developer environment check, two implementation paths, database choices, and setup decision rules: `references/environment-and-paths.md`.
- Step-by-step local development setup for Git, Bun/npm, Docker, and verification commands: `references/local-dev-setup.md`.
- TypeScript framework and CMS selection guidance: `references/framework-selection.md`.
- Intake decision gates and minimal question rules: `references/decision-gates.md`.
- Architecture signals, red flags, and challenge/reconciliation loop: `references/architecture-guardrails.md`.
- Continuous decision validation and optional independent reviewer/subagent checks: `references/decision-validation.md`.
- Simple versus full app architecture decision: `references/decision-matrix.md`.
- Orchestrator handoff format and approval boundary: `references/orchestrator-handoff.md`.

Load only the references needed for the current conversation. For a user who is still brainstorming, intake, communication-level, environment-and-paths, framework-selection, decision-gates, architecture-guardrails, and decision matrix are usually enough. Load `decision-validation.md` before architecture approval, after material requirement changes, or when the recommendation is medium/high risk. Load `local-dev-setup.md` only when a required tool is missing, unknown, or the user asks how to install it. For a user ready to build, also load the handoff reference.

## Workflow

1. Ask the requester to choose their technical level: beginner/non-technical, intermediate, or advanced.
2. Adapt all follow-up questions, explanations, and recommendations to that level.
3. Ask at most 3 grouped questions in the first round. Continue only when answers expose a real blocker or contradiction.
4. Clarify the application goal, users, workflows, data, integrations, authentication, deployment, expected lifetime, and whether this is standalone or part of an existing product.
5. Check the requester's local development environment, especially whether they can run Git, Docker, and at least one TypeScript-capable package manager/runtime path such as Bun or Node/npm. When the host provides shell access to the same machine/workspace, inspect this directly before asking the requester.
6. Ask enough product and technical questions to avoid unsupported assumptions. For internal or admin apps, explicitly clarify authorization, database, data ownership, auditability, and deployment.
7. Present two implementation paths using the requester's technical level:
   - TypeScript-only frontend and backend;
   - Docker-based multi-language stack.
8. Compare the paths with practical pros/cons and recommend one based on requirements and developer environment.
9. Select a TypeScript framework or CMS candidate based on project shape, not habit.
10. Run the challenge/reconciliation loop: identify contradictions, red flags, mismatched technology choices, and better alternatives.
11. Run decision validation. For medium/high-risk recommendations, use an independent reviewer/subagent when the host supports it; otherwise perform a named second-pass self-review.
12. Classify uncertainty as blocking, repo-discoverable, or safe to assume.
13. End intake with one explicit decision gate status.
14. Recommend one architecture:
   - simple TypeScript frontend or content app using the best-fit framework, not plain React;
   - TypeScript full-stack app without Docker;
   - standard full-stack app;
   - Dockerized modular app similar to AntBrain;
   - new app surface inside an existing product;
   - existing platform/module work, if the user is extending an existing system.
15. Explain the tradeoff in a few concrete sentences, especially when avoiding overengineering or rejecting a too-simple frontend-only shape.
16. Produce an application brief with acceptance criteria and explicit non-goals.
17. Ask the user to approve the implementation path, architecture, framework/CMS choice, and brief before coding.
18. After approval, invoke `ant:implementation-orchestrator` and pass the handoff from `references/orchestrator-handoff.md`.

## Boundaries

- Do not choose Docker, databases, workers, authentication, or modular architecture just because the app could grow later. Require an actual workflow, persistence, integration, operational, or team-maintenance reason.
- Do not ask beginner/non-technical users deep implementation questions before explaining the concept in plain language. First understand the goal and desired behavior, then translate it into technical choices.
- For beginner/non-technical and intermediate users, explain infrastructure and platform terms in plain language the first time they appear in a recommendation or question. This includes terms such as cron, Supabase, Vercel, backend, API, worker, webhook, queue, database, authentication, authorization, Docker, Postgres, and managed service.
- Do not accept incompatible answers silently. If goals, constraints, or selected technologies do not fit together, say what does not fit and propose better options before approval.
- Do not rely on a single pass for medium/high-risk architecture choices. Validate the recommendation against requirements, environment, red flags, and alternatives before asking for approval.
- Do not force a frontend-only implementation when the app needs private data, long-lived persistence, background work, webhooks, secure credentials, role-based access, auditability, or reliable server-side integration logic.
- Do not recommend plain React-only/Vite-only scaffolds for new apps. Choose a TypeScript application framework or CMS based on the app shape. Prefer TanStack Start over Next.js for new app-like TypeScript products unless project requirements, hosting, ecosystem dependencies, an existing repository, or a CMS choice make Next.js the better fit.
- Do not hide environment requirements. If the recommended path needs Docker, Git, a package manager, or another missing local tool, load `references/local-dev-setup.md`, guide the user step by step for their OS, and ask them to run verification commands before implementation planning. Bun is not a hard blocker when the requester already has working Node/npm and the chosen stack can use npm.
- Do not ask the requester for operating system, Git, Bun/npm/Node, or Docker availability when the host can inspect the same development machine directly. Run read-only environment checks first and ask only for missing context, permission, or confirmation that they intend to use a different machine.
- Keep UTC time across API, storage, business logic, jobs, and integration boundaries. Convert to user local time only in UI rendering.
- Use existing company/platform architecture when the app is being added to an existing codebase. Do not scaffold a separate app when a module, integration, or extension is the right ownership boundary.
- For administration, backoffice, client portal, reporting, or other new surfaces inside an existing app, do not assume it must use the same frontend-only stack. Evaluate whether it should be a route/layout in the existing app, a separate admin frontend, a full-stack admin service, or a module in the existing platform.
- Make mock data and throwaway prototype decisions explicit. A vibe-coded prototype must not be presented as production-ready.
