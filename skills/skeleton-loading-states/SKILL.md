---
user-invocable: true
name: skeleton-loading-states
description: Build skeleton loading components with zero layout shift - mirrors actual DOM structure, CSS classes, and element dimensions
---

# Skeleton Loading States (Zero Layout Shift)

**Announce at start:** "Using **skeleton-loading-states** skill to build zero-shift loading placeholders."

## Core Principle

Mirror the actual component's DOM structure and CSS classes. Let the browser compute heights from line-height, padding, and border - never hardcode pixel heights for text elements.

### CRITICAL: Never use `<div className='h-*'>` for text placeholders

The #1 source of layout shift is replacing text elements with fixed-height `<div>` blocks:

```tsx
// BAD — hardcoded height, always wrong
<div className='h-6 w-40 animate-pulse rounded bg-zinc-200' />   // guessing heading height
<div className='h-4 w-24 animate-pulse rounded bg-zinc-200' />   // guessing text-sm height

// GOOD — same element + classes, browser computes correct height
<h2 className='text-lg font-semibold'><TextSkeleton className='w-40' /></h2>
<p className='text-sm'><TextSkeleton className='w-24' /></p>
```

Why this matters: `text-sm` has `line-height: 20px` but `h-4` = 16px. `text-lg` has `line-height: 28px` but `h-6` = 24px. These 4px errors accumulate across sections.

### CRITICAL: Check UI component base styles before writing skeleton

Before using `rounded-md` or other classes for buttons/inputs, **read the actual UI component** (e.g., `Button.tsx`, `Input.tsx`) to verify its base CSS classes. Common mistakes:
- Button uses `rounded-full` but skeleton uses `rounded-md`
- Input uses custom padding but skeleton guesses different padding

### CRITICAL: Copy exact spacing from the component

Don't approximate spacing. If the real component uses `mt-1` between two `<p>` elements, don't use `space-y-2` in the skeleton. Copy the exact margin/gap classes from the source JSX.

## Two Skeleton Approaches: Text vs. Atomic Elements

There are exactly **two patterns** for skeleton placeholders. Using the wrong one is the #1 source of visual mismatch.

### 1. TextSkeleton — for text content (h1-h6, p, dt, dd, label, span)

Use `inline-block` skeleton **inside the same semantic element** with the same CSS classes. The parent element's `line-height` computes the correct height automatically.

```tsx
function TextSkeleton({ className }: { className?: string }) {
  return <Skeleton className={`inline-block h-3.5 align-middle ${className ?? ''}`} />;
}
```

Why `inline-block`: A regular `<Skeleton>` renders as `display: block` (`<div>`). Inside a `<label>` or `<dt>`, a block child makes the parent ignore its own line-height. `inline-block` preserves the parent's line-height behavior, matching the real text rendering.

#### Recommended TextSkeleton Widths

| Content type | Width | Example |
| --- | --- | --- |
| Short label | `w-16` – `w-24` | Status, ID, category |
| Medium text | `w-28` – `w-40` | Name, email, title |
| Long text | `w-48` – `w-64` | Description, address |
| Full width | `w-full` | Paragraphs, notes |

### 2. Atomic Skeleton — for badges, tags, buttons, avatars, icons

Use a **single self-contained pulse block** with exact dimensions. Do NOT nest a TextSkeleton inside these — the outer wrapper has no visible background, so the inner bar "floats in nothing".

```tsx
// BAD — invisible wrapper, inner bar floats
<span className='rounded-full px-3 py-1 text-sm font-medium'>        // ← no bg = invisible
  <span className='h-3.5 w-12 animate-pulse bg-zinc-200' />          // ← orphaned bar
</span>

// GOOD — single block with measured dimensions
<div className='h-7 w-[70px] animate-pulse rounded-full bg-zinc-200' />
```

**Rule of thumb**: If the element is a **visual unit with its own background/border** (badge, tag, button, avatar), use a single pulse block. If it's **text inside a container** (heading, paragraph, label), use TextSkeleton inside the same semantic element.

## Element Mapping Rules

### Text elements (h1-h6, p, dt, dd, label, span)

Use the **same element with same CSS classes**, put `<TextSkeleton>` inside:

