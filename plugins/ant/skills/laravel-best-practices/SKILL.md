---
user-invocable: true
name: laravel-best-practices
description: Use for Laravel 12+ backend work involving architecture, controllers/actions/services, DTOs, Eloquent performance, queues, caching, invalidation, HTTP caching, and backend code review.
---

# Laravel Best Practices

Use this skill for Laravel backend implementation, refactoring, and review. This is the single public Laravel entrypoint; detailed guidance lives in `references/`.

Reference files may contain original skill frontmatter. Treat it as reference metadata, not as separate skill invocation.

## Baseline

Start with architecture before micro-optimization:

- keep controllers thin and route glue minimal;
- put business rules in the owning action/service/domain layer;
- use DTOs or explicit objects where arrays would hide contracts;
- keep Eloquent models from becoming god objects;
- define data, cache, queue, and validation boundaries explicitly;
- prefer root-cause fixes over suppressing errors or weakening checks.

## Reference Selection

- Architecture, file placement, DTOs, actions, controllers, model boundaries: `references/architecture.md`.
- Cache methods, invalidation, HTTP caching, repeated reads, stale-while-revalidate: `references/caching.md`.
- Query performance, N+1 detection, eager loading, indexes, jobs, route optimization: `references/performance.md`.

Load multiple references when the work crosses architecture and runtime behavior. For example, a cached query refactor usually needs architecture, caching, and performance together.

## Workflow

1. Identify the owning module/domain and existing Laravel conventions.
2. Load the narrow reference set needed for the task.
3. Trace the data flow before changing code.
4. Choose the correct layer before creating files or moving logic.
5. Check query behavior, cache invalidation, queues, and validation paths when relevant.
6. Run targeted PHP/Laravel checks that prove the changed behavior.

## Review Focus

Look for:

- business logic in controllers, requests, views, jobs, or models where it does not belong;
- implicit array contracts that should be explicit DTOs or value objects;
- N+1 queries, missing eager loading, broad selects, or repeated uncached reads;
- cache keys without ownership, invalidation, or tenant/user isolation;
- queue jobs doing too much, lacking idempotency, or hiding failure behavior;
- non-UTC time handling outside presentation;
- tests that do not cover the important happy path and failure path.
