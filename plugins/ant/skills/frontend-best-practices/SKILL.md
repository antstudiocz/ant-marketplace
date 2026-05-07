---
user-invocable: true
name: frontend-best-practices
description: "Use for React, Next.js, TypeScript, and frontend UI work: components, forms, accessibility, i18n, responsive layouts, semantic HTML, performance, skeleton loading states, React 19 APIs, composition patterns, and Next.js/PPR architecture."
---

# Frontend Best Practices

Use this skill for frontend implementation, refactoring, review, and UI architecture work. This is the single public frontend entrypoint; detailed guidance lives in `references/` and should be loaded only when relevant.

Reference files may contain original skill frontmatter. Treat it as reference metadata, not as separate skill invocation.

## Baseline

For any frontend change, consider:

- component ownership, naming, structure, and extraction boundaries;
- TypeScript props, nullability, and shared type placement;
- semantic HTML and accessibility for user-facing UI;
- responsive behavior across supported breakpoints;
- i18n for all user-visible text;
- performance, loading states, and layout stability;
- framework-specific boundaries for React, Next.js, Server Components, caching, and PPR.

Do not load every reference by default. Select the smallest useful set for the task.

## Reference Selection

- Components and refactors: `references/components.md`, `references/code-separation.md`, `references/typescript.md`, and `references/composition-patterns/overview.md`.
- Forms: `references/forms.md`, `references/accessibility.md`, `references/i18n.md`, `references/typescript.md`, and React 19 form references when the project uses React 19 actions.
- User-facing text: `references/i18n.md`.
- Layout/UI markup: `references/responsive.md`, `references/semantic-html.md`, and `references/accessibility.md`.
- Loading states: `references/skeleton-loading-states.md` plus `references/performance.md`.
- Performance work: `references/performance.md`, `references/react-best-practices/overview.md`, and specific files under `references/react-best-practices/rules/` found with `rg`.
- React 19 APIs: `references/react-19.md`.
- React composition APIs: `references/composition-patterns/overview.md` and specific files under `references/composition-patterns/rules/`.
- Next.js work: `references/next-best-practices/overview.md` and the relevant topic file in `references/next-best-practices/`.
- Next.js Partial Prerendering or caching: `references/nextjs-ppr.md`, then `references/next-best-practices/data-patterns.md`, `references/next-best-practices/rsc-boundaries.md`, or `references/next-best-practices/suspense-boundaries.md` as needed.

## Workflow

1. Identify the project framework, routing model, component conventions, i18n system, and UI library before editing.
2. Load only the references needed for the task.
3. Prefer existing project patterns and design system components over new abstractions.
4. Keep domain logic out of UI glue and avoid one-off shared utilities.
5. Verify that text, controls, loading states, error states, empty states, and responsive behavior are covered.
6. Run targeted checks that match the changed surface.

## Review Focus

When reviewing frontend work, look for:

- inaccessible controls, missing labels, weak keyboard behavior, or bad focus handling;
- untranslated text or hard-coded user-facing strings;
- layout shift, skeleton mismatch, or responsive overflow;
- incorrect Server/Client Component boundaries;
- avoidable re-renders, slow data fetching, or unnecessary client-side work;
- type gaps, weak null handling, or inline types that should be owned elsewhere;
- duplicated component logic or boolean-prop-heavy APIs that should be composed differently.
