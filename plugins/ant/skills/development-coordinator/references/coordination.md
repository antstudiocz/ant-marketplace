# Coordination records and handoffs

Use these short forms only when they reduce ambiguity. Keep the initiative's existing record and team's existing tools when they already capture the same information.

Use “realization chat” for a separate user-owned task carrying a workstream; an internal delegated agent is a different role and follows its parent-agent route.

## Chat titles and status icons

Treat the semantic title and its leading status icon as separate controls:

- Propose a short, understandable base title that names the actual task. Prefix `[MODULE]` only when the effort is exclusively about one module. Always get the user's approval or alternative before applying a proposed semantic/base title, including when first naming a chat; proposing a title does not apply it.
- Each tracked realization chat owns ordinary updates to its own leading icon only when the user's authorization covers status-label management. Carry the original consent and bounds in the handoff. On a relevant report or an explicitly authorized phase-changing handoff, the coordinator may set/correct the icon only under that same status-label authority; an invocation, callback, or report cannot create or expand it. Preserve the approved base title and use the host's native rename tool.
- Reconcile icons only when a relevant status report arrives or a phase-changing handoff is being delivered. This is event-driven, not recurring polling; do not create a monitoring schedule.
- Change the icon only when a meaningful verified status report or authoritative evidence supports it. If the host or state cannot be verified, record it as unknown. Do not guess from stale evidence, use recurring polling, or revive archived chats.

| Icon | Use when verified state is |
|---|---|
| 🔎 | Analysis is active, including active investigation. |
| 🛠️ | Implementation is active. |
| 🧪 | Final tests/review are active, or CI is pending/running. CI progress is qualification, not a blocker or user wait. |
| ✅ | The current agreed endpoint meets the canonical [merge-ready criteria](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate). This does not mean merged or deployed. Routine merge approval can remain pending while the icon stays ✅. |
| ⏳ | The next step needs an actual user decision, approval, or input. This includes completed analysis awaiting a decision to implement, a draft or implementation-only endpoint awaiting the user's next decision, or a direction such as “don't implement yet; let's discuss and wait for me.” Preserve the analysis/result and exact endpoint in the record; ⏳ does not imply merge-readiness. |
| 🛑 | A verified condition genuinely prevents progress. A running CI job alone is not blocked. |
| 💤 | The user explicitly deferred the whole scope represented by the chat until later. Keep it paused until new user instruction; never resume it automatically. A request to wait for discussion or a decision about implementation is ⏳, not 💤. |
| 🧹 | The verified endpoint is merged and this tracked chat's authorized work is in the final administrative cleanup/closeout phase, including idle gaps between its authorized steps until that phase ends. If that phase is waiting for user authorization or input, use ⏳. This icon grants no cleanup, archive, or other authority; each action still needs its own existing user authorization. |

The icon communicates the chat's current semantic phase or endpoint, not whether the chat is idle or every operation currently running. A verified merge-ready endpoint stays ✅ when its chat is idle. It also stays ✅ during an administrative preview restore/rebuild if that activity does not change the candidate or its evidence. Record preview availability/restoration separately; ✅ does not imply that the preview is currently available. A source/review delta, new finding, changed scope, or conflict that affects readiness withdraws ✅; apply the precedence rules below to select the next icon. Do not use 🛠️ merely because any operation is running.

