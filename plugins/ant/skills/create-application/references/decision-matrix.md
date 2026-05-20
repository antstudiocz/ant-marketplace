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
- why it fits;
- why the next heavier option is unnecessary or why the lighter option is unsafe;
- main implementation risks;
- validation plan at a high level.
