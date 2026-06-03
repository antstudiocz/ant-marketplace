# Digital UI Patterns

Use this reference for websites, web apps, mobile apps, dashboards, and interactive prototypes.

## Brand Modes For Digital Work

### Core Editorial

Best for public websites, case studies, landing sections, campaign pages, and decks.

- black or white full-width sections;
- large headline type;
- hard horizontal rules;
- mint emphasis blocks;
- logo or `(ant) crafted` as a deliberate signature;
- sparse, confident CTAs.

### Product/UI

Best for admin, client portals, internal tools, SaaS-like surfaces, and repeated workflows.

- white or `#FAFAFA` base;
- black primary actions;
- mint focus/selected/brand moments;
- cool gray text hierarchy;
- rectangular controls with restrained radius;
- dense but clean tables/lists;
- labels used as small editorial accents, not decoration.

### Campaign/Social

Best for social posts, launch visuals, event graphics, or expressive one-off screens.

- stronger mint fields;
- bold black/white inversion;
- sticker labels;
- large words in parentheses;
- more aggressive crops and scale contrast.

## Components

Buttons:

- primary: black fill with white text, or white fill on black surfaces;
- accent: mint fill with black text only when contrast and emphasis are appropriate;
- avoid gradient buttons;
- keep icons and labels direct.

Cards and panels:

- use cards only when they represent repeated items, tools, or contained choices;
- keep borders crisp and shadows minimal;
- prefer line separators and full-width bands for page sections;
- export token says default radius is `10px`; reconcile with the target project's UI rules when implementing.

Forms:

- use clear black labels and gray helper text;
- mint for focus rings or selected states;
- do not rely on mint alone for validation states.

Navigation:

- keep top navigation restrained;
- make the brand visible in the first viewport when the page is brand/product-focused;
- use strong active states and clear hierarchy.

Tables/data:

- keep data UI quieter than campaign surfaces;
- use black text, cool gray metadata, thin separators, and mint only for important state/selection;
- avoid rotated labels, expressive sticker clusters, or oversized decorative typography inside dense operational views.

## Layout

- Prefer strong grids with clear vertical rhythm.
- Use full-width bands instead of nested cards.
- Keep hero sections useful: brand/product signal first, next content hinted below the fold.
- On mobile, preserve typographic intent without clipping; shorten labels before shrinking them too far.
- Avoid viewport-width font scaling. Use defined responsive type steps.

## Motion

Motion should feel like quick editorial assembly:

- reveal by slide/clip/fade;
- short timing;
- crisp easing;
- avoid slow floating, liquid, or glow-heavy effects.

## Implementation Handoff

For frontend code:

1. Use `ant:frontend-best-practices` alongside this skill.
2. Inspect existing design tokens/components before adding new ones.
3. Map brand choices into the project's token system.
4. Verify contrast, keyboard/focus states, responsive fit, and layout stability.
5. Use screenshots or browser checks for visual work when a local target is available.
