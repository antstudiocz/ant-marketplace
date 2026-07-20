# Application Intake

Ask high-impact questions in digestible grouped rounds rather than one long interview. Continue until every material decision that cannot be discovered from the repository or environment is resolved. Record safe assumptions only for non-material details.

Inspect available repository and environment facts before asking. Use `decision-gates.md` for grouping guidance and the required intake end state.

## Material Intake Areas

Adapt wording to the selected communication level from `communication-level.md`.

1. Technical level: beginner/non-technical, intermediate, or advanced?
2. What problem should the app solve, and who will use it?
3. What are the first three workflows the user must be able to complete?
4. What data does the app create, read, update, delete, import, or export?
5. Does the app need authentication, roles, private data, or team/company separation?
6. How should authorization work: who can see what, who can change what, and who approves or audits sensitive actions?
7. What database or storage expectations exist: none, browser-only, SQLite, hosted service, Postgres, existing database, or unknown?
8. Which external systems, APIs, files, webhooks, AI tools, or integrations are involved?
9. Does anything need to run in the background, on a schedule, or after the user closes the browser?
10. Is this a throwaway prototype, internal tool, MVP, or production product?
11. Is this standalone, or a new surface inside an existing app such as administration, backoffice, client portal, reporting, or a major module?
12. Where should it run: local only, static hosting, existing platform, Docker Compose, cloud app platform, or unknown?

## Resolve Material Decisions

Material decisions usually include:

- auth and private data requirements;
- authorization and audit requirements for internal/admin workflows;
- database/storage choice and ownership;
- whether data must persist beyond a browser session;
- whether credentials or secrets are required;
- whether the app belongs inside an existing product architecture;
- whether an admin/backoffice/client-portal surface can reuse the existing app stack or needs a separate frontend/backend/security boundary;
- production versus prototype expectations.

Safe assumptions can include naming, visual style, mock content, and non-critical UI copy when the user has not specified them. State them before handoff. Do not classify a material product, data, permission, integration, deployment, or production-readiness decision as safe merely to shorten intake.

## App Brief Fields

Capture:

- app name or working title;
- requester technical level and communication style;
- standalone app or existing-product surface;
- existing system context and reuse/separation constraints;
- target users;
- primary workflows;
- data and persistence requirements;
- database/storage decision;
- integrations and credential boundaries;
- auth and permissions;
- authorization and audit rules;
- time handling requirements;
- deployment target;
- recommended architecture;
- intake decision status;
- acceptance criteria;
- non-goals;
- open questions.