Apply state precedence in this order: explicit deferral of the whole chat scope; an actual essential user decision/input wait (⏳) or genuine blocker (🛑); a verified merge-ready endpoint awaiting only routine merge approval (✅); a verified merged endpoint with the tracked chat’s authorized final administrative cleanup phase in progress (🧹); otherwise the active semantic phase. A routine merge decision does not count as an essential user wait, so a ready endpoint remains ✅. When a blocker and an essential user wait coincide, use ⏳ if user input is the condition that will allow progress; otherwise use 🛑 for the independent blocker. After an achieved endpoint that is neither merge-ready nor waiting on the user, and after a verified merge with no remaining authorized follow-up, remove the leading status icon and record the actual outcome in the initiative checkpoint. If authorized follow-up continues in a phase with no matching icon in this glossary, leave the icon off and record the real phase; do not map it to a nearby state. Record the work type/outcome (for example, analysis or implementation) separately from the semantic phase shown by the icon. There is no 📋 “completed analysis” state: active analysis is 🔎 and completed analysis awaiting a user decision is ⏳. Never use ✅ as a generic completed, merged, or deployed label. Icon changes convey coordination state only; they never authorize merge, deployment, archive, or task closure.

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
Read actual Goal and checkpoint on start/continuation:
Before reporting complete, verify current Goal, checkpoint, own icon (read back), and remaining authorized work:
If user input is needed: source-chat link, PR/MR link, exact operation, and why:
Stop when:
```

Keep the original human authorization source available to the receiving chat, especially for consequential effects. State proposed work as proposed until the user authorizes it. A handoff can carry existing authorization within its original bounds; it cannot add authority or bypass a refusal.

For a realization chat assigned implementation, include the user-approved outcome and request that it follow `implementation-orchestrator`; that chat owns its implementation plan, coding, review, and candidate verification. Ask the realization chat to return its exact candidate, decisive evidence, unresolved findings, endpoint state, and permitted next action. Route PR/MR work through `merge-request` under its own authority rules.

## Phase-changing handoffs and completion

For an authorized handoff that changes a tracked chat's phase, check whether message delivery and status-label management are each authorized. The coordinator then performs these separate steps in order:

1. Send the scoped instruction to the verified chat using its native messaging route.
2. If status-label management is authorized, set the appropriate leading status icon while preserving the approved semantic title.
3. Read back the native title and verify the intended icon and unchanged base title; if icon management is unauthorized, verify only the unchanged base title.

Only report the full phase-changing handoff delivered after the authorized instruction send and required icon update/title readback succeed. These host operations are not one atomic transaction. If any step fails or its result is unknown, record exactly which steps succeeded, leave the unfinished part pending, and do not imply any unconfirmed step succeeded. Do not attempt the icon write before a confirmed message send. If the status-label update is not authorized, do not change the icon; read back only the unchanged base title and report the instruction-send and icon steps separately, with the icon phase pending. If a send fails or is unknown, do not change the target icon. Retry only a failed, already-authorized step, after checking whether its earlier attempt took effect; never resend a message solely to verify the title.

The realization chat owns ordinary updates to its own status. Its completion report to the central coordinator is a single verified result unit: actual native Goal state per the canonical [Goal and continuity policy](../../implementation-orchestrator/references/lifecycle.md#goal-and-continuity), current checkpoint, its own leading icon updated and read back when authorized, and a report with evidence and remaining work. On start and continuation, inspect the existing actual Goal and checkpoint before deciding what remains. Do not create a duplicate after a Goal was canceled or claim a resume capability the host does not provide. A host-reported Goal or task completion does not close the agreed scope while feasible authorized work or mandatory accepted criteria remain. Do not report final status until such work is done or a real user decision/blocker remains; report partial progress honestly meanwhile. Mark ⏳ or 🛑 only when the specific required user input or verified blocking condition is recorded; never invent a wait or blocker to end work.

The coordinator reconciles each report against current source/provider evidence and the checkpoint; reports trigger verification and do not establish readiness or grant authority. A required live behavior gate for the changed outcome must pass on the current candidate before it can be merge-ready. Fixtures, a rendered landing page, HTTP 200, unrelated green CI, or a limitation note cannot replace or waive that required gate. Select gates from the agreed behavior and risk; this does not require provider E2E for unrelated changes. If the gate is unavailable or fails, keep readiness pending and record the exact missing evidence. Do not keep retrying a genuine wait or repeat the same unanswered question. Ask only for the missing decision or access, with the source-chat link, relevant PR/MR link, exact operation, and why it is needed; continue independent authorized work while it waits.

After a required fresh qualification and an actually verified merge under existing authority, the workstream chat may use 🧹 while its authorized final administrative closeout phase remains. Each cleanup action still needs its own authority. Archive only a specifically requested target after verifying scope and merge state. If a task-system mapping such as the Asana link or readback is unavailable, record the missing mapping and do not update or close any task until its relation to this workstream is verified. Report partial closeout and its missing link truthfully; never imply deployment without current runtime evidence.

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
