# Orchestrator Handoff

Use this format after the user approves the app brief and architecture. The handoff supplies completed product brainstorming to `implementation-orchestrator`; brief approval alone does not approve tracked edits or prescribe exactly how many subagents to spawn.

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
- whether the original request gave explicit end-to-end implementation authorization;
- decisions already approved;
- decisions still open;
- safe assumptions;
- assumptions that must be verified before coding;
- validation passes completed;
- independent reviewer/subagent notes if used.

If required product decisions are not approved, keep clarifying. Do not move into implementation planning. If execution intent is not yet clear, record it as ambiguous so the orchestrator asks early rather than inferring write authority.

Brief and architecture approval authorizes the handoff into repository verification and implementation planning. The orchestrator must present its concrete implementation plan before dispatching a tracked writer. It may continue after that checkpoint only when the original request gave explicit end-to-end implementation authorization and the plan stays within the original scope and risk; otherwise it must obtain explicit approval. Do not repeat product questions already settled by the brief unless repository evidence creates a contradiction or material gap.

## Handoff Prompt

```text
Use ant:implementation-orchestrator for this approved new application request.

Application brief:
- Name:
- Request type: standalone app / new surface inside existing product / existing platform module
- Execution intent: analysis-only / implementation-authorized / ambiguous
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
- Verify the approved brief against the target repository, resolve only material contradictions or gaps, then prepare and present a concrete implementation plan.
- Do not dispatch a tracked writer until that plan is presented and execution is authorized. Brief approval alone is not authorization; explicit end-to-end implementation intent in the original request permits continuing when scope and risk remain unchanged. A request to wait for approval, or a material scope/risk change, requires an explicit pause and approval.
- Use the orchestrator lifecycle for planning, implementation delegation, review, verification, and delivery.
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
