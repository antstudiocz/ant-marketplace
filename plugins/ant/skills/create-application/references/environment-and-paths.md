# Environment And Implementation Paths

Use this reference before recommending architecture. The goal is to avoid choosing a technically good stack that the requester cannot run.

## Environment Check

Ask what the requester can actually use:

1. Operating system: macOS, Windows, Linux, or cloud-only.
2. Local tools: Node.js, Bun, Git, editor, terminal.
3. Docker availability: installed and working, can install it, or cannot use it.
4. Team reality: who will run and maintain the app after the first version?
5. Deployment preference: static hosting, managed full-stack platform, VPS, Docker Compose, existing company platform, or unknown.

If the answer is unknown, ask the user to run simple checks when they can:

```bash
node --version
bun --version
git --version
docker --version
docker compose version
```

Do not block brainstorming on these checks, but do not finalize an implementation path that depends on unavailable tooling.

## Always Present Two Paths

For new apps and app-like surfaces, present both paths in plain language before recommending one.

### Path 1: TypeScript Only

Explain this as: one typed language for the frontend and backend, usually easier to start and easier for non-specialists to run.

Usually better when:

- the team does not have Docker locally;
- the app is small or medium-sized;
- speed of iteration matters more than infrastructure control;
- a managed database/auth/storage service is acceptable;
- the app can run on a platform that supports TypeScript server code through the normal Node/Bun toolchain.

Tradeoffs to explain:

- fewer setup steps and one language across the app;
- easier for vibe coders to inspect and modify;
- database and background-job choices are more constrained without Docker;
- local production-like testing is weaker unless the app uses managed services or a local SQLite-style database;
- complex operations can become messy if everything is forced into one TypeScript stack just to avoid Docker.

Database options without Docker:

- SQLite for local-first, small, or simple apps where a file database is enough;
- hosted Postgres or serverless Postgres for real shared data without local database setup;
- backend-as-a-service such as Supabase when auth, database, storage, and admin UI should be managed together;
- hosted key-value/document stores only when the data model is simple and relational queries are not important.

Ask before choosing: data sensitivity, expected data size, backup needs, multi-user writes, permissions, audit logs, and whether the team accepts an external cloud service.

### Path 2: Docker-Based Multi-Language Stack

Explain this as: a more complete development environment where frontend, backend, database, and workers can run together the same way for every developer.

Usually better when:

- the requester has Docker installed or can install it;
- the app needs Postgres or another real database locally;
- the app needs background jobs, queues, scheduled work, webhooks, or multiple services;
- the backend is better suited to another language such as PHP, Elixir, Python, or Go;
- the team needs a production-like local setup;
- the app is expected to grow into a maintained internal or customer-facing system.

Tradeoffs to explain:

- more setup at the beginning;
- heavier on the computer;
- easier to run the same stack for every developer once Docker works;
- better for real databases, workers, integrations, and multi-service apps;
- lets the agent pick the best backend technology for the app instead of forcing everything into TypeScript.

Database options with Docker:

- Postgres as the default relational choice for most business apps;
- Redis when queues/cache/pub-sub are needed;
- specialized databases only when the app requirements justify them.

## Recommendation Rules

If Docker is installed and the app is more than a small frontend/prototype, normally recommend the Docker path. Still mention the TypeScript-only path as the lower-setup alternative, but explain why it is not the recommended one.

If Docker is not installed and the app can safely fit TypeScript-only with SQLite or managed services, recommend TypeScript-only for the first version.

If Docker is not installed but Docker is clearly the better architecture, recommend Docker and pause before implementation planning. Explain why the better path needs Docker and provide setup instructions for the user's OS.

If the requester cannot install Docker but the app still needs Docker-level capabilities, recommend one of:

- cloud development environment such as GitHub Codespaces;
- managed platform services replacing local Docker dependencies;
- reducing scope to a TypeScript prototype with explicit limitations.

## Docker Setup Guidance

Keep setup guidance current by pointing users to official Docker docs.

macOS:

1. Open Docker's official Mac install guide: https://docs.docker.com/desktop/setup/install/mac-install/
2. Choose the correct download for Apple Silicon or Intel.
3. Install Docker Desktop and start it.
4. Verify in terminal:

```bash
docker --version
docker compose version
docker run hello-world
```

Windows:

1. Open Docker's official Windows install guide: https://docs.docker.com/desktop/setup/install/windows-install/
2. Prefer the WSL 2 backend for typical development.
3. If Docker asks to enable WSL 2, follow the prompt and restart when required.
4. Verify in PowerShell or Windows Terminal:

```bash
docker --version
docker compose version
docker run hello-world
```

For WSL 2 details, use Docker's WSL guide: https://docs.docker.com/desktop/features/wsl/

Warn users that Docker Desktop licensing may matter for larger companies. Link the official Docker Desktop terms when relevant instead of guessing the user's legal/commercial status.
