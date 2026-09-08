# Ant Marketplace Maintainer Instructions

This file owns repository-wide invariants. Skill behavior belongs in the relevant
`SKILL.md` or reference; user-facing summaries belong in `README.md` and `docs/`.

## Scope and structure

- Preserve unrelated changes. Implementation authority covers completion of the requested local scope and its routine technical decisions, repairs, review, checks, and recovery across phases and agents; delivery, destructive actions, migrations, and compatibility breaks need explicit authority. An explicit PR/MR Create/update request carries the delivery authority defined by `merge-request` for the already agreed repository scope.
- The plugin exposes exactly three public skills: `implementation-orchestrator`, `merge-request`, and `brand-design`.
- Keep the plugin instruction-only. Do not add a runtime, hooks, machine state, event log, lease protocol, compatibility reader, generated validator, or synthetic evaluation framework.
- Keep `CLAUDE.md` as the `@AGENTS.md` import; do not duplicate this contract.
- Preserve the brand corpus. `plugins/ant/skills/brand-design/assets/source/ant-brand.md` and its adjacent `manifest.json` are canonical.

## Orchestration invariants

- The shared lifecycle is owned by [`lifecycle.md`](plugins/ant/skills/implementation-orchestrator/references/lifecycle.md). Host models, tools, and preflights are owned by the active adapter.
- Root is the sole user-facing adjudicator and coordinates the run. The delegated integration owner writes scoped source, configuration, tests, and general documentation; the independent strong reviewer is read-only. Root writes only the scoped plan bundle and its progress/checkpoint files.
- Every child uses an explicit fresh isolated route capped at High. The assignment states ownership, checks, plan-directory read-only access, delegation permission, and reporting/escalation.
- The root-owned Git-tracked plan is authoritative. Native Goal handling follows the [shared lifecycle](plugins/ant/skills/implementation-orchestrator/references/lifecycle.md) and active host adapter; a Goal is a coordination aid, never a permission source or substitute for the plan. Preserve unrelated Goals and report absent, unavailable, unverified, and explicit-requirement states truthfully.
- `merge-request` exclusively owns PR/MR delivery and conflict resolution. Do not add aliases or duplicate those workflows.

## Instruction and documentation maintenance

- Follow [`docs/instruction-authoring.md`](docs/instruction-authoring.md) for instruction changes. Give each rule one canonical owner and link to it from summaries or routers.
- Add a public skill only for a distinct workflow. Public skills live at `plugins/ant/skills/<name>/SKILL.md`; UI metadata is optional in `agents/openai.yaml`.
- Keep `README.md`, `docs/skills.md`, `docs/install.md`, and `docs/orchestrator.md` aligned with current behavior. Historical release notes are immutable.
- Verify version-sensitive CLI, API, or host claims against current primary documentation or installed help.

## Delivery and validation

- Use `merge-request` for PR/MR Preview, Create/update, Observe/status, and Conflict resolution. Preview and Observe/status are read-only. Follow that skill's explicit Create/update authority for delivery; conflict preparation, readiness changes, merge, release, deployment, and history rewrite remain separate authorities.
- Use Conventional Commit titles and human-first English descriptions built from the final merge-base-to-`HEAD` snapshot. Keep failed or unrun checks visible.
- Run checks affected by the coherent change and choose one risk-appropriate final gate; repository-wide suites remain a maintainer/CI responsibility.
- Repository validation commands are:

  ```bash
  claude plugin validate .
  claude plugin validate ./plugins/ant
  jq empty .agents/plugins/marketplace.json .claude-plugin/marketplace.json plugins/ant/.claude-plugin/plugin.json plugins/ant/.codex-plugin/plugin.json
  ```

- Keep `plugins/ant/.claude-plugin/plugin.json`, `plugins/ant/.codex-plugin/plugin.json`, and `.claude-plugin/marketplace.json` `metadata.version` identical. Use semantic versioning; release or publication needs separate explicit authority.
