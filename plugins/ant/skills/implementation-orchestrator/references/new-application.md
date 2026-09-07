# New application intake

Read this reference only for a new application or a major app-like surface. Discover repository conventions first and ask only about material gaps.

Capture the facts that change architecture or acceptance:

- primary users, outcomes, and two or three end-to-end workflows;
- prototype or production posture and operational owner;
- existing product/design-system ownership or standalone ownership;
- data ownership, persistence/retention, auth, roles, sensitive data, audit, destructive actions, and migration needs;
- integrations, secrets, jobs, webhooks, retries, rate limits, deployment, observability, backups, and recovery where relevant;
- acceptance criteria, non-goals, unresolved decisions, and the smallest architecture that satisfies them.

Use repository evidence before asking. Do not run a generic technology questionnaire or compare frameworks without a decision it would change. For a prototype, record which safeguards are intentionally deferred; for production, resolve data safety, authorization, recovery, and operational ownership before implementation.

Root records this intake in the durable plan. It is not a separate brief-approval ceremony and does not grant child write authority.
