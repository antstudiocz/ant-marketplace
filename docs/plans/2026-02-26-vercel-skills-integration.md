# Vercel Labs Skills Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Copy `next-best-practices`, `react-best-practices`, and `nextjs-ppr` into the ant marketplace so all team members get them via `/plugin update ant`.

**Architecture:** Skills are copied from `~/.claude/skills/` into `lematodefuk-marketplace/skills/`, registered in `marketplace.json`, and distributed via the existing ant plugin release mechanism. The `nextjs-ppr` skill is enhanced before copying. A global `load-fe-skills` command replaces the project-local one in discomp.

**Tech Stack:** Claude Code plugin system, GitHub releases, `npx skills` CLI

---

### Task 1: Update skills from vercel-labs via npx

**Files:**
- Modify (in-place): `~/.claude/skills/next-best-practices/`
- Modify (in-place): `~/.claude/skills/vercel-react-best-practices/`

**Step 1: Update next-best-practices**

```bash
npx skills add https://github.com/vercel-labs/next-skills --skill next-best-practices
```

Expected: downloads latest version of `next-best-practices` into `~/.claude/skills/next-best-practices/`

**Step 2: Update vercel-react-best-practices**

```bash
npx skills add https://github.com/vercel-labs/agent-skills --skill react-best-practices
```

Expected: downloads latest version into `~/.claude/skills/vercel-react-best-practices/` (or similar path — check what name the CLI uses)

**Step 3: Verify files updated**

```bash
ls -la ~/.claude/skills/next-best-practices/
ls -la ~/.claude/skills/vercel-react-best-practices/
```

**Step 4: Commit note**

No commit yet — changes are outside the marketplace repo.

---

### Task 2: Improve nextjs-ppr skill

**Files:**
- Modify: `~/.claude/skills/nextjs-ppr/SKILL.md`

Add four new sections to the skill **before** the "Common mistakes" table. Insert after the "Verification" section:

**Step 1: Add `after()` API section**

```markdown
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
```

**Step 2: Add parallel fetch section**

```markdown
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
```

**Step 3: Add generateMetadata section**

```markdown
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
```

**Step 4: Add layout PPR behavior section**

```markdown
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
```

**Step 5: Verify the skill reads well end-to-end**

Read `~/.claude/skills/nextjs-ppr/SKILL.md` and confirm the four sections are present and correctly placed before the "Common mistakes" table.

**Step 6: No commit yet** — file is outside the marketplace repo.

---

### Task 3: Copy skills into marketplace

**Files:**
- Create: `skills/next-best-practices/` (directory + all files)
- Create: `skills/react-best-practices/` (directory + all files, renamed from vercel-react-best-practices)
- Create: `skills/nextjs-ppr/` (directory + SKILL.md)

**Step 1: Copy next-best-practices**

```bash
cp -r ~/.claude/skills/next-best-practices ~/Sites/lematodefuk-marketplace/skills/next-best-practices
```

**Step 2: Copy vercel-react-best-practices as react-best-practices**

```bash
cp -r ~/.claude/skills/vercel-react-best-practices ~/Sites/lematodefuk-marketplace/skills/react-best-practices
```

**Step 3: Update the name in SKILL.md frontmatter**

In `skills/react-best-practices/SKILL.md`, change:
```yaml
name: vercel-react-best-practices
```
to:
```yaml
name: react-best-practices
```

**Step 4: Copy nextjs-ppr**

```bash
cp -r ~/.claude/skills/nextjs-ppr ~/Sites/lematodefuk-marketplace/skills/nextjs-ppr
```

**Step 5: Verify all three skill directories exist**

```bash
ls ~/Sites/lematodefuk-marketplace/skills/next-best-practices/
ls ~/Sites/lematodefuk-marketplace/skills/react-best-practices/
ls ~/Sites/lematodefuk-marketplace/skills/nextjs-ppr/
```

---

### Task 4: Register skills in marketplace.json

**Files:**
- Modify: `.claude-plugin/marketplace.json`

