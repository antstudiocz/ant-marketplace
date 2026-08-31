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
- Keep the orchestrator semantic core host-neutral. Shared policy routes by strong/balanced/fast capability and proportional supported effort; exact models, aliases, and environment preflights belong only in its two adapters, internal Claude profiles, and active documentation.
- Claude root runs `best` at `max`; children use the five plugin-scoped Opus/Sonnet profiles after the adapter's override preflight, with `ant:fast` routed to Sonnet Low. Codex root model and effort are developer-selected; `gpt-5.6-sol` at High is recommended guidance only. All Codex children use explicit Sol/Luna model and effort selectors with `fork_turns="none"`, and there is no Terra fallback. Every child remains capped at High.
- Root is coordination-only and the sole user-facing adjudicator during orchestration. A native delegated integration owner performs tracked edits; an independent strong reviewer performs final review.
- Routine operational communication, worker/tester coordination, repairs, targeted checks, and re-review remain inside the workstream. The integration owner consolidates worker/tester deltas; root receives settled compact deltas or material escalations. The reviewer may send actionable findings/fix evidence to the integration owner but never writes fixes.
- Every child assignment carries a recursive routing capsule covering the exact active-adapter route/effort, fresh isolated context, ownership boundaries, nested-delegation permission and permitted routes, and report/escalation topology. Nested children receive it recursively and never inherit conversational history.
- Required child and nested-child route/model/profile/effort/fresh-context selection and dispatch are automatic internal execution decisions under established implementation authority, never separate approval or confirmation gates. Invoke required routes directly without asking the user to approve, confirm, or type “yes” merely to permit routing. Preserve genuine host-native approval semantics and surface them normally; if a required route or selector is unavailable or unenforceable, fail closed and report the limitation and paused scope without soliciting ceremonial consent.
- Claude root route verification uses authoritative host/session/task metadata or explicit current host selection, never model self-identification; its mandatory exact route still blocks tracked-writer dispatch when it cannot be verified.
- Codex root selection remains developer-owned. All child routes remain explicit and enforceable.
- Codex creates an immutable native Goal after the stable Plan and before tracked-writer dispatch. Claude native goal support is optional and its absence must not block writes.
- Never replace, complete, or block an unrelated unfinished Goal. On Codex Goal collision or material delta, pause affected work; root asks whether to finish the current Goal and queue a follow-on task or use native user/system controls to end/resolve it, and creates a new Goal only after native state reports no unfinished Goal. Stable changes stay in Plan/assignments.
- Use the host-native Plan as the single live, user-visible TODO checklist for every active implementation run: establish it before tracked edits, keep it concise and proportional at phase/wave level, and use explicit pending, in_progress, and completed transitions with exactly one top-level item in_progress while work is active. Root updates it at phase/wave start and completion, stable in-scope Plan changes, recovery/resume, and applicable review, broad-gate, and delivery transitions; native agent/thread state remains the concurrency source. Reconcile the Plan against authoritative Goal, git, agent, and report evidence before resuming, and mark items completed only when matching evidence exists. Do not create a custom TODO/PLAN.md file, status ledger, or persisted substitute. Analysis-only work may present a requested Plan but remains read-only and does not enter implementation lifecycle state.
- Any tracked mutation after independent review invalidates affected review evidence and all candidate-bound broad-gate and smoke evidence. Require targeted checks, same-reviewer affected-area review where available, a newly frozen candidate, and one refreshed risk-appropriate broad gate; root directly verifies that gate. The orchestrator's candidate-bound validation policy and CI-substitution conditions are defined in `plugins/ant/skills/implementation-orchestrator/references/lifecycle.md`.
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
