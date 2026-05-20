---
user-invocable: true
name: create-application
description: Use when a user wants to create a new application, MVP, prototype, internal tool, dashboard, automation UI, or full-stack product from an idea. Guides product intake, architecture choice, simple React/TanStack versus Dockerized modular app decisions, and handoff into implementation-orchestrator before coding.
---

# Create Application

Use this skill as the product and architecture intake layer for new application work. It does not replace `implementation-orchestrator`; it prepares a clear application brief and then hands execution to the orchestrator.

**Announce at start:** "Using the create-application skill to clarify the app shape, choose the right architecture, and hand off to implementation orchestration."

## Core Rule

Do not implement application code directly from this skill.

Create the app brief, make the architecture recommendation, get user approval, then invoke `ant:implementation-orchestrator` with the approved handoff. The orchestrator owns git setup, planning depth, subagent strategy, implementation, review, verification, and delivery.

## Reference Selection

- Intake questions and scope discovery: `references/intake.md`.
- Simple versus full app architecture decision: `references/decision-matrix.md`.
- Orchestrator handoff format and approval boundary: `references/orchestrator-handoff.md`.

Load only the references needed for the current conversation. For a user who is still brainstorming, intake and decision matrix are usually enough. For a user ready to build, also load the handoff reference.

## Workflow

1. Clarify the application goal, users, workflows, data, integrations, authentication, deployment, and expected lifetime.
2. Classify uncertainty as blocking, repo-discoverable, or safe to assume.
3. Recommend one architecture:
   - simple React/TanStack frontend app;
   - standard full-stack app;
   - Dockerized modular app similar to AntBrain;
   - existing platform/module work, if the user is extending an existing system.
4. Explain the tradeoff in a few concrete sentences, especially when avoiding overengineering or rejecting a too-simple frontend-only shape.
5. Produce an application brief with acceptance criteria and explicit non-goals.
6. Ask the user to approve the architecture and brief before coding.
7. After approval, invoke `ant:implementation-orchestrator` and pass the handoff from `references/orchestrator-handoff.md`.

## Boundaries

- Do not choose Docker, databases, workers, authentication, or modular architecture just because the app could grow later. Require an actual workflow, persistence, integration, operational, or team-maintenance reason.
- Do not force a frontend-only implementation when the app needs private data, long-lived persistence, background work, webhooks, secure credentials, role-based access, auditability, or reliable server-side integration logic.
- Keep UTC time across API, storage, business logic, jobs, and integration boundaries. Convert to user local time only in UI rendering.
- Use existing company/platform architecture when the app is being added to an existing codebase. Do not scaffold a separate app when a module, integration, or extension is the right ownership boundary.
- Make mock data and throwaway prototype decisions explicit. A vibe-coded prototype must not be presented as production-ready.
