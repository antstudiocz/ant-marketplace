---
user-invocable: true
name: skeleton-loading-states
description: Build skeleton loading components with zero layout shift - mirrors actual DOM structure, CSS classes, and element dimensions
---

# Skeleton Loading States (Zero Layout Shift)

**Announce at start:** "Using **skeleton-loading-states** skill to build zero-shift loading placeholders."

## Core Principle

Mirror the actual component's DOM structure and CSS classes. Let the browser compute heights from line-height, padding, and border - never hardcode pixel heights for text elements.

## TextSkeleton Pattern

Create an `inline-block` skeleton for text content inside semantic elements. The `inline-block` display makes it participate in line-height calculation of the parent element.

```tsx
function TextSkeleton({ className }: { className?: string }) {
  return <Skeleton className={`inline-block h-3.5 align-middle ${className ?? ''}`} />;
}
```

Why `inline-block`: A regular `<Skeleton>` renders as `display: block` (`<div>`). Inside a `<label>` or `<dt>`, a block child makes the parent ignore its own line-height. `inline-block` preserves the parent's line-height behavior, matching the real text rendering.

### Recommended TextSkeleton Widths

| Content type | Width | Example |
| --- | --- | --- |
| Short label | `w-16` – `w-24` | Status, ID, category |
| Medium text | `w-28` – `w-40` | Name, email, title |
| Long text | `w-48` – `w-64` | Description, address |
| Full width | `w-full` | Paragraphs, notes |

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

Buttons typically have fixed height from padding. Use `<Skeleton>` with explicit height:

```tsx
<Skeleton className='h-[38px] w-16 rounded-md' />
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

### Badges / Tags

```tsx
<Skeleton className='h-5 w-16 rounded-full' />
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
- [ ] All text elements use same HTML tag + CSS classes as actual component
- [ ] `TextSkeleton` uses `inline-block` (not block)
- [ ] Inputs replaced by `<div>` with identical padding/border/text-size classes
- [ ] Labels use same `display` as actual (inline vs block)
- [ ] Dynamic field counts use a reasonable default (e.g. 4 fields for conditional lists)
- [ ] Skeleton wired as `loading.tsx` or `<Suspense fallback>`
- [ ] TypeScript check passes
