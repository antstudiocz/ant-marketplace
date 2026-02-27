---
user-invocable: true
name: react-19
description: React 19 APIs — useOptimistic, useActionState, useFormStatus, use(), Form Actions, ref as prop. Use when working with async mutations, form submissions, optimistic UI, or upgrading from React 18.
---

# React 19 Patterns

> **⚠️ React 19+ only.** These APIs are not available in React 18 or earlier.

## APIs Overview

| API | Purpose |
|-----|---------|
| `useActionState` | Manage async action state — pending, error, result |
| `useOptimistic` | Immediate UI update before server confirms, auto-reverts on error |
| `useFormStatus` | Read pending state of parent `<form>` in a child component |
| `use()` | Read Promises and Context conditionally (inside loops, if-blocks) |
| Form Actions | Pass async function directly to `<form action>` |
| `ref` as prop | No more `forwardRef` — pass `ref` like any other prop |

---

## useActionState

Wraps an async action and returns `[state, dispatch, isPending]`.

```tsx
const [state, submitAction, isPending] = useActionState(
  async (previousState, formData) => {
    const error = await updateName(formData.get('name'))
    if (error) return error
    redirect('/profile')
    return null
  },
  null // initial state
)

return (
  <form action={submitAction}>
    <input name="name" />
    <button disabled={isPending}>Save</button>
    {state && <p className="text-red-500">{state}</p>}
  </form>
)
```

**Rules:**
- First argument of the action is always `previousState` (use `_` if unused)
- `isPending` is `true` from dispatch until the final state update commits
- Form resets automatically after successful submission
- Use with Server Actions in Next.js: mark action `"use server"`

---

## useOptimistic

Immediately show expected UI — auto-reverts if action fails.

```tsx
// Simple value
const [optimisticName, setOptimisticName] = useOptimistic(currentName)

// With reducer (for lists or complex state)
const [optimisticMessages, addOptimistic] = useOptimistic(
  messages,
  (state, newMessage) => [...state, { text: newMessage, sending: true }]
)
```

**Full example — optimistic like button:**
```tsx
function LikeButton({ isLiked }: { isLiked: boolean }) {
  const [liked, setLiked] = useState(isLiked)
  const [optimisticLiked, setOptimisticLiked] = useOptimistic(liked)

  function handleClick() {
    startTransition(async () => {
      setOptimisticLiked(!optimisticLiked)
      const result = await toggleLike(!optimisticLiked)
      setLiked(result)
    })
  }

  return (
    <button onClick={handleClick}>
      {optimisticLiked ? '❤️' : '🤍'}
    </button>
  )
}
```

**Full example — optimistic list (messages):**
```tsx
async function formAction(formData: FormData) {
  addOptimistic(formData.get('message') as string)
  formRef.current?.reset()
  await sendMessage(formData)
}
```

**Rules:**
- Always wrap `setOptimistic` + async action inside `startTransition`
- Optimistic state auto-reverts when the real state settles
- Use the reducer form (`useOptimistic(state, reducer)`) for lists
- Never use optimistic state as the source of truth — it's display-only

---

## useFormStatus

Reads the **parent** `<form>`'s pending state from a child component. Must be called inside a component that is a child of a `<form>`.

```tsx
// SubmitButton.tsx — child component
import { useFormStatus } from 'react-dom'

export function SubmitButton({ label }: { label: string }) {
  const { pending } = useFormStatus()
  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Saving...' : label}
    </button>
  )
}

// Usage
<form action={submitAction}>
  <input name="email" />
  <SubmitButton label="Subscribe" />
</form>
```

**Rules:**
- Import from `react-dom`, not `react`
- The component calling `useFormStatus` must be **inside** the `<form>` — not the same component that renders the form
- `pending` covers the full duration of the form action
- Also exposes `data`, `method`, `action` from the form submission

---

## Form Actions

Pass an async function directly to `<form action>` or `<button formAction>`.

