# Framework Selection

Use this reference before naming a frontend, full-stack, or CMS technology. Do not default to one framework by habit.

## Selection Questions

Ask:

1. Is this mostly content, mostly application workflow, or both?
2. Who edits content or structured data: developers only, internal users, clients, marketers, editors, or admins?
3. Does it need SEO, static generation, rich routing, dashboards, forms, auth, mutations, admin panel, or content previews?
4. Is there an existing repository or hosting platform that already favors a framework?
5. Does the user need a custom app UI, a CMS/admin UI, or both?

## Candidate Guidance

Use these as examples, not fixed defaults:

- **Astro**: content-first websites, marketing pages, landing pages, blogs, documentation, portfolios, catalogs, and sites where most pages should be fast static HTML with limited interactive islands.
- **TanStack Start**: app-like TypeScript products with typed routing, client/server data flows, forms, dashboards, internal tools, and workflows where React application behavior is central.
- **Next.js**: TypeScript apps that benefit from the Next.js ecosystem, App Router conventions, hosting familiarity, server rendering, or tools that are built around Next.js.
- **Payload CMS**: projects where non-developers need to manage content or structured data through an admin panel, especially when a TypeScript/Next.js-native CMS and code-defined content model are useful.
- **Existing framework**: when a repository already has a clear framework, use it unless there is a concrete reason to migrate.

## Payload CMS Fit

Consider Payload when:

- the app needs collections/content models, media, editorial workflows, or admin-managed structured data;
- a custom admin panel would otherwise be built from scratch;
- non-technical users need to manage content/data safely;
- the project benefits from a TypeScript-native CMS that can live with a Next.js app.

Do not choose Payload just because "admin" appears in the request. For operational dashboards, task queues, analytics, or highly custom workflows, a custom app framework may be cleaner than a CMS.

## Recommendation Format

State:

- selected framework or CMS;
- why it fits this project shape;
- one or two alternatives considered;
- why the alternatives were not recommended;
- any lock-in, hosting, or editor-experience tradeoffs.
