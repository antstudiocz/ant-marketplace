# Architecture Guardrails

Use this reference before asking for architecture approval. The goal is to catch inconsistent requirements and prevent vibe slop.

## Decision Signals

Use these as signals, not a scoring system:

- Auth, private data, server-side permissions, or secure credentials point toward full-stack.
- Background jobs, scheduled work, queues, webhooks, or local service parity point toward Docker or a modular backend.
- Static, content-first, prototype, local-only, or public-client-safe work points toward a lighter TypeScript path.
- Existing product/platform ownership points toward module/extension/existing-framework workflow.
- Multiple domains, teams, integrations, or ownership boundaries point toward modular architecture.
- Non-developer content/data editing points toward a CMS candidate such as Payload, but only if CMS workflows fit the request.
- SEO-heavy content points toward content-first frameworks such as Astro or a server-rendered/static-capable option.

Explain the recommendation using the strongest signals. Do not calculate fake numeric scores.

## Red Flags

Stop and challenge before approval when you see:

- frontend code would need an API secret or privileged credential;
- fake auth is being presented as real authentication;
- admin/private actions have no authorization model;
- `localStorage` or browser-only storage is proposed for business-critical shared data;
- business-critical data has no production migration or backup path;
- timezone or scheduling logic would live outside UTC business logic/UI-rendering boundaries;
- Docker is chosen without a real service, runtime, database, worker, or parity reason;
- TypeScript-only is forced despite webhooks, workers, private integrations, queues, or production-like service needs;
- Payload/CMS is chosen only because the word "admin" appears;
- TanStack Router or another client-only shape is chosen even though SEO, SSR, content previews, or server work are central;
- the selected framework conflicts with hosting, team capability, or existing repository constraints.

## Challenge And Reconcile Loop

Before final recommendation:

1. Compare the user's goals, environment, data/auth needs, framework/CMS candidate, and implementation path.
2. List anything that does not fit together in plain language.
3. Propose 1-3 better options with tradeoffs.
4. Ask the user to choose or approve the revised recommendation.

Example:

```text
One thing does not fit: you mentioned a mostly public SEO-focused website, but the current direction is a client-heavy app shell. I would not start with that. Better options:
1. Astro for content-first pages with small interactive islands.
2. TanStack Start if the site is more app/workflow-heavy and still needs server rendering.
3. Existing platform route if this belongs inside the current product.
```

Do not frame the challenge as a blocker unless the mismatch would create security, data, environment, or delivery risk.
