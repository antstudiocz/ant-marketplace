# Orchestrator Handoff

Use this format after the user approves the app brief and architecture. The handoff should prepare `implementation-orchestrator`; it should not prescribe exactly how many subagents to spawn.

## Approval Boundary

Before handoff, confirm:

- architecture choice;
- requester technical level and communication style;
- TypeScript-only versus Docker-based implementation path;
- requester environment constraints;
- app brief;
- target repo or project location;
- prototype versus production expectation;
- any known non-goals;
- whether to proceed with implementation planning;
- decisions already approved;
- decisions still open;
- safe assumptions;
- assumptions that must be verified before coding;
- validation passes completed;
- independent reviewer/subagent notes if used.

If these are not approved, keep clarifying. Do not move into implementation.

## Handoff Prompt

```text
Use ant:implementation-orchestrator for this approved new application request.

Application brief:
- Name:
- Request type: standalone app / new surface inside existing product / existing platform module
- Requester technical level:
- Communication style:
- Intake decision status:
- Goal:
- Target users:
- Primary workflows:
- Existing system context:
- Reuse versus separate stack decision:
- Requester development environment:
- Package manager/runtime decision:
- Local setup status and missing tools:
- Compared implementation paths:
- Approved implementation path:
- Framework/CMS choice:
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
- Decisions already approved:
- Decisions still open:
- Assumptions safe to proceed with:
- Assumptions to verify before coding:
- Validation passes completed:
- Independent reviewer/subagent notes:
- Alternatives considered and rejected:
- Red flags reviewed:
- Challenge/reconciliation notes:
- Non-goals:
- Acceptance criteria:
- Open questions:

Execution guidance:
- Treat create-application as the product/architecture intake result.
- Use the orchestrator lifecycle for git setup, planning, implementation delegation, review, verification, and delivery.
- Choose the execution depth based on complexity. For a small app, one implementation lead may own the work end to end. For broader or riskier work, add scouts, disjoint slice workers, and an independent reviewer only as needed.
- Keep the root orchestrator focused on coordination and evidence.
```

## Evidence Expectations

Ask the orchestrator to finish with:

- files changed;
- run instructions;
- validation commands or blocked validation reason;
- known residual risks;
- whether mock data, fake auth, or placeholder integrations remain.
