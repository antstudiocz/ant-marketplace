# Coordination records and handoffs

Use these short forms only when they reduce ambiguity. Keep the initiative's existing record and team's existing tools when they already capture the same information.

Use “realization chat” for a separate user-owned task carrying a workstream; an internal delegated agent is a different role and follows its parent-agent route.

## Initiative checkpoint

```markdown
# <Initiative>

Coordinator: <this coordinator chat/task identity>
Outcome: <observable result and agreed endpoint>
Scope: <in / out>
Goal: <native Goal identity and verified state, or absent / unavailable / unverified>
Record: <canonical Markdown path and its owner>
Decisions and authority: <decision, source, bounds, status>

| Chat | Owner | Status | Verified result | Next action |
|---|---|---|---|---|

Open questions or gaps: <decision, evidence, or explicit none>
Next coordinator action: <one action and its condition>
Updated: <date>
```

If a different active coordinator is recorded, confirm a handover with the user before taking ownership. For native Goal policy, use the canonical [Goal and continuity lifecycle](../../implementation-orchestrator/references/lifecycle.md#goal-and-continuity) and the active [Codex](../../implementation-orchestrator/references/codex.md) or [Claude Code](../../implementation-orchestrator/references/claude.md) adapter. Reconcile the coordinator's own Goal on continuation when the active adapter requires it; a realization chat verifies its own Goal under its adapter and authority.

## Handoff

```text
Outcome and owner:
Scope and endpoint:
Authority source and limits:
Dependencies and inputs:
Evidence/checks required:
Report to <verified destination>:
Stop when:
```

Keep the original human authorization source available to the receiving chat, especially for consequential effects. State proposed work as proposed until the user authorizes it. A handoff can carry existing authorization within its original bounds; it cannot add authority or bypass a refusal.

For a realization chat assigned implementation, include the user-approved outcome and request that it follow `implementation-orchestrator`; that chat owns its implementation plan, coding, review, and candidate verification. Ask the realization chat to return its exact candidate, decisive evidence, unresolved findings, endpoint state, and permitted next action. Route PR/MR work through `merge-request` under its own authority rules.

## Optional project task

Use Asana or another connected task system only when it is part of the agreed scope and the required connector and authority are available. Search for an existing task before proposing creation. Before creating a task or materially changing its description, scope, placement, or configured fields, settle those details with the user and preserve approved task text. For finish-driven task status or comment actions, apply the [coordinator's authority rule](../SKILL.md#workflow) and record the original consent source and bounds. Ask only meaningful missing field questions, without a fixed questionnaire.

Keep the task description concise: what changes, why it matters, expected benefit, decisions or dependencies (with reasons), and what evidence will establish completion. Preserve approved description text. Put material delivery updates in comments rather than rewriting the approved scope. Record a deployment date only after confirmation. Do not infer coverage of every task or PR/MR from samples; establish the relevant inventory. After an authorized write, read back the task and verify its placement, configured fields, and current status. If the connector cannot confirm a value, leave it unknown.

For a meaningful status comment, state the user outcome, its verified state, relevant evidence, and any decision with its reason. Avoid technical dumps or duplicate comments. When deployment is in scope and authorized, record who deployed it, how it was verified, any material limitation, and the owner/action for follow-through. Say “deployed” only when current runtime evidence supports that state.

```text
Status: <verified outcome and state>
Evidence: <relevant source or link>
Decision/dependency: <what is needed and why, or none>
Deployment: <confirmed owner/date, verification, and limitation, or omit>
Follow-through: <owner and action, or none>
```

## Closeout

Report the endpoint in its actual state and link the relevant checkpoint or task when available. Separate verified facts from hypotheses and unknowns. Name required evidence that is still missing and the next action that is already authorized. Do not call an umbrella initiative complete while its agreed work remains open.