**Step 1: Add three entries to the skills array**

Add to the end of the `skills` array in `.claude-plugin/marketplace.json`:

```json
"./skills/next-best-practices",
"./skills/react-best-practices",
"./skills/nextjs-ppr"
```

The full array should end with:
```json
"./skills/skeleton-loading-states",
"./skills/next-best-practices",
"./skills/react-best-practices",
"./skills/nextjs-ppr"
```

**Step 2: Verify JSON is valid**

```bash
cat ~/Sites/lematodefuk-marketplace/.claude-plugin/marketplace.json | python3 -m json.tool > /dev/null && echo "valid"
```

Expected: `valid`

---

### Task 5: Create load-fe-skills command

**Files:**
- Create: `commands/load-fe-skills.md`

**Step 1: Create the command file**

```markdown
---
description: "Load Next.js and React best practices skills for frontend work"
---

Load the following skills before doing any frontend work in this session:

1. Invoke the `ant:nextjs-ppr` skill — Partial Prerendering patterns, static/dynamic boundaries, Suspense granularity
2. Invoke the `ant:next-best-practices` skill — Next.js file conventions, RSC boundaries, async APIs, metadata, error handling
3. Invoke the `ant:react-best-practices` skill — React and Next.js performance optimization guidelines

After loading all three skills, confirm you're ready and ask what to work on.
```

**Step 2: Verify command file exists**

```bash
cat ~/Sites/lematodefuk-marketplace/commands/load-fe-skills.md
```

---

### Task 6: Remove project-local load-skills command

**Files:**
- Delete: `~/Sites/discomp/discomp-frontend/.claude/commands/load-skills.md`

**Step 1: Delete the file**

```bash
rm ~/Sites/discomp/discomp-frontend/.claude/commands/load-skills.md
```

**Step 2: Verify deleted**

```bash
ls ~/Sites/discomp/discomp-frontend/.claude/commands/
```

Expected: `load-skills.md` is gone, `review-guide.md` remains.

**Step 3: Commit the deletion in the discomp repo**

```bash
cd ~/Sites/discomp
git add discomp-frontend/.claude/commands/load-skills.md
git commit -m "chore: remove load-skills command (superseded by ant:load-fe-skills)"
```

---

### Task 7: Bump version and release

**Files:**
- Modify: `.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`

Current version: `7.3.4` → New version: `7.4.0` (minor bump — new skills added)

**Step 1: Update plugin.json**

Change `"version": "7.3.4"` to `"version": "7.4.0"` in `.claude-plugin/plugin.json`.

**Step 2: Update marketplace.json**

Change `"version": "7.3.4"` to `"version": "7.4.0"` in `.claude-plugin/marketplace.json` (inside `metadata`).

**Step 3: Verify both versions match**

```bash
grep '"version"' ~/Sites/lematodefuk-marketplace/.claude-plugin/plugin.json ~/Sites/lematodefuk-marketplace/.claude-plugin/marketplace.json
```

Expected: both show `7.4.0`.

**Step 4: Commit everything**

```bash
cd ~/Sites/lematodefuk-marketplace
git add -A
git commit -m "feat: add next-best-practices, react-best-practices, nextjs-ppr skills + load-fe-skills command (v7.4.0)"
```

**Step 5: Push and create GitHub release**

```bash
cd ~/Sites/lematodefuk-marketplace
git push origin master
gh release create v7.4.0 --title "v7.4.0" --notes "## Changes
- Add \`ant:next-best-practices\` skill (Next.js file conventions, RSC boundaries, async APIs)
- Add \`ant:react-best-practices\` skill (React/Next.js performance optimization from Vercel Engineering)
- Add \`ant:nextjs-ppr\` skill (PPR decision framework, improved with after(), parallel fetch, generateMetadata, layout behavior)
- Add \`/load-fe-skills\` command — loads all three frontend skills in one shot"
```

**Step 6: Verify release**

```bash
gh release view v7.4.0
```
