# Ant Marketplace Maintainer Instructions

## Communication And Scope

- Keep final responses concise and lead with outcome, material risks, checks, and next step.
- Investigate before conclusions. Analysis/review requests stay read-only; implementation requests authorize only in-scope local edits and non-destructive validation.
- Preserve unrelated work. Ask before destructive actions, external writes, delivery, material scope expansion, migrations, or compatibility breaks.
- Prefer the smallest durable fix. Do not hide failures by weakening checks, assertions, architecture, or compatibility.

## Repository Architecture

The plugin exposes exactly three public skills:

- `implementation-orchestrator` — end-to-end discovery, planning, delegated implementation, review, validation, and optional delivery coordination;
- `merge-request` — PR/MR Preview, Create/update, Observe/status, exact-head pipeline observation, and merge-conflict resolution;
- `brand-design` — `(ant)` brand direction, assets, implementation handoff, and visual QA.

```text
.claude-plugin/marketplace.json
.agents/plugins/marketplace.json
plugins/ant/
  .claude-plugin/plugin.json
  .codex-plugin/plugin.json
  agents/                  # Five internal Claude execution profiles
  skills/
    implementation-orchestrator/
    merge-request/
    brand-design/
```

- Keep orchestration instruction-only. Do not add a custom runtime, hooks, persisted state, event log, lease protocol, compatibility reader, generated validator, or synthetic eval framework.
- Keep the orchestrator semantic core host-neutral. Shared policy routes by strong/balanced/fast capability and proportional effort; exact routes and preflights belong in the active adapters and documentation.
- Keep every child capped at High and require the active adapter's explicit route and isolation rules.
- Root is coordination-only and the sole user-facing adjudicator during orchestration. A native delegated integration owner performs tracked edits; an independent strong reviewer performs final review.
- Keep child routing, ownership, review, and escalation inside the orchestrator's recursive capsule; the integration owner writes and consolidates, while root adjudicates and verifies.
- Treat authoritative host-native Plan and Goal state as lifecycle gates. Prose status, narrated checklists, and assignments are not substitutes. Plan/Goal and candidate-bound rules are in [`lifecycle.md`](plugins/ant/skills/implementation-orchestrator/references/lifecycle.md); Codex operations are in [`codex.md`](plugins/ant/skills/implementation-orchestrator/references/codex.md).
- Preserve unrelated Goals and material objective changes; never clear a collision by completing or blocking the Goal. Follow the canonical lifecycle and active-host adapter.
- `merge-request` exclusively owns both PR/MR delivery and merge-conflict resolution. Do not add public aliases or duplicate delivery workflows.
- Preserve all usable brand assets. The canonical brand manual is `plugins/ant/skills/brand-design/assets/source/ant-brand.md` with `manifest.json` beside it.

## Skill Maintenance

- Add a public skill only for a distinct workflow/domain entry point. Prefer a reference under an existing skill when the topic belongs there.
- Public skills require `plugins/ant/skills/<name>/SKILL.md`; optional Codex UI metadata belongs in `agents/openai.yaml`.
- Do not register individual skills in marketplace catalogs; plugin discovery uses `plugins/ant/.codex-plugin/plugin.json` and the Claude plugin root.
- Do not create same-name command aliases. Reference another public skill with its host-visible identifier.
- Keep comments and guidance focused on non-obvious intent, invariants, constraints, or tradeoffs.

## Documentation

- Keep `README.md`, `docs/skills.md`, `docs/install.md`, and `docs/orchestrator.md` aligned with current behavior.
- `CLAUDE.md` imports this file with `@AGENTS.md`; do not duplicate the contract.
- Historical release notes are immutable. Add a new release note for each release.
- For version-sensitive framework, SDK, API, CLI, or cloud claims, consult current primary documentation or installed source.

## Pull Requests

- Use the host-visible `merge-request` skill for every PR/MR Preview, Create/update, Observe/status, or Conflict resolution request.
- Observe/status is read-only: it may inspect provider metadata and boundedly observe the existing exact head, but never mutates the worktree/provider or retries/repairs failures. Remote conflict reproduction may use the merge-generated index/worktree state under explicit conflict intent; that is not `git add` authority. Staging, commit, and push remain separate.
- Titles use Conventional Commit style. Descriptions default to English and represent the final merge-base-to-`HEAD` snapshot.
- Keep the visible description human-first: summary, rationale, and material impact/risk; collapse only useful technical and verification detail while keeping status and gaps truthful.

## Validation And Release

During implementation, run checks affected by the coherent change and apply the orchestrator's risk-based candidate gate. Repository-wide validation remains a maintainer/CI responsibility (including periodic/default-branch suites), not an automatic runtime requirement for every orchestration run. The repository's broad validation commands are:

```bash
claude plugin validate .
claude plugin validate ./plugins/ant
jq empty .agents/plugins/marketplace.json .claude-plugin/marketplace.json plugins/ant/.claude-plugin/plugin.json plugins/ant/.codex-plugin/plugin.json
```

Keep these versions identical:

- `plugins/ant/.claude-plugin/plugin.json`;
- `plugins/ant/.codex-plugin/plugin.json`;
- `.claude-plugin/marketplace.json` `metadata.version`.

Use semantic versioning: major for breaking changes, minor for new compatible functionality, patch for fixes/improvements. A release requires explicit delivery authority before commit, push, or `gh release create`; never add AI attribution or co-author trailers.

Users update Claude Code with marketplace/plugin update and reload commands. Codex users rerun the install command for `antstudiocz/ant-marketplace/plugins/ant` and restart/open a new session.
