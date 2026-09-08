---
name: implementation-orchestrator
description: Use for features, fixes, refactors, migrations, remediation, or new applications that need a reviewed and verified implementation.
---

# Implementation Orchestrator

**Announce at start:** Say you are using the implementation orchestrator and will keep the workflow proportional to the task.

Use this skill for implementation work. For analysis or review, apply the shared [evidence and quality policy](references/lifecycle.md#evidence-and-quality), investigate and report without changing the repository. Keep implementation authority separate from delivery authority.

## Workflow

1. Read repository instructions, inspect the current worktree and contracts, and identify risks and affected checks.
2. Derive the original user goal, representative scenarios, observable completion criteria, and proportional outcome evidence before implementation or dispatch. If consequential user-owned intent or authority is not discoverable, ask only for that decision. Resolve routine in-scope technical choices from evidence; do not run a generic questionnaire.
3. Classify the request, choose continuity (in-place, accepted integrated replacement, or isolated handoff), and establish the root-owned plan at `docs/implementation-plans/YYYY/MM/<slug>/README.md` before tracked edits. Record the selected evidence and realistic states in the plan and owner/reviewer inputs. Use [new-application.md](references/new-application.md) only for a new application or major app-like surface.
4. For Codex, read [codex.md](references/codex.md) and apply its Goal handling and route preflight. For Claude Code, read [claude.md](references/claude.md). The shared lifecycle is in [lifecycle.md](references/lifecycle.md); load its evidence and quality policy for analysis/review and the full lifecycle for tracked orchestration, recovery, or candidate validation.
5. Dispatch one integration owner with a complete routing capsule. Add disjoint workers only when ownership is clear and the active adapter permits them. Every child is fresh, isolated, explicitly routed, and capped at High; the plan directory is read-only to children.
6. The owner implements and consolidates scoped source, configuration, tests, and general documentation. Root remains coordination-only; an independent strong reviewer reads the candidate and never fixes it.
7. Verify the selected outcome evidence and realistic states after coherent changes. Review findings or tracked mutations require affected re-review and refreshed evidence. Freeze one exact candidate and verify one risk-appropriate broad gate.
8. Classify the requested endpoint as implementation-only, draft PR/MR create/update, or explicitly merge-ready. Apply the endpoint completion and final-reporting criteria in the shared [lifecycle](references/lifecycle.md); provider descriptions and finite observation belong to [merge-request](../merge-request/SKILL.md). Root reports the endpoint-specific outcome separately from provider delivery.

## Ownership

- Root is the sole user-facing adjudicator and owns plan checkpoints, decisions, Goal lifecycle, recovery, freeze, final verification, retrospective, and readiness.
- The integration owner writes the requested implementation. Children report evidence and proposed deltas to their parent; they do not edit the plan directory or address the user.
- The independent strong reviewer reports findings to the owner/root and does not write fixes.
- Codex Goal behavior follows [codex.md](references/codex.md); shared Goal and authority rules follow [lifecycle.md](references/lifecycle.md).

Follow the shared lifecycle for authority, routing, candidate identity, handoff provenance, and endpoint-specific final reporting.