```tsx
// Actual
<dt className='text-sm text-zinc-500'>ID zákazníka</dt>
<dd className='text-sm font-medium'>7575</dd>

// Skeleton - identical elements + classes
<dt className='text-sm text-zinc-500'><TextSkeleton className='w-28' /></dt>
<dd className='text-sm font-medium'><TextSkeleton className='w-48' /></dd>
```

### Inputs

Use a `<div>` with the same padding/border/text-size classes:

```tsx
// Actual
<input className='w-full rounded-md border border-zinc-300 px-3 py-2 text-sm ...' />

// Skeleton - same classes on a div
<div className='w-full rounded-md border border-zinc-300 px-3 py-2 text-sm ...'>
  <TextSkeleton className='w-24' />
</div>
```

### Selects / Comboboxes

Use a `<div>` with the same flex/padding classes + the dropdown icon:

```tsx
// Skeleton
<div className='flex w-full items-center justify-between rounded-md border px-3 py-2 text-sm'>
  <TextSkeleton className='w-24' />
  <ChevronsUpDownIcon className='ml-2 size-4 shrink-0 opacity-50' />
</div>
```

### Buttons (submit, CTA)

Buttons have fixed height from padding. Use `<Skeleton>` with explicit height matching the button size variant. **Always check the Button component's base styles** for the correct `rounded-*` class:

```tsx
// FIRST: Read Button.tsx to find base classes (e.g., rounded-full vs rounded-md)
// THEN: Match the height to the button's size variant (h-9 for sm, h-10 for default)
<Skeleton className='h-10 w-16 rounded-full' />
```

### Tables

Mirror `<table>` structure with skeleton rows:

```tsx
<table className='w-full'>
  <thead>
    <tr>
      {columns.map((col) => (
        <th key={col} className='px-4 py-2 text-left text-sm font-medium'>
          <TextSkeleton className='w-20' />
        </th>
      ))}
    </tr>
  </thead>
  <tbody>
    {Array.from({ length: rowCount }).map((_, i) => (
      <tr key={i} className='border-t'>
        {columns.map((col) => (
          <td key={col} className='px-4 py-2 text-sm'>
            <TextSkeleton className='w-24' />
          </td>
        ))}
      </tr>
    ))}
  </tbody>
</table>
```

### Avatars / Images

Use `<Skeleton>` with matching size and border-radius:

```tsx
// Circle avatar
<Skeleton className='size-10 rounded-full' />

// Rectangular image/thumbnail
<Skeleton className='h-32 w-full rounded-md' />
```

### Badges / Tags (atomic — NOT TextSkeleton)

Badges and tags are atomic visual elements with their own background. Use a single pulse block with measured dimensions. **Never nest a TextSkeleton inside a badge wrapper** — the wrapper has no visible background in skeleton mode.

```tsx
// Badge — measure real height/width from browser
<div className='h-7 w-[70px] animate-pulse rounded-full bg-zinc-200' />

// Tag — measure real tag dimensions
<div className='h-5 w-[52px] animate-pulse rounded-md bg-zinc-200' />
```

### Tabs

Keep the tab structure, skeleton the labels:

```tsx
<div className='flex gap-2 border-b'>
  {Array.from({ length: 3 }).map((_, i) => (
    <div key={i} className='px-4 py-2'>
      <TextSkeleton className='w-16' />
    </div>
  ))}
</div>
```

### Labels: `display` matters

HTML `<label>` defaults to `display: inline`. If the actual component does NOT add `block`, the skeleton label must also stay `inline`. Adding `block` to a skeleton label inside `space-y-*` changes margin calculation and introduces shift.

## Next.js Integration

Export skeleton as the `loading.tsx` fallback for route segments:

```tsx
// app/[locale]/customers/loading.tsx
import { CustomerListSkeleton } from '@/components/customers/CustomerListSkeleton';

export default function Loading() {
  return <CustomerListSkeleton />;
}
```

For Suspense boundaries within a page:

```tsx
import { Suspense } from 'react';
import { OrderTableSkeleton } from '@/components/orders/OrderTableSkeleton';

export default function CustomerDetail() {
  return (
    <div>
      <CustomerHeader />
      <Suspense fallback={<OrderTableSkeleton />}>
        <OrderTable />
      </Suspense>
    </div>
  );
}
```

