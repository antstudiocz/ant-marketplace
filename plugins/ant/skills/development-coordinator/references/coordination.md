# Coordination records and handoffs

Use these short forms only when they reduce ambiguity. Keep the initiative's existing record and team's existing tools when they already capture the same information.

Use “realization chat” for a separate user-owned task carrying a workstream; an internal delegated agent is a different role and follows its parent-agent route.

## Chat titles and status icons

Treat the semantic title and its leading status icon as separate controls:

- Propose a short, understandable base title that names the actual task. Prefix `[MODULE]` only when the effort is exclusively about one module. Always get the user's approval or alternative before applying a proposed semantic/base title, including when first naming a chat; proposing a title does not apply it.
- When the user's authorization covers status-label management, each tracked realization chat owns and updates its own one leading icon as meaningful verified progress changes. Carry the original user authorization and its bounds in the handoff; a coordinator or callback cannot create or expand it. Preserve the approved base title, use the host's native rename tool, and do not ask again for each authorized icon-only update.
- When reconciling a relevant status report, the central coordinator checks the reported chat's icon and corrects a forgotten or stale icon as a fallback under that same authorization. This is event-driven reconciliation, not recurring polling; do not create a monitoring schedule.
- Change the icon only when a meaningful verified status report or authoritative evidence supports it. If the host or state cannot be verified, record it as unknown. Do not guess from stale evidence, use recurring polling, or revive archived chats.

| Icon | Use when verified state is |
|---|---|
| 🔎 | Analysis is active, including active investigation. |
| 🛠️ | Implementation is active. |
| 🧪 | Final tests/review are active, or CI is pending/running. CI progress is qualification, not a blocker or user wait. |
| ✅ | The agreed endpoint is merge-ready. This does not mean merged or deployed. Routine merge approval can remain pending while the icon stays ✅. |
| ⏳ | The next step needs an actual user decision, approval, or input. This includes completed analysis awaiting a decision to implement, a draft or implementation-only endpoint awaiting the user's next decision, or a direction such as “don't implement yet; let's discuss and wait for me.” Preserve the analysis/result and exact endpoint in the record; ⏳ does not imply merge-readiness. |
| 🛑 | A verified condition genuinely prevents progress. A running CI job alone is not blocked. |
| 💤 | The user explicitly deferred the whole scope represented by the chat until later. Keep it paused until new user instruction; never resume it automatically. A request to wait for discussion or a decision about implementation is ⏳, not 💤. |

Apply state precedence in this order: explicit deferral of the whole chat scope; a verified merge-ready endpoint awaiting only routine merge approval (✅); a genuine blocker or actual user decision/input wait; otherwise the active phase. When a blocker and a user wait coincide, use ⏳ if user input is the condition that will allow progress; otherwise use 🛑 for the independent blocker. If merge readiness is invalidated by a confirmed new finding, changed scope, or conflict, withdraw ✅ and show the verified current phase. A ready endpoint awaiting only the routine merge decision remains ✅, not ⏳. After an achieved endpoint that is neither merge-ready nor waiting on the user, and after a verified merge with no active follow-up, remove the leading status icon and record the actual outcome in the initiative checkpoint. If authorized follow-up continues in a phase with no matching icon in this glossary, leave the icon off and record the real phase; do not map it to a nearby state. Never use ✅ as a generic completed, merged, or deployed label. Icon changes convey coordination state only; they never authorize merge, deployment, or task closure.

## Restricted CLI authentication

A no-sign-in result from a restricted sandbox describes that execution environment; it does not establish that the user's account is signed out. Diagnose it with a read-only CLI authentication/status check or equivalent non-mutating provider-access check, using the same CLI outside the restricted sandbox in a host-supported context with access to the normal sign-in state, already permitted or approved by the host. Report only the resulting state (signed in, signed out, unknown, or denied); do not expose account identifiers.

If that check or context is unavailable or denied, record the auth state as unknown or denied and leave dependent work pending. Ask the user to sign in only after a read-only check outside the restricted sandbox confirms signed-out state. Never rerun the original or any effectful operation to test authentication. Retry an effectful operation only when existing user authority covers it and authoritative evidence confirms the earlier attempt had no effect. This guidance does not authorize elevated execution, external effects, or bypassing a denied action.

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
