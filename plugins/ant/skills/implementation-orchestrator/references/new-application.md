# New Application Intake

Use this reference only for a new application or major app-like surface. Discover the repository and environment first; do not conduct a generic technology questionnaire when the answer is already visible.

## Product Shape

Establish only what materially changes architecture or acceptance:

- Who are the primary users, and what outcome must each achieve?
- What are the two or three main end-to-end workflows?
- Is this a prototype for learning or a production system with durability and support expectations?
- Does it extend an existing product and design system, or stand alone with its own ownership?
- What are the acceptance criteria, explicit non-goals, and unresolved product decisions?

Ask for concrete behavior: inputs, decisions, outputs, failure paths, permissions, and observable success. Avoid feature inventories without workflow context.

## Data And Security

Determine from repository evidence first, then ask only material gaps:

- core entities, ownership boundaries, persistence, retention, import/export, and migration needs;
- authentication source, roles, tenant boundaries, sensitive data, audit requirements, and destructive actions;
- integrations, APIs, secrets, rate limits, background jobs, scheduled work, webhooks, retries, and idempotency.

For a prototype, identify which safeguards can be deferred without misrepresenting production readiness. For production, require explicit data safety, authorization, recovery, and operational acceptance.

## Deployment And Operations

Clarify the target environment, hosting constraints, domains, environments, configuration/secrets, observability, backups, failure recovery, expected load where material, and who operates the system. Do not claim scaling needs without evidence.

## Architecture

Choose the smallest architecture that satisfies verified workflows and constraints:

1. Reuse the repository's language, framework, components, identity, persistence, deployment, and validation conventions when they fit.
2. Prefer one deployable unit and one clear data owner until requirements justify separation.
3. Add services, queues, caches, search, realtime, or abstraction layers only for a demonstrated workflow or quality constraint.
4. Make trust boundaries, data ownership, external contracts, and failure recovery explicit.
5. Under integrated replacement, remove superseded application paths and documentation rather than maintaining parallel behavior.

Do not run a ritual comparison of languages, containers, or frameworks. Explain only decisions that affect delivery, operations, compatibility, or future change cost.

## Plan Input

Feed the main lifecycle a concise product/architecture capsule:

- users and outcomes;
- primary workflows and acceptance criteria;
- prototype or production posture;
- existing-product or standalone ownership;
- data, auth, roles, audit, integrations, jobs, and operations;
- selected smallest architecture and material tradeoffs;
- non-goals, open decisions, risks, and verification strategy.

This capsule is input to the normal proportional Plan. It does not create a separate brief-approval or handoff cycle and does not grant write authority.
