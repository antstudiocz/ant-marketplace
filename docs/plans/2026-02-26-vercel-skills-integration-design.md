# Design: Integrate Vercel Labs Skills into Ant Marketplace

**Date:** 2026-02-26

## Goal

Distribute `next-best-practices`, `react-best-practices`, and `nextjs-ppr` as first-class ant skills so all team members get them via `/plugin update ant` — without needing to install them separately via `npx skills add`.

## What We're Building

### 1. Copy Vercel Labs skills into ant marketplace

Update the three skills to latest versions first, then copy into `lematodefuk-marketplace/skills/`:

| Source (`~/.claude/skills/`) | Destination | Skill name |
|---|---|---|
| `next-best-practices/` | `skills/next-best-practices/` | `ant:next-best-practices` |
| `vercel-react-best-practices/` | `skills/react-best-practices/` | `ant:react-best-practices` |
| `nextjs-ppr/` | `skills/nextjs-ppr/` | `ant:nextjs-ppr` |

The `vercel-react-best-practices` → `react-best-practices` rename drops the redundant vendor prefix.

### 2. Improve `ant:nextjs-ppr` skill

Add four missing sections to the PPR skill before copying:

- **`after()` API** — non-blocking post-response operations (analytics, logging) without blocking streaming
- **Parallel fetch pattern** — `Promise.all` for independent fetches inside cached components
- **`generateMetadata` + caching** — how page metadata should be handled with `'use cache'`
- **Layout PPR behavior** — layouts are always static unless they explicitly call dynamic functions; PPR boundary is at the page level

### 3. Register all three skills in `marketplace.json`

Add to the `skills` array alongside existing ant skills.

### 4. Create `commands/load-fe-skills.md` in ant marketplace

Replace the project-local `discomp-frontend/.claude/commands/load-skills.md` with a global ant command that invokes all three skills. Anyone with ant installed can use `/load-fe-skills` in any Next.js project.

### 5. Remove `discomp-frontend/.claude/commands/load-skills.md`

The project-local command is superseded by the global ant one.

### 6. Bump version and release

Minor version bump (new skills added). Update both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` to matching versions, then cut a GitHub release.

## Out of Scope

- Automatic sync from vercel-labs repos (no `.claude-plugin` structure on their end)
- `ant:next-skills` wrapper skill (deemed unnecessary — direct skills are clearer)
- Any changes to other ant skills

## Update Process (future)

When Vercel updates their skills, manually re-run `npx skills add` to update `~/.claude/skills/`, then copy the updated files into the marketplace and cut a new release.
