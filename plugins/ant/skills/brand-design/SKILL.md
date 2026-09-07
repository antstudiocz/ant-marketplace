---
name: brand-design
description: Use when designing or reviewing a website, app, document, deck, visual, or UI that should follow the (ant) brand identity.
---

# Brand Design

**Announce at start:** Say you are using the brand-design skill to align the work with the (ant) identity before design or review.

Use this skill for `(ant)` brand direction, asset selection, or brand-fit review. For implemented product work, apply these decisions inside the repository's normal implementation and review workflow; do not create a separate frontend workflow.

## Start with the source system

- Inspect the target surface, audience, existing design system, fonts, logo availability, and responsive constraints.
- Load only the references needed for the task:
  - [brand-foundation.md](references/brand-foundation.md) for primitives, typography, logos, and source files;
  - [visual-language.md](references/visual-language.md) for composition, labels, imagery, and anti-patterns;
  - [digital-ui-patterns.md](references/digital-ui-patterns.md) for product UI, responsiveness, accessibility, and implementation handoff;
  - [asset-usage.md](references/asset-usage.md) for bundled asset selection;
  - [review-checklist.md](references/review-checklist.md) for final brand-fit QA.
- Use `assets/source/ant-brand.md` for exact manual details and `assets/source/manifest.json` for asset metadata. Preserve the complete bundled brand corpus.

## Design rules

- Start with black, white, gray, and restrained mint; choose the brand mode that fits the medium (core editorial, product/UI, campaign/social, or endorsement).
- Use strong typography, hard editorial structure, bracketed labels, and the correct logo variant. Do not distort, recolor, outline, or rebuild logo SVGs.
- Prefer clarity, semantic structure, contrast, accessibility, and explicit safe areas over decoration. Overlap between content, controls, footers, or overlays fails review.
- Use approved fonts or state the limitation and choose the closest approved fallback. Do not invent tone-of-voice rules; label copy guidance as inference when needed.
- Avoid gradients, soft glass, bokeh/orbs, generic SaaS cards, and pastel-heavy treatments unless the target requires them and the result remains recognizably `(ant)`.

## Output

State the selected mode, token and logo/asset choices, composition direction, material limitations, and verification performed. For visual deliverables, use the review checklist and render desktop plus narrow/mobile views when tooling is available.
