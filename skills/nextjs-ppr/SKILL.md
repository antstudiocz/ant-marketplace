---
name: nextjs-ppr
description: Use when implementing Partial Prerendering or caching in a Next.js 16 project — routes with mixed static, cached, and dynamic data dependencies
---

# Next.js 16 PPR — Decision Framework

## Overview

Classify every data dependency before touching code. Apply one of three patterns. Wrap dynamic slots in `<Suspense>`. Verify with `next build`.

**Required config (Next.js 16):**
```ts
// next.config.ts
const nextConfig: NextConfig = { cacheComponents: true }
```

> ⚠️ `experimental: { ppr: true }` is the **deprecated Next.js 15** approach. Do NOT use it.

---

## Step 1: Classify every dependency

Before writing any code, list every data source/API the route touches and assign a category:

| Category | Definition | Examples |
|---|---|---|
| **Static** | Never changes without redeployment | Nav links, footer content, i18n messages |
| **Cached** | Changes over time, same for all users | Products, categories, prices, banners, brands |
| **Dynamic** | Unique per-request or per-user | `cookies()`, `headers()`, `searchParams`, cart, auth state |

**Rule:** If a function calls `cookies()`, `headers()`, or reads `searchParams` — it is Dynamic. No exceptions.

---

## Step 2: Apply pattern per category

### Static
No annotation needed. Next.js prerenders automatically.

### Cached
Add `'use cache'` directive + `cacheTag()` + `cacheLife()`:

```ts
import { cacheTag, cacheLife } from 'next/cache'

export async function fetchProducts(params) {
  'use cache'
  cacheTag('products')          // for on-demand invalidation
  cacheLife('hours')            // or { revalidate: 3600 }

  const res = await fetch(GRAPHQL_ENDPOINT, { ... })
  return res.json()
}
```

> ⚠️ Do NOT use `next: { revalidate: N }` on `fetch()`. That is the old pattern.
> Do NOT rely on React `cache()` alone — it deduplicates within one render, not across requests.

**Granular tags for precise invalidation:**
```ts
cacheTag('products')            // invalidates all products
cacheTag(`product:${id}`)       // invalidates one product
cacheTag('products:featured')   // invalidates a subset
```

### Dynamic
No annotation needed — but MUST be inside `<Suspense>` when the route has Static/Cached content.

---

## Step 3: Compose the page

```tsx
import { Suspense } from 'react'

export default async function Page({ searchParams }) {
  // Static — renders in the prerendered shell, no await needed here
  return (
    <>
      <StaticNav />                           {/* Static — in shell */}

      <Suspense fallback={<p>Loading... IMPLEMENT SKELETON</p>}>
        <ProductList />                       {/* Cached — streams in */}
      </Suspense>

      <Suspense fallback={<p>Loading... IMPLEMENT SKELETON</p>}>
        <RecentlyViewed />                    {/* Dynamic (cookies) — streams in */}
      </Suspense>

      <StaticFooter />                        {/* Static — in shell */}
    </>
  )
}
```

**Granularity rules:**
- Each independent Cached/Dynamic slot gets its **own** `<Suspense>` **directly in the page** — not nested inside a shared wrapper component
- Never group unrelated slots into one `<Suspense>` — it serializes streaming and defeats PPR
- Cached components can share a boundary only if they logically always load together

> ⚠️ **Common trap:** Creating a `PageContent` or `DynamicSection` wrapper that contains multiple independent slots under one `<Suspense>` looks organized but kills granular streaming. Each slot = its own `<Suspense>` at page level.

---

## Revalidation endpoint (prepare for backend webhooks)

```ts
// src/app/api/revalidate/route.ts
import { revalidateTag } from 'next/cache'
import { NextRequest } from 'next/server'

export async function POST(req: NextRequest) {
  const secret = req.nextUrl.searchParams.get('secret')
  if (secret !== process.env.REVALIDATION_SECRET) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const tag = req.nextUrl.searchParams.get('tag')
  if (!tag) return Response.json({ error: 'Missing tag' }, { status: 400 })

  revalidateTag(tag)
  return Response.json({ revalidated: true, tag })
}
```

Backend calls: `POST /api/revalidate?tag=product:123&secret=XXX`

---

## Verification

Run `next build` and check the route symbol:

| Symbol | Meaning | Expected for |
|---|---|---|
| `○` | Static | Fully static routes |
| `◐` | PPR | Routes with mixed Static + Cached/Dynamic |
| `λ` | Dynamic | Fully dynamic routes (all cookies/auth) |

