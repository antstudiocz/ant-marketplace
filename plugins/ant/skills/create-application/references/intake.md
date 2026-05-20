# Application Intake

Ask the fewest high-impact questions needed to classify the app. Prefer grouped questions over a long interview, then make safe assumptions explicit.

## Minimum Questions

1. What problem should the app solve, and who will use it?
2. What are the first three workflows the user must be able to complete?
3. What data does the app create, read, update, delete, import, or export?
4. Does the app need authentication, roles, private data, or team/company separation?
5. How should authorization work: who can see what, who can change what, and who approves or audits sensitive actions?
6. What database or storage expectations exist: none, browser-only, SQLite, hosted service, Postgres, existing database, or unknown?
7. Which external systems, APIs, files, webhooks, AI tools, or integrations are involved?
8. Does anything need to run in the background, on a schedule, or after the user closes the browser?
9. Is this a throwaway prototype, internal tool, MVP, or production product?
10. Is this standalone, or a new surface inside an existing app such as administration, backoffice, client portal, reporting, or a major module?
11. Where should it run: local only, static hosting, existing platform, Docker Compose, cloud app platform, or unknown?

## Clarify Only When Blocking

Blocking questions usually include:

- auth and private data requirements;
- authorization and audit requirements for internal/admin workflows;
- database/storage choice and ownership;
- whether data must persist beyond a browser session;
- whether credentials or secrets are required;
- whether the app belongs inside an existing product architecture;
- whether an admin/backoffice/client-portal surface can reuse the existing app stack or needs a separate frontend/backend/security boundary;
- production versus prototype expectations.

Safe assumptions can include naming, visual style, mock content, and non-critical UI copy when the user has not specified them. State those assumptions before handoff.

## App Brief Fields

Capture:

- app name or working title;
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
- acceptance criteria;
- non-goals;
- open questions.
