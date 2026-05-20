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
- Developer environment check, two implementation paths, database choices, and Docker setup guidance: `references/environment-and-paths.md`.
- Simple versus full app architecture decision: `references/decision-matrix.md`.
- Orchestrator handoff format and approval boundary: `references/orchestrator-handoff.md`.

Load only the references needed for the current conversation. For a user who is still brainstorming, intake, environment-and-paths, and decision matrix are usually enough. For a user ready to build, also load the handoff reference.

## Workflow

1. Clarify the application goal, users, workflows, data, integrations, authentication, deployment, expected lifetime, and whether this is standalone or part of an existing product.
2. Check the requester's local development environment, especially whether they can run Node/Bun and Docker.
3. Ask enough product and technical questions to avoid unsupported assumptions. For internal or admin apps, explicitly clarify authorization, database, data ownership, auditability, and deployment.
4. Present two implementation paths in plain language:
   - TypeScript-only frontend and backend;
   - Docker-based multi-language stack.
5. Compare the paths with practical pros/cons and recommend one based on requirements and developer environment.
6. Classify uncertainty as blocking, repo-discoverable, or safe to assume.
7. Recommend one architecture:
   - simple TypeScript frontend app using TanStack or Next.js, not plain React;
   - TypeScript full-stack app without Docker;
   - standard full-stack app;
   - Dockerized modular app similar to AntBrain;
   - new app surface inside an existing product;
   - existing platform/module work, if the user is extending an existing system.
8. Explain the tradeoff in a few concrete sentences, especially when avoiding overengineering or rejecting a too-simple frontend-only shape.
9. Produce an application brief with acceptance criteria and explicit non-goals.
10. Ask the user to approve the implementation path, architecture, and brief before coding.
11. After approval, invoke `ant:implementation-orchestrator` and pass the handoff from `references/orchestrator-handoff.md`.

## Boundaries

- Do not choose Docker, databases, workers, authentication, or modular architecture just because the app could grow later. Require an actual workflow, persistence, integration, operational, or team-maintenance reason.
- Do not force a frontend-only implementation when the app needs private data, long-lived persistence, background work, webhooks, secure credentials, role-based access, auditability, or reliable server-side integration logic.
- Do not recommend plain React-only/Vite-only scaffolds for new apps. Prefer TanStack or Next.js as the application framework, with React only as an implementation detail of that framework.
- Do not hide environment requirements. If the recommended path needs Docker and the requester does not have Docker, say that clearly and provide macOS/Windows setup guidance before implementation planning.
- Keep UTC time across API, storage, business logic, jobs, and integration boundaries. Convert to user local time only in UI rendering.
- Use existing company/platform architecture when the app is being added to an existing codebase. Do not scaffold a separate app when a module, integration, or extension is the right ownership boundary.
- For administration, backoffice, client portal, reporting, or other new surfaces inside an existing app, do not assume it must use the same frontend-only stack. Evaluate whether it should be a route/layout in the existing app, a separate admin frontend, a full-stack admin service, or a module in the existing platform.
- Make mock data and throwaway prototype decisions explicit. A vibe-coded prototype must not be presented as production-ready.
