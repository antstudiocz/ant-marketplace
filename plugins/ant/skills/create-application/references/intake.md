# Application Intake

Ask the fewest high-impact questions needed to classify the app. Prefer grouped questions over a long interview, then make safe assumptions explicit.

## Minimum Questions

1. What problem should the app solve, and who will use it?
2. What are the first three workflows the user must be able to complete?
3. What data does the app create, read, update, delete, import, or export?
4. Does the app need authentication, roles, private data, or team/company separation?
5. Which external systems, APIs, files, webhooks, AI tools, or integrations are involved?
6. Does anything need to run in the background, on a schedule, or after the user closes the browser?
7. Is this a throwaway prototype, internal tool, MVP, or production product?
8. Where should it run: local only, static hosting, existing platform, Docker Compose, cloud app platform, or unknown?

## Clarify Only When Blocking

Blocking questions usually include:

- auth and private data requirements;
- whether data must persist beyond a browser session;
- whether credentials or secrets are required;
- whether the app belongs inside an existing product architecture;
- production versus prototype expectations.

Safe assumptions can include naming, visual style, mock content, and non-critical UI copy when the user has not specified them. State those assumptions before handoff.

## App Brief Fields

Capture:

- app name or working title;
- target users;
- primary workflows;
- data and persistence requirements;
- integrations and credential boundaries;
- auth and permissions;
- time handling requirements;
- deployment target;
- recommended architecture;
- acceptance criteria;
- non-goals;
- open questions.
