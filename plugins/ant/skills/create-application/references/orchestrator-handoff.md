# Orchestrator Handoff

Use this format after the user approves the app brief and architecture. The handoff prepares `implementation-orchestrator`; it does not prescribe a subagent count or manufacture an orchestrator startup contract.

## Approval Boundary

Before handoff, confirm the values that create-application is responsible for capturing:

- requester technical level and communication style;
- app goal, target users, and primary workflows;
- standalone versus existing-product surface and relevant system context;
- data/persistence, database/storage, auth/permissions, authorization/audit, integrations/secrets, background work, time handling, and deployment decisions that apply;
- prototype/MVP/production expectation;
- recommended architecture and implementation path;
- acceptance criteria, non-goals, safe assumptions, and open blocking decisions;
- completed validation or independent review, if it actually occurred.

If the implementation path, architecture, app brief, or a blocking product/security/data decision is not approved, keep clarifying. Do not move into implementation.

## Do Not Invent Startup Fields

Create-application does not normally capture the orchestrator's git and delivery startup contract. Do not invent or silently default:

- repository/target branch, branch or worktree strategy;
- planning cadence or phase approval policy;
- execution/decision mode;
- commit strategy;
- delivery preference;
- PR/MR language, intent, or Draft/ready choice;
- pipeline policy;
- browser validation policy/tool preference;
- implementation stop conditions beyond the approved app brief.

Include any of these only when the user explicitly supplied and approved the value during intake. Otherwise omit the field and let `implementation-orchestrator` discover repository/runtime facts and ask the remaining user-owned blockers. Do not write `unknown`, a suggested default, or an inferred value as if the user selected it.

## Handoff Prompt

Include only captured, relevant fields; omit unused optional lines.

```text
Use ant:implementation-orchestrator for this approved new application request.

Approved application brief:
- Name or working title:
- Request type: standalone app / existing-product surface
- Requester technical level:
- Communication style:
- Goal:
- Target users:
- Primary workflows:
- Existing system context and reuse/separation constraints:
- Data and persistence requirements:
- Database/storage decision:
- Auth and permissions:
- Authorization and audit rules:
- Integrations and credential boundaries:
- Background jobs, schedules, or webhooks:
- Time handling:
- Deployment target:
- Prototype/MVP/production expectation:
- Approved implementation path:
- Framework/CMS choice:
- Recommended architecture:
- Why this architecture:
- Intake decision status:
- Decisions already approved:
- Decisions still open:
- Safe assumptions:
- Assumptions to verify before coding:
- Acceptance criteria:
- Non-goals:
- Open questions:

Optional evidence captured during intake:
- Requester development environment:
- Local setup status and missing tools:
- Compared implementation paths:
- Alternatives considered and rejected:
- Validation passes completed:
- Independent reviewer/subagent notes:
- Red flags and reconciliation notes:

Explicit orchestrator startup choices captured from the user, if any:
- <include only the exact choices the user actually supplied and approved>

Execution guidance:
- Treat create-application as the approved product/architecture intake result.
- Use the orchestrator lifecycle for repository and runtime discovery, remaining startup questions, planning, implementation delegation, review, verification, and delivery.
- Choose execution depth from observed host capabilities and task complexity.
- Keep the root orchestrator focused on coordination and evidence.
```

## Evidence Expectations

Ask the orchestrator to finish with:

- files changed;
- run instructions;
- validation commands or blocked validation reason;
- known residual risks;
- whether mock data, fake auth, or placeholder integrations remain.
