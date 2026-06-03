# Review Checklist

Use this for brand-fit reviews before finalizing a design or implementation.

## Critical

- Correct logo variant is used for the background.
- Logo is not distorted, recolored, cropped, outlined, or too small.
- Text contrast is readable, especially mint on light backgrounds.
- The design is recognizably `(ant)`, not a generic SaaS/template style with mint added.
- UI remains usable and accessible; brand expression does not break hierarchy, controls, or responsive behavior.
- No visible text, cards, labels, fixed controls, progress bars, footers, or browser/plugin overlays cover each other. Any overlap is a blocking brand-fit and usability issue.

## Brand Fit

- Black/white/mint are the core palette.
- Secondary pastels are minor support colors only.
- Typography uses extended/headline character where feasible.
- Layout uses strong editorial structure, hard rules, and intentional whitespace.
- Bracketed labels are purposeful and short.
- Imagery reveals actual people, craft, devices, work, or relevant brand materials.
- `(ant) crafted` endorsement is present when appropriate and absent when it would imply authorship incorrectly.

## Digital UI

- Primary actions are clear and not overdecorated.
- Mint indicates brand/selection/focus sparingly.
- Dense operational screens stay scannable.
- Responsive behavior preserves line breaks, labels, and control sizes.
- Existing project components/tokens are reused where possible.
- Fixed-position controls have reserved safe area and do not sit on top of readable content.
- Grid and flex layouts with large headings constrain text (`min-width: 0`, max widths, and appropriate breakpoints) so content cannot draw into neighboring panels.

## Presentation / Deck QA

For HTML decks, slide presentations, and fixed-viewport reports:

- Check every slide, not only the first one.
- Check the longest heading and densest split layout at desktop and narrow/mobile widths.
- Confirm controls, counters, and progress bars are outside the content area or have reserved content padding.
- Confirm title/body copy fits without clipping or hiding behind footers.
- Use direct slide URLs or query params for review when available, such as `?slide=6`.
- If any slide needs emergency shrinking below readable size, rewrite/shorten the slide instead.

## Common Fixes

- Replace gradients/glow/orbs with black/white/mint fields and rules.
- Reduce pastel dominance.
- Swap rounded badges for hard label strips.
- Increase typographic contrast instead of adding decoration.
- Move brand expression to hero, section headers, labels, and endorsement rather than every component.
- Add a control rail/safe-area to fixed decks instead of floating controls over content.
- Reduce or rewrite long slide headlines before relying on smaller type.

## Review Response Format

Lead with findings:

- severity;
- concrete problem;
- affected surface or file if known;
- proposed fix.

Then summarize what already matches the brand and what remains unverified.
