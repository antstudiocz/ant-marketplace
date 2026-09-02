# Implementation

## Scoped files and responsibilities

The integration owner may edit the scoped instruction and documentation files below. Root owns this plan directory only. No product/runtime code is in scope.

- `AGENTS.md`
- `plugins/ant/skills/implementation-orchestrator/SKILL.md`
- `plugins/ant/skills/implementation-orchestrator/references/lifecycle.md`
- `plugins/ant/skills/implementation-orchestrator/references/codex.md`
- `plugins/ant/skills/implementation-orchestrator/references/claude.md`
- `plugins/ant/skills/implementation-orchestrator/references/new-application.md`
- `README.md`, `docs/skills.md`, `docs/install.md`, `docs/orchestrator.md`
- `.claude-plugin/marketplace.json`, `plugins/ant/.claude-plugin/plugin.json`, `plugins/ant/.codex-plugin/plugin.json`
- `docs/releases/13.0.0.md`
- `docs/implementation-plans/2026/09/orchestrator-durable-planning/README.md`
- `docs/implementation-plans/2026/09/orchestrator-durable-planning/specification.md`
- `docs/implementation-plans/2026/09/orchestrator-durable-planning/decisions.md`
- `docs/implementation-plans/2026/09/orchestrator-durable-planning/implementation.md`
- `docs/implementation-plans/2026/09/orchestrator-durable-planning/progress.md`

## Work waves

1. Replace shared contract and host adapters; remove mandatory native Plan gate. **Complete.**
2. Align user documentation and new-application intake. **Complete.**
3. Create release/version updates and verify exactly three public skills. **Complete.**
4. Run targeted checks, independent review, repair, and affected-area re-review. **Complete.**
5. Assign the frozen content an exact commit SHA, run the single local broad gate, perform the root retrospective, and complete authorized Draft PR delivery. **In progress.**

## Targeted checks

- `git diff --check`
- `jq empty .agents/plugins/marketplace.json .claude-plugin/marketplace.json plugins/ant/.claude-plugin/plugin.json plugins/ant/.codex-plugin/plugin.json`
- `rg` audit of active instructions/docs (excluding `docs/releases`) for mandatory `update_plan`/native Plan gates and public-skill count
- internal-link and manifest/version consistency review

The integration owner must not run the two broad `claude plugin validate` commands. After independent review and the content-preserving candidate commit, root must run those two commands plus manifest JSON parsing exactly once as the single composite local broad gate.
