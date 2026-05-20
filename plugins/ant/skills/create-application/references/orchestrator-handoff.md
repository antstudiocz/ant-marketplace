# Orchestrator Handoff

Use this format after the user approves the app brief and architecture. The handoff should prepare `implementation-orchestrator`; it should not prescribe exactly how many subagents to spawn.

## Approval Boundary

Before handoff, confirm:

- architecture choice;
- TypeScript-only versus Docker-based implementation path;
- requester environment constraints;
- app brief;
- target repo or project location;
- prototype versus production expectation;
- any known non-goals;
- whether to proceed with implementation planning.

If these are not approved, keep clarifying. Do not move into implementation.

## Handoff Prompt

```text
Use ant:implementation-orchestrator for this approved new application request.

Application brief:
- Name:
- Request type: standalone app / new surface inside existing product / existing platform module
- Goal:
- Target users:
- Primary workflows:
- Existing system context:
- Reuse versus separate stack decision:
- Requester development environment:
- Compared implementation paths:
- Approved implementation path:
- Data and persistence:
- Database/storage decision:
- Auth and permissions:
- Authorization and audit rules:
- Integrations and secrets:
- Background jobs, schedules, or webhooks:
- Time handling:
- Deployment target:
- Recommended architecture:
- Why this architecture:
- Non-goals:
- Acceptance criteria:
- Open questions:

Execution guidance:
- Treat create-application as the product/architecture intake result.
- Use the orchestrator lifecycle for git setup, planning, implementation delegation, review, verification, and delivery.
- Choose the execution depth based on complexity. For a small app, one implementation lead may own the work end to end. For deeper work, use scout, plan writer, slice workers, and reviewer as needed.
- Keep the root orchestrator focused on coordination and evidence.
```

## Evidence Expectations

Ask the orchestrator to finish with:

- files changed;
- run instructions;
- validation commands or blocked validation reason;
- known residual risks;
- whether mock data, fake auth, or placeholder integrations remain.
