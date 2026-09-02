# Decisions

## Settled

1. **Integrated replacement.** This branch is dedicated to the redesign, and the old mandatory native Plan contract is removed rather than retained as a fallback or compatibility shim.
2. **Git-tracked plan.** The stable path is `docs/implementation-plans/2026/09/orchestrator-durable-planning/README.md`; supporting documents keep detail complementary.
3. **No native Plan dependency.** Screenshots revealed that orchestration hard-blocked when `update_plan` was absent. The user explicitly wants no native Plan dependency, so native Plan UI is optional/non-authoritative and omitted from required gates.
4. **Goal remains.** Goal is working/enabled and must remain linked to the plan README. Codex requires matching Goal safety; Claude Goal stays optional.
5. **Goal operations.** Current Codex Goal tools expose create/read plus terminal closure, not explicit step mutation. Durable plan files carry progress; `update_goal` remains terminal-only.
6. **Authority split.** Root exclusively owns user dialogue, material decisions, durable-plan/progress writes, Goal lifecycle/sync, phase status, recovery, final gate verification, retrospective, readiness, and closure. The integration owner writes and consolidates implementation files. Children read plan docs and report proposed deltas; they cannot edit plan directories after bootstrap. Independent strong review never writes fixes.
7. **Public surface.** Exactly three public skills remain: `implementation-orchestrator`, `merge-request`, and `brand-design`.
8. **Version.** This breaking workflow replacement is version 13.0.0; all three version-bearing manifests and the README release pointer must align, while historical notes remain immutable.

## Open questions

None. Any newly discovered material outcome, public-contract, security, migration, or authority question must pause affected work and be resolved by root/user; it must not be silently appended here.
