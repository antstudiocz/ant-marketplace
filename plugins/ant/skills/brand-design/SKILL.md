---
user-invocable: true
name: brand-design
description: "Use when designing or reviewing websites, apps, documents, decks, visuals, or UI so they follow the (ant) brand identity, including logo usage, color, typography, layout language, digital labels, assets, and brand-fit QA."
---

# Brand Design

Use this skill when a task asks for design in the `(ant)` brand, a redesign toward the `(ant)` identity, or a brand-fit review of a visual/UI output. This skill provides brand direction; pair it with implementation skills when code quality, framework behavior, accessibility, or delivery work is in scope.

**Announce at start:** "Using the brand-design skill to align the work with the (ant) identity before design or review."

## Core Rule

Design from the source brand system first, then adapt to the target medium. Do not reduce the identity to mint green accents; use the full system: black/white contrast, extended typography, hard editorial structure, bracketed labels, restrained mint emphasis, correct logo variant, and `(ant) crafted` endorsement where appropriate.

## Reference Selection

Load the smallest useful set:

- Brand primitives, colors, typography, logos, and source files: `references/brand-foundation.md`.
- Layout language, expressive devices, photography, labels, and anti-patterns: `references/visual-language.md`.
- Website/app UI patterns, components, motion, responsiveness, and implementation handoff: `references/digital-ui-patterns.md`.
- Bundled logos, images, and source-manual lookup guidance: `references/asset-usage.md`.
- Brand-fit QA and review format: `references/review-checklist.md`.
- Exact public brand manual details when a decision needs source evidence: `references/source-ant-brand.md`.

For frontend implementation, also use `ant:frontend-best-practices`. For a new app or app-like product, use `ant:create-application` first, then apply this skill during design direction and UI execution.

## Workflow

1. Identify the output medium: website, app UI, deck, document, social visual, email/signature, brand review, or asset selection.
2. Inspect the target surface before designing: existing design system, fonts, logo availability, framework constraints, responsive breakpoints, and audience.
3. Choose a brand mode:
   - **Core editorial:** black/white base, mint as emphasis, large type, hard separators.
   - **Product/UI:** quieter white or off-white surfaces, black controls, gray text, mint interaction/brand moments.
   - **Campaign/social:** stronger mint backgrounds, bracketed labels, oversized statements, bolder crops.
   - **Endorsement:** `(ant) crafted` or `(ant) crafted for ...` in footer/end frame when the output is made by (ant).
4. Select the logo variant for the actual background and respect minimum size.
5. Define a compact token set for the target project: colors, font stack, radius, spacing rhythm, line/border style, button style, and label style.
6. Create or revise the design using existing project patterns where possible.
7. Verify brand fit with `references/review-checklist.md` before final response.

## Decision Rules

- Prefer black, white, gray, and mint. Secondary pastels are support colors, not the core identity.
- Prefer strong typography and structure over decorative backgrounds.
- Use labels as short bracketed emphasis markers, not as generic badges everywhere.
- Use real brand assets when they communicate the brand or output type; do not add them as decoration when they compete with the user's task.
- Preserve usability and accessibility. If a brand treatment weakens contrast, readability, or responsive behavior, adjust the treatment instead of accepting the defect.
- If Aktiv Grotesk EX is unavailable or licensing is unclear, state the limitation and use the closest approved fallback path instead of silently inventing a font.

## Boundaries

- Do not invent missing Tone of Voice rules. The public export contains little direct Tone of Voice content; infer only from visible brand patterns and say when copy guidance is an inference.
- Do not use gradients, soft glass, bokeh/orbs, generic SaaS cards, or pastel-heavy compositions unless the target product already requires them and the brand treatment remains recognizably `(ant)`.
- Do not distort, recolor, outline, or rebuild logo SVGs.
- Do not use print-only color assumptions for digital work. The mint is Pantone 3385 C in the manual and is primarily reliable for digital use.
- Do not run broad builds just to validate this skill. Use targeted checks that match the changed surface.

## Output Expectations

When planning, provide:

- the selected brand mode;
- token decisions;
- logo and asset choices;
- layout/composition direction;
- risks or missing source assets;
- verification steps.

When reviewing, lead with issues ordered by severity and include concrete remediation.
