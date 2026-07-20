# Rule Ownership Manifest

Every normative rule has one owner. Consumers may link to the owner and add role-specific mechanics, but must not restate a competing policy.

| Rule id | Normative owner | Main consumers | Coverage |
|---|---|---|---|
| `IO-LIFECYCLE` | `references/lifecycle.md` | entrypoint, all roles | DOD-07 |
| `IO-VOCABULARY` | `references/policies/vocabulary.md` | all references | policy audit |
| `IO-AUTHZ-1.0` | `references/policies/approval-policy.md` | lifecycle, adapters, delivery | DOD-08, DOD-17 |
| `IO-EVIDENCE` | `references/policies/evidence-policy.md` | planner, lead, reviewer, handoff | DOD-09 |
| `IO-ADAPTIVE-REASONING` | `references/policies/reasoning-policy.md` | routing, adapters, all delegated roles | adaptive reasoning |
| `IO-REVIEW-MANIFEST` | `references/policies/review-manifest.md` | lead, reviewer | DOD-09 |
| `IO-ROUTING` | `references/runtime/capability-routing.md` | lifecycle, adapters, role cards | DOD-02, DOD-03, DOD-06 |
| `IO-CODEX-ADAPTER` | `references/runtime/hosts/codex.md` | Codex runtime | DOD-04 |
| `IO-CLAUDE-ADAPTER` | `references/runtime/hosts/claude-code.md` | Claude Code runtime | DOD-05, DOD-06 |
| `IO-ROLE-*` | matching `references/*-role.md` | task packets | role rubrics |
| `IO-TASK-SCOPED` | `references/task-scoped-execution.md` | plan writer, lead, reviewer | task review |
| `IO-PROMPT-SHAPES` | `references/templates/*.md` | lifecycle and roles | link lint |
| `IO-STATE` | `plugins/ant/contracts/orchestrator-state/*` | all producers/consumers | schema checks |
| `IO-MR` | `plugins/ant/skills/merge-request/SKILL.md` | delivery handoff | DOD-13 |

Templates contain placeholders, not authorization, reasoning, or evidence policy. Host adapters contain mechanics and reasoning translation, not lifecycle gates or complexity policy. Role cards contain responsibility and boundaries, not copies of shared policies.
