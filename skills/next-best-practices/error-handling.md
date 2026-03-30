# Error Handling

Handle errors gracefully in Next.js applications.

Reference: https://nextjs.org/docs/app/getting-started/error-handling

## Error Boundaries

### `error.tsx`

Catches errors in a route segment and its children:

```tsx
"use client";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  );
}
```

**Important:** `error.tsx` must be a Client Component.

### `global-error.tsx`

Catches errors in root layout:

```tsx
"use client";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html>
      <body>
        <h2>Something went wrong!</h2>
        <button onClick={() => reset()}>Try again</button>
      </body>
    </html>
  );
}
```

**Important:** Must include `<html>` and `<body>` tags.

## Server Actions: Navigation API Gotcha

**Do NOT wrap navigation APIs in try-catch.** They throw special errors that Next.js handles internally.

Reference: https://nextjs.org/docs/app/api-reference/functions/redirect#behavior

```tsx
'use server'

import { redirect } from 'next/navigation'
import { notFound } from 'next/navigation'

// Bad: try-catch catches the navigation "error"
async function createPost(formData: FormData) {
  try {
    const post = await db.post.create({ ... })
    redirect(`/posts/${post.id}`)  // This throws!
  } catch (error) {
    // redirect() throw is caught here - navigation fails!
    return { error: 'Failed to create post' }
  }
}

// Good: Call navigation APIs outside try-catch
async function createPost(formData: FormData) {
  let post
  try {
    post = await db.post.create({ ... })
  } catch (error) {
    return { error: 'Failed to create post' }
  }
  redirect(`/posts/${post.id}`)  // Outside try-catch
}

// Good: Re-throw navigation errors
async function createPost(formData: FormData) {
  try {
    const post = await db.post.create({ ... })
    redirect(`/posts/${post.id}`)
  } catch (error) {
    if (error instanceof Error && error.message === 'NEXT_REDIRECT') {
      throw error  // Re-throw navigation errors
    }
    return { error: 'Failed to create post' }
  }
}
```

Same applies to:

- `redirect()` - 307 temporary redirect
- `permanentRedirect()` - 308 permanent redirect
- `notFound()` - 404 not found
- `forbidden()` - 403 forbidden
- `unauthorized()` - 401 unauthorized

Use `unstable_rethrow()` to re-throw these errors in catch blocks:

```tsx
import { unstable_rethrow } from "next/navigation";

async function action() {
  try {
    // ...
    redirect("/success");
  } catch (error) {
    unstable_rethrow(error); // Re-throws Next.js internal errors
    return { error: "Something went wrong" };
  }
}
```

## Redirects

```tsx
import { redirect, permanentRedirect } from "next/navigation";

// 307 Temporary - use for most cases
redirect("/new-path");

// 308 Permanent - use for URL migrations (cached by browsers)
permanentRedirect("/new-url");
```

## Auth Errors

Trigger auth-related error pages:

```tsx
import { forbidden, unauthorized } from "next/navigation";

async function Page() {
  const session = await getSession();

  if (!session) {
    unauthorized(); // Renders unauthorized.tsx (401)
  }

  if (!session.hasAccess) {
    forbidden(); // Renders forbidden.tsx (403)
  }

  return <Dashboard />;
}
```

Create corresponding error pages:

```tsx
// app/forbidden.tsx
export default function Forbidden() {
  return <div>You don't have access to this resource</div>;
}

// app/unauthorized.tsx
export default function Unauthorized() {
  return <div>Please log in to continue</div>;
}
```

## Not Found

### 404 is a Route Contract, Not a UI Detail

Treat missing content as part of the route contract from the start.

- Missing or non-renderable content must end in `notFound()`.
- Do not return a 404-looking component from a normal `page.tsx` branch.
- A branded 404 UI must be rendered via `not-found.tsx`, not by rendering a fallback page with HTTP `200`.
- Do not postpone real 404 behavior as a later SEO or routing cleanup.

Use this distinction:

- missing, invalid, unpublished, inaccessible, or locale-missing content -> `notFound()`
- unexpected operational failure -> throw, then let `error.tsx` or `global-error.tsx` handle it

If you blur these two cases, you get false 404s, broken monitoring, and route architectures that need expensive rewrites later.

### `not-found.tsx`

Custom 404 page for a route segment:

```tsx
export default function NotFound() {
  return (
    <div>
      <h2>Not Found</h2>
      <p>Could not find the requested resource</p>
    </div>
  );
}
```

### Triggering Not Found

```tsx
import { notFound } from "next/navigation";

export default async function Page({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const post = await getPost(id);

  if (!post) {
    notFound(); // Renders closest not-found.tsx
  }

  return <div>{post.title}</div>;
}
```

### What NOT to Do

```tsx
// Bad: Branded fallback, but the route still returns HTTP 200
export default async function Page({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const post = await getPost(id);

  if (!post) {
    return <NotFoundPage />;
  }

  return <div>{post.title}</div>;
}
```

This looks correct in the browser, but the route was successfully rendered, so it is not a real HTTP `404`.

## Error Hierarchy

Errors bubble up to the nearest error boundary:

```
app/
├── error.tsx           # Catches errors from all children
├── blog/
│   ├── error.tsx       # Catches errors in /blog/*
│   └── [slug]/
│       ├── error.tsx   # Catches errors in /blog/[slug]
│       └── page.tsx
└── layout.tsx          # Errors here go to global-error.tsx
```
