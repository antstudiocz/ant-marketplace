# Architecture Decision Matrix

Choose the smallest architecture that can satisfy the actual requirements without hiding production risks.

## Simple React/TanStack Frontend App

Use this when:

- the app can run entirely in the browser or against public/client-safe APIs;
- persistence is local storage, static files, user-provided files, or a clearly external service;
- there are no private server credentials, webhooks, workers, or privileged operations;
- auth is not required, or auth is delegated to an existing client-safe provider;
- the goal is a prototype, static tool, small dashboard, calculator, content app, or single-purpose internal UI.

Default shape:

- Vite or TanStack Start when routing/data patterns justify it;
- React with TypeScript;
- explicit mock-data boundary if backend data is not real yet;
- no Docker unless the repo standard requires it.

Reject this shape when frontend code would need to contain secrets, bypass permissions, fake persistence, or manually simulate backend guarantees.

## Standard Full-Stack App

Use this when:

- the app needs server-side API logic, persistent data, auth, or secure credentials;
- the backend is simple enough that a full modular platform would add more ceremony than value;
- there are one or two main domains, few integrations, and no independent runtime modules.

Default shape:

- React/TanStack frontend;
- backend appropriate to the repo/team standard;
- Postgres when relational persistence is needed;
- Docker Compose if local services are required;
- migrations, env examples, and targeted tests.

## JavaScript/TypeScript Full-Stack App Without Docker

Use this when the app needs backend logic but the requester or team cannot reasonably run Docker, and the requirements can be served by JavaScript runtime plus SQLite or managed cloud services.

Default shape:

- React/TanStack frontend;
- JavaScript/TypeScript server runtime;
- SQLite for local/simple persistence or a managed database/auth provider for shared production data;
- explicit limits around background jobs, local production parity, and operational complexity.

Reject this shape when avoiding Docker would force secrets into frontend code, weaken permissions, fake database behavior, or hide the need for queues, workers, webhooks, or production-like local services.

## Dockerized Modular App

Use this when:

- multiple product domains, integrations, or ownership boundaries are expected from the start;
- the app needs backend API, database, workers, scheduled jobs, webhooks, or long-running AI workflows;
- several teams or future modules will maintain it;
- operational repeatability matters: local Docker, service boundaries, migrations, queues, logs, and CI checks;
- the user explicitly wants an AntBrain-like modular monolith.

Default shape:

- `web` frontend;
- `api` backend;
- `worker` service when background jobs exist;
- Postgres or the chosen durable datastore;
- Docker Compose for local runtime;
- module/integration/extension boundaries rather than feature folders only;
- UTC in storage, APIs, jobs, and business logic.

Keep workflow-specific behavior in modules, integrations, extensions, templates, or adapters. Do not let a generic runtime become centered on one concrete workflow.

## New Surface Inside Existing App

Use this when the user is adding administration, backoffice, client portal, reporting, operational tooling, or another major app-like area to an existing product.

First decide whether it is truly just a feature in the current app or a separate surface with its own architecture:

- use the existing frontend routes/layouts when it shares the same users, auth, API contracts, deployment, and data access boundaries;
- create a separate admin/frontend app when it has different navigation, release cadence, users, permissions, or operational workflows;
- add backend/admin API work when it needs privileged operations, private data, audit logs, server-side validation, exports, or secure credentials;
- choose a full Dockerized/modular shape when the surface introduces durable data ownership, jobs, webhooks, integrations, or multiple future modules.

Do not assume a frontend-only product can grow an admin safely without a backend. Admin surfaces often create the first real need for authentication, permissions, database writes, auditability, and protected server-side operations.

## Existing Platform Or Module

Use this when the user is extending an existing product such as AntBrain or another modular platform.

Default shape:

- follow the repository architecture rather than scaffolding a new standalone app;
- place product behavior in the owning module;
- place vendor-specific behavior in integrations;
- place cross-module relationship behavior in extensions;
- use the platform's existing orchestration, auth, routing, API, testing, and deployment conventions.

## Recommendation Format

Give:

- recommended architecture;
- two-path comparison: JavaScript/TypeScript-only versus Docker-based multi-language;
- why it fits;
- why the next heavier option is unnecessary or why the lighter option is unsafe;
- main implementation risks;
- validation plan at a high level.