## Workflow

### Step 1: Find and read the source component

The JSX source code IS the DOM structure. No browser automation is needed to understand the page layout.

- Use a **single Explore subagent** to find the page route file, the main component, and any existing skeleton
- Read the component's JSX — this gives you the exact DOM structure, CSS classes, grid layouts, and element hierarchy
- **Read UI component base styles** (Button.tsx, Input.tsx, etc.) to know the correct `rounded-*`, padding, and height classes
- If user provides a screenshot, use it to confirm visual layout — but the source code is the primary reference

### Step 2: Build the skeleton

1. Copy wrapper structure (card divs, grids, spacing classes)
2. Replace text content with `<TextSkeleton className='w-XX' />`
3. Replace inputs with `<div>` using same padding/border classes
4. Replace selects with `<div>` + dropdown icon
5. Keep real icons where they provide visual context (MapPin, ChevronUpDown)

### Step 3: Verify

- Run **TypeScript check** (`tsc --noEmit`) — sufficient for pure Tailwind skeleton components
- Wire up as `loading.tsx` or Suspense fallback

### What NOT to do

- **Do NOT use browser automation** (Claude in Chrome, Playwright) to analyze page layout — the source code already contains everything
- **Do NOT launch multiple subagents** — one Explore agent to find files is enough
- **Do NOT capture the page DOM via browser tools** — reading the component JSX is faster and more accurate

## Debug: Overlay Comparison

Temporarily overlay skeleton on top of actual content at full width to visually verify alignment:

```tsx
<div className='relative'>
  <div className='absolute inset-0 z-10 opacity-50'>
    <div className='outline outline-2 outline-red-500'>
      <MySkeleton />
    </div>
  </div>
  <div className='relative z-0'>
    <ActualContent />
  </div>
</div>
```

Then measure with JS:

```js
const skel = document.querySelector('.outline').offsetHeight;
const actual = document.querySelector('.relative.z-0 .space-y-6').offsetHeight;
console.log('diff:', skel - actual); // target: 0
```

## Debug with Claude in Chrome Extension (optional — only for visual verification)

**Do NOT use browser automation to analyze the page layout. Read the component source code instead — it's faster and more accurate.**

Browser tools are only useful for optional **visual verification** after the skeleton is already built:

1. **Temporarily modify the page component** to render both skeleton and actual content in the overlay layout (see above)
2. **Take a screenshot** with `mcp__claude-in-chrome__computer` (action: `screenshot`) to visually compare alignment
3. **Measure heights** with `mcp__claude-in-chrome__javascript_tool`:
   ```js
   const skel = document.querySelector('.outline')?.offsetHeight ?? 0;
   const actual = document.querySelector('.relative.z-0')?.children[0]?.offsetHeight ?? 0;
   return { skeleton: skel, actual, diff: skel - actual };
   ```
4. Iterate until diff is < 5px, then **restore the page component** to its original state

**Important**: The Chrome screenshot tool waits for full page load, so you cannot capture Suspense fallback states directly. Always use the overlay approach instead of adding `setTimeout` delays to simulate loading.

## Checklist

- [ ] Component source code read (NOT browser DOM capture)
- [ ] UI component base styles checked (Button.tsx, Input.tsx — for `rounded-*`, padding, height)
- [ ] **Text elements** use same HTML tag + CSS classes with TextSkeleton inside (NOT `<div className='h-*'>`)
- [ ] **Atomic elements** (badges, tags, buttons) use single pulse blocks with measured dimensions (NOT nested TextSkeleton)
- [ ] Inputs replaced by `<div>` with identical padding/border/text-size classes
- [ ] Labels use same `display` as actual (inline vs block)
- [ ] Spacing copied exactly from source (`mt-1`, `mt-4`, etc. — not approximated with `space-y-*`)
- [ ] Dynamic field counts use a reasonable default (e.g. 4 fields for conditional lists)
- [ ] Skeleton wired as `loading.tsx` or `<Suspense fallback>`
- [ ] TypeScript check passes