```tsx
// No event.preventDefault() needed — React handles it
async function createPost(formData: FormData) {
  'use server' // Next.js Server Action
  const title = formData.get('title') as string
  await db.posts.create({ title })
  revalidatePath('/posts')
}

export default function NewPostForm() {
  return (
    <form action={createPost}>
      <input name="title" placeholder="Post title" />
      <button type="submit">Create</button>
    </form>
  )
}
```

**Multiple actions with `formAction`:**
```tsx
<form action={saveAction}>
  <input name="title" />
  <button type="submit">Save</button>
  <button formAction={deleteAction}>Delete</button>
</form>
```

**Rules:**
- Form resets automatically after the action completes
- Combine with `useActionState` for error/pending handling
- Combine with `useOptimistic` for immediate feedback

---

## use()

Read a Promise or Context — works inside conditions and loops (unlike `useContext` and `use` of Promises).

```tsx
// Reading context conditionally
function Greeting({ showName }: { showName: boolean }) {
  if (showName) {
    const user = use(UserContext) // valid inside an if-block
    return <p>Hello, {user.name}</p>
  }
  return <p>Hello!</p>
}

// Reading a Promise (must be created outside the component)
function PostContent({ postPromise }: { postPromise: Promise<Post> }) {
  const post = use(postPromise) // suspends until resolved
  return <article>{post.content}</article>
}

// Wrap with Suspense + ErrorBoundary
<ErrorBoundary fallback={<p>Error loading post</p>}>
  <Suspense fallback={<Skeleton />}>
    <PostContent postPromise={fetchPost(id)} />
  </Suspense>
</ErrorBoundary>
```

**Rules:**
- `use(Context)` replaces `useContext()` — preferred in React 19
- `use(Promise)` suspends the component — always wrap in `<Suspense>`
- The Promise must be created **outside** the component (e.g. in a Server Component and passed as prop), otherwise a new Promise is created on every render
- Cannot be used inside try/catch — use ErrorBoundary instead

---

## ref as prop (no more forwardRef)

In React 19, `ref` is a regular prop. `forwardRef` is no longer needed.

```tsx
// React 18 — old way
const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, ...props }, ref) => (
    <label>
      {label}
      <input ref={ref} {...props} />
    </label>
  )
)

// React 19 — new way
function Input({ label, ref, ...props }: InputProps & { ref?: React.Ref<HTMLInputElement> }) {
  return (
    <label>
      {label}
      <input ref={ref} {...props} />
    </label>
  )
}
```

**Rules:**
- Remove `forwardRef` wrapper — accept `ref` directly in props
- `forwardRef` still works in React 19 but is deprecated
- Cleanup functions from refs are now supported: `return () => { /* cleanup */ }`

---

## Combining Patterns

**Form with full React 19 stack:**
```tsx
'use client'

import { useActionState, useOptimistic } from 'react'
import { useFormStatus } from 'react-dom'
import { updateProfile } from './actions'

function SaveButton() {
  const { pending } = useFormStatus()
  return <button disabled={pending}>{pending ? 'Saving...' : 'Save'}</button>
}

export function ProfileForm({ user }: { user: User }) {
  const [optimisticName, setOptimisticName] = useOptimistic(user.name)
  const [error, formAction, isPending] = useActionState(
    async (_: string | null, formData: FormData) => {
      const name = formData.get('name') as string
      setOptimisticName(name)
      return await updateProfile(name) // returns error string or null
    },
    null
  )

  return (
    <form action={formAction}>
      <p>Name: <strong>{optimisticName}</strong></p>
      <input name="name" defaultValue={user.name} />
      <SaveButton />
      {error && <p className="text-red-500">{error}</p>}
    </form>
  )
}
```

---

## When to Use What

| Situation | Use |
|-----------|-----|
| Form with loading + error state | `useActionState` |
| Immediate UI before server responds | `useOptimistic` |
| Disable submit button while submitting | `useFormStatus` in child component |
| Read context conditionally | `use(Context)` |
| Stream async data with Suspense | `use(Promise)` |
| Pass ref to custom component | `ref` as prop directly |
| Multiple form actions (save vs delete) | `formAction` on `<button>` |