**Checklist before finishing:**
- [ ] Every `'use cache'` function has `cacheTag()`
- [ ] Every Dynamic slot is inside its own `<Suspense>`
- [ ] `cacheComponents: true` in `next.config.ts` (not `experimental.ppr`)
- [ ] No `next: { revalidate: N }` on raw `fetch()` calls
- [ ] Revalidation endpoint exists (or marked TODO)
- [ ] `next build` shows `◐` for PPR routes

---

## after() — Non-blocking post-response work

Use `after()` for work that should happen after the response is sent (analytics, logging, audit trails) without blocking streaming or TTFB.

```ts
import { after } from 'next/server'

export default async function Page() {
  after(async () => {
    // Runs after response is fully sent — does not block streaming
    await logPageView()
    await trackAnalyticsEvent()
  })

  return <PageContent />
}
```

> ⚠️ `after()` is NOT a replacement for `'use cache'`. Use it for side effects only, not data fetching.
> ⚠️ Do not use `after()` inside cached functions — it will throw.

---

## Parallel fetch inside cached components

When a cached component needs multiple independent data sources, fetch them in parallel with `Promise.all`. Never `await` them sequentially.

```ts
// ❌ Sequential — unnecessarily slow
async function ProductPage({ id }: { id: string }) {
  'use cache'
  const product = await fetchProduct(id)
  const related = await fetchRelated(id)
  const reviews = await fetchReviews(id)
  // ...
}

// ✅ Parallel — all three fire at once
async function ProductPage({ id }: { id: string }) {
  'use cache'
  cacheTag(`product:${id}`)
  cacheLife('hours')

  const [product, related, reviews] = await Promise.all([
    fetchProduct(id),
    fetchRelated(id),
    fetchReviews(id),
  ])
  // ...
}
```

Rule: if fetches don't depend on each other's results, use `Promise.all`.

---

## generateMetadata + caching

`generateMetadata` runs on the server and can use cached functions. Apply `'use cache'` to the underlying fetch, not to `generateMetadata` itself.

```ts
// ✅ Cache the data fetch, not generateMetadata
async function getProduct(id: string) {
  'use cache'
  cacheTag(`product:${id}`)
  cacheLife('hours')
  return fetchProductFromApi(id)
}

export async function generateMetadata({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id)
  return {
    title: product.name,
    description: product.description,
  }
}
```

> ⚠️ Do NOT add `'use cache'` directly to `generateMetadata` — it is a framework convention function and caching it will cause issues.
> If the same `getProduct` function is used in both `generateMetadata` and the page component, `React.cache()` deduplicates it within the same request.

---

## Layout PPR behavior

Layouts are **always treated as static** by Next.js PPR unless they explicitly call dynamic functions (`cookies()`, `headers()`, `searchParams`). PPR applies at the **page level**, not the layout level.

| Where | PPR applies? |
|---|---|
| `layout.tsx` | No — layouts are always static |
| `page.tsx` | Yes — PPR boundary is here |
| Shared components rendered by layout | Only if called from a page Suspense slot |

**Consequence:** If your layout calls `cookies()` or `headers()`, it opts the **entire route** into dynamic rendering — PPR cannot help. Move dynamic reads to the page level and isolate them in `<Suspense>`.

```tsx
// ❌ Dynamic read in layout — kills PPR for all child pages
export default async function Layout({ children }) {
  const theme = cookies().get('theme')  // opts entire route into dynamic
  return <div data-theme={theme}>{children}</div>
}

// ✅ Move cookie read to a client component or Suspense slot in the page
export default function Layout({ children }) {
  return <div>{children}</div>  // static shell
}
```

---

## Common mistakes

| Mistake | Fix |
|---|---|
| `experimental: { ppr: true }` | Use `cacheComponents: true` (top-level) |
| `next: { revalidate: N }` on fetch | Use `'use cache'` + `cacheLife()` |
| React `cache()` as the caching strategy | `cache()` deduplicates per-render only; add `'use cache'` for cross-request caching |
| One `<Suspense>` wrapping the whole page | Each independent slot = own `<Suspense>` at page level |
| `PageContent` wrapper with multiple slots inside one `<Suspense>` | Extract each slot as its own async component with its own `<Suspense>` directly in the page |
| No `cacheTag()` | Always add tags — you will need invalidation |
| Dynamic component outside `<Suspense>` | Entire route falls back to SSR |
