# Coordination records and handoffs

Use these short forms only when they reduce ambiguity. Keep the initiative's existing record and team's existing tools when they already capture the same information.

Use “realization chat” for a separate user-owned task carrying a workstream. An internal delegated agent follows its parent-agent route. If a profile is selected and recorded for the initiative, the coordinator carries it in the handoff and the receiving realization chat applies it to its own newly dispatched role routes; agents spawned inside a role route inherit that route. The profile takes precedence over adapter defaults only for those routes; it does not edit them.

## Roles and escalation

The central coordinator, also called MAIN, owns priorities, scope, authority, cross-task resources, and the quality of the finished handoff. Each realization chat owns its whole task end to end: evidence analysis, implementation on the recorded model profile, independent review, verification, and delivery to the agreed endpoint. Routine repairs and technical choices within the original scope stay with that chat and need no new GO.

Escalate one step at a time:

1. The realization chat sends the coordinator what it cannot resolve from evidence, with the exact operation, why it matters, and the original consent source and bounds.
2. The coordinator decides within its current authority.
3. The coordinator asks the user only when genuine user-owned intent or authority remains unresolved, and never repeats a consent question the recorded source already answers. Consent that applies per item, such as for each new [task](#optional-project-task) or [issue](../../implementation-orchestrator/references/lifecycle.md#retrospective), is still asked for each item.

An automatic-review, host, or tool denial stays denied whatever consent exists; handle it under [blocker adjudication](../../implementation-orchestrator/references/lifecycle.md#blocker-adjudication-and-scope). If the coordinator is unreachable or a destination or tool is missing, say so, give the user the ready text, and keep the item pending.

## Chat titles and status icons

Treat the semantic base title and its prefixes as separate controls. The category rule is active only when the initiative checkpoint records the user's selected vocabulary and authorization source/bounds for applying it. Without that record, category prefixes are not a default and require their own authority. When active, every participating chat in that selected workflow, including the central coordinator and its tracked realization chats, includes a bracketed work-category prefix. Keep the base short and understandable, naming the actual task. The central coordinator proposes the base title and gets user approval before first applying or later changing it; execution chats never rewrite an approved semantic base.

Examples for the selected team (use the actual category list recorded in the initiative checkpoint):

| Work | Category prefix |
|---|---|
| Product-owned work | The owning module, for example `[MARKETING]` |
| Cross-module or general work | `[GENERAL]` |
| CI, tests, or pipelines | `[CI]` |
| Release coordination | `[RELEASE]` |
| Sentry work that needs both identifiers | `[SENTRY][MODULE]` |

The category set is selected-team configuration, not a universal vocabulary for all adopters. Escalate an unclear work category under [Roles and escalation](#roles-and-escalation). The central coordinator applies or corrects category prefixes within the recorded authority; execution chats keep the assigned category. Category-prefix writes do not require a separate semantic-base-title approval when the checkpointed authority covers them, and they must preserve the base. The leading phase icon is a separate control updated only under its own authority. A title may look like `🔎 [GENERAL] Reconcile report handoffs` or `[CI] Verify test pipelines`.

After any title write, read back the native title and verify the assigned category prefix, unchanged semantic base, and icon if the icon write was authorized. Record a failed or unknown update as pending; do not report it as complete.

- Each tracked realization chat owns ordinary updates to its leading icon only when the user's authorization covers status-label management. Carry the original consent and bounds in the handoff. On a relevant report or an explicitly authorized phase-changing handoff, the coordinator may set/correct the icon only under that same status-label authority; an invocation, callback, or report cannot create or expand it. Preserve the approved category and base title and use the host's native rename tool.
- Reconcile icons when a relevant status report arrives, a phase-changing handoff is being delivered, or an [authorized monitoring](#authorized-monitoring) run observes a changed state. Without such a monitor this stays event-driven; do not create a schedule.
- Change the icon only when a meaningful verified status report or authoritative evidence supports it. If the host or state cannot be verified, record it as unknown. Do not guess from stale evidence, poll outside an authorized monitor, or revive archived chats.

| Icon | Use when verified state is |
|---|---|
| 🔎 | Analysis is active, including active investigation. |
| 🛠️ | Implementation or repair is active. |
| 🕒 | A prepared candidate's qualification is queued and not yet running: its CI pipeline waits for a runner or admission, or its heavy operation waits under [Shared resources](../../implementation-orchestrator/references/lifecycle.md#shared-resources). State the queue state in text. A queue is qualification progress, not a blocker or user wait. |
| 🧪 | Tests, CI, browser verification, or review are actually running. CI that has not started is 🕒. State the CI state in text. Running CI is qualification, not a blocker or user wait. |
| ✅ | The whole current agreed endpoint is Ready for the user's personal review: it meets the canonical [merge-ready criteria](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate). An application change also needs [final functional verification](#final-functional-verification). This does not mean merged or deployed. Routine merge approval can remain pending while the icon stays ✅. |
| ⏳ | The next step needs an actual user decision, approval, or input. This includes completed analysis awaiting a decision to implement, a draft or implementation-only endpoint awaiting the user's next decision, or a direction such as “don't implement yet; let's discuss and wait for me.” Preserve the analysis/result and exact endpoint in the record; ⏳ does not imply merge-readiness. |
| 🛑 | A verified condition genuinely prevents progress. A queued or running CI job alone is not blocked. |
| 💤 | The user explicitly deferred the whole scope represented by the chat until later. Keep it paused until new user instruction; never resume it automatically. A request to wait for discussion or a decision about implementation is ⏳, not 💤. |
| 🧹 | Merged, finish pending: the verified endpoint is merged and this tracked chat's authorized work is in the final administrative cleanup/closeout phase, including idle gaps between its authorized steps until that phase ends. If that phase is waiting for user authorization or input, use ⏳. This icon grants no cleanup, archive, or other authority; each action still needs its own existing user authorization. |

The icon communicates the chat's current semantic phase or endpoint, not whether the chat is idle or every operation currently running. A verified merge-ready endpoint stays ✅ when its chat is idle. It also stays ✅ during an administrative preview restore/rebuild if that activity does not change the candidate or its evidence. Record preview availability/restoration separately; ✅ does not imply that the preview is currently available. A source/review delta, new finding, changed scope, or conflict that affects readiness withdraws ✅; apply the precedence rules below to select the next icon. Do not use 🛠️ merely because any operation is running.

Apply state precedence in this order: explicit deferral of the whole chat scope; an actual essential user decision/input wait (⏳) or genuine blocker (🛑); a verified merge-ready endpoint awaiting only routine merge approval (✅); a verified merged endpoint with the tracked chat’s authorized final administrative cleanup phase in progress (🧹); otherwise the active semantic phase. A routine merge decision does not count as an essential user wait, so a ready endpoint remains ✅. When a blocker and an essential user wait coincide, use ⏳ if user input is the condition that will allow progress; otherwise use 🛑 for the independent blocker. When several gates are open, show the icon of the actual main condition holding the endpoint, chosen by this precedence, and describe each other gate separately in the status text. Among active phases, 🕒 applies only when a queue is what the candidate is now waiting for; while repair, tests, browser verification, or review is actually running, use that phase's icon and report the queue in text. After an achieved endpoint that is neither merge-ready nor waiting on the user, and after a verified merge with no remaining authorized follow-up, remove the leading status icon and record the actual outcome in the initiative checkpoint. If authorized follow-up continues in a phase with no matching icon in this glossary, leave the icon off and record the real phase; do not map it to a nearby state. Record the work type/outcome (for example, analysis or implementation) separately from the semantic phase shown by the icon. There is no 📋 “completed analysis” state: active analysis is 🔎 and completed analysis awaiting a user decision is ⏳. Never use ✅ as a generic completed, merged, or deployed label. Icon changes convey coordination state only; they never authorize merge, deployment, archive, or task closure.

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
Decisions and authority: <decision/source/bounds; selected category vocabulary and prefix permission, or none; optional model profile selection/pin or accepted partial result and source, or none; selected task assignee and source, or none; task destination as verified project and section names and IDs with the user's authority source, or pending, or none>
Monitoring: <automation identity, schedule, authorization source, and stop condition, or none>
Open decisions and follow-through: <exact decision/action, what waits on it, chat/PR/MR/task links, first announced, last reminded, response, reminder policy, or none>

| Chat | Owner | Approved base and category | Status | Verified result | Next action |
|---|---|---|---|---|---|

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
Actor and context: <project, tenant, provider, endpoint, source, candidate, runtime as relevant; identity tied to consent or evidence>
Dependencies and inputs:
Evidence/checks required:
Final verification evidence (application changes): <candidate SHA, command, environment, URL, scenarios, reproducible results/evidence, CI, review, material limits; app provider under test separate from test-agent model/effort; at Ready, the Ready evidence packet with visible actual screenshots or the truthful reason they are absent>
Report to <verified destination>:
Read actual Goal and checkpoint on start/continuation:
Before reporting complete, verify current Goal, checkpoint, assigned category, own icon, title prefixes/base readback after any title write, remaining authorized work, and the short retrospective:
If user input is needed: source-chat link, PR/MR link, exact operation, and why:
Title category (only when checkpointed authority applies): <assigned category prefix and authorization source/bounds, or none>
Model profile (only if recorded under Decisions and authority): <selection, any user-pinned version or accepted partial result, and authorization source, or none>
Task destination (only when the scope involves Asana): <verified project and section names and IDs with the user's authority source, or pending>
Stop when:
```

Keep the original human authorization source available to the receiving chat, especially for consequential effects. State proposed work as proposed until the user authorizes it. A handoff can carry existing authorization within its original bounds; it cannot add authority or bypass a refusal.

### New realization chats

The first handoff to every newly created realization chat also carries:

- an explicit instruction to use [`development-executor`](../../development-executor/SKILL.md) and every other skill the scope needs: `deep-research` for broad read-only analysis when uncertainty or risk justifies it, `implementation-orchestrator` for approved implementation, `merge-request` for delivery, and applicable project or domain skills. If the chat cannot load a named skill, state that gap instead of assuming the skill applies;
- the status contract, as the capsule below or a link the chat can open;
- the model roles from the recorded profile, or `none`;
- the recorded [task destination](#task-destination), only when the chat's scope involves Asana;
- the whole approved Goal;
- the verified coordinator destination;
- the current authority source and bounds.

```text
Status icons: 🕒 candidate qualification queued, waiting for CI runner/admission or heavy-work admission · 🧪 tests/CI/browser/review running · 🛑 real blocker · 🔎 analysis · 🛠️ implementation/repair · ✅ whole scope Ready for personal review · ⏳ actual user decision/input · 💤 explicit whole-task deferral · 🧹 merged, finish pending.
Use one icon for the actual main holding condition and state other gates separately. A queue alone is never 🛑.
Report to the coordinator at whole-scope Ready, an analysis proposal, a fully authorized completion, a real blocker, or needed coordination, one row per task, in Czech: Úkol a odkazy | Co se řeší | Stav | Na co se čeká | Další krok / doporučení.
```

The capsule conveys meanings only: a title or icon write still needs its recorded authority, and the [glossary](#chat-titles-and-status-icons) stays canonical. Do not paste the full policy into the handoff.

## Optional per-initiative team profile

This user-specific example applies only to an initiative whose existing checkpoint records the user's selection under “Decisions and authority.” The coordinator carries that recorded choice in the handoff; the receiving realization chat applies it only to its own newly dispatched role routes. Work performed by the coordinator or root realization chat itself stays on that chat's actual host model and outside the profile. The profile does not edit adapter defaults. Agents spawned inside a selected role route inherit that route; other internal agents follow their parent route. If the host cannot dispatch a selected route, leave it pending rather than silently falling back. Decisions this section reserves for the user reach the user through the coordinator under [Roles and escalation](#roles-and-escalation).

| Role | Model and effort |
|---|---|
| Bounded helper, investigation, validation, or narrow delegation | GPT-6.1 Terra / High |
| Dedicated real-app browser verification through Playwright | GPT-6.1 Terra / High |
| Deep research perspectives | GPT-6.1 Sol / High plus Claude Opus / High; do not route deep research to Luna |
| Implementation | Claude Opus / High |
| Independent implementation review | GPT-6.1 Sol / High when its provider is opposite the verified implementer's provider |

The realization owner dispatches browser verification to an actual independent Terra / High child, which runs its own supported Playwright path against the current candidate and agreed user-facing flows under [final functional verification](#final-functional-verification). Playwright is the selected route, not an emergency workaround, and Terra does not wait for an in-app browser. Headless or interactive follows the flow under that section, and Terra stays the tester in either mode. Terra reports reproducible findings and evidence to the realization owner; Opus makes authorized fixes, then Terra retests the affected flows on the changed candidate. Sol separately reviews code and evidence and is not the browser operator. Record the candidate SHA, app/preview URL, browser mode, scenarios, outcomes, limits, actual tester model/effort, and app provider under test as distinct facts. If the route, Playwright, or assistant ownership cannot be verified in Terra's own context, report a qualification gap; do not silently substitute a route, duplicate a running test, or infer new credential, spend, production, merge, or deployment authority.

The 🔎 icon describes the active semantic phase, not a model route. The dispatching realization chat classifies the assigned task: bounded helper, investigation, validation, or narrow delegation uses Terra; deep research, only when [proportionate analysis](../../implementation-orchestrator/references/lifecycle.md#evidence-and-quality) selects it, uses both Sol and Opus. If scope is unclear, ask the coordinator. Selected deep research stays incomplete until both perspectives contribute with verified model identity and effort. If either route is unavailable or provenance is unverified, report partial progress and keep research incomplete unless the user explicitly accepts a partial result; record that choice. Other unsupported routes remain pending until the user explicitly chooses an alternative. Any host-reported Claude Opus version satisfies the family route unless the user pins a version; record the exact actual model and effort, or mark them unverified.

Before dispatch, confirm that the host supports the requested model and effort. After execution, report the actual model identity and effort or mark either as unverified. Unverified output does not count as a required deep-research perspective or an independent implementation review. Sol is an independent implementation reviewer only when separately dispatched by the realization chat and opposite-provider to the verified actual implementer; a reviewer nested under the Opus implementation route inherits Opus and does not satisfy that independent-review role. If Sol or another route from its provider authored a consequential part of the candidate, do not call a Sol review of that part independent: preserve existing opposite-provider coverage, report the conflict, and use another review route only when the user approves it. If a requested route is unavailable or its identity cannot be verified, report the gap and leave that route pending until the user explicitly chooses an alternative; do not silently substitute a model or provider. The profile guides future dispatch only: it does not rewrite historical provenance, authorize restarting already-running work, or invalidate a review that remains valid under the [review policy](../../implementation-orchestrator/references/review.md).

For a realization chat assigned implementation, include the user-approved outcome and request that it follow `implementation-orchestrator`; that chat owns its implementation plan, coding, review, and candidate verification. Ask the realization chat to return its exact candidate, decisive evidence, unresolved findings, endpoint state, and permitted next action. Route PR/MR work through `merge-request` under its own authority rules.

## Phase-changing handoffs and completion

For an authorized handoff that changes a tracked chat's phase, check whether message delivery and status-label management are each authorized. The coordinator then performs these separate steps in order:

1. Send the scoped instruction to the verified chat using its native messaging route.
2. If checkpointed category-prefix authority applies, apply or correct the assigned category. If status-label management is authorized, set the appropriate leading icon. Preserve the approved semantic base title.
3. Read back the native title and verify the assigned category prefix, unchanged base title, and the intended icon if its update was authorized; if a prefix update was unauthorized, verify that prefix remained unchanged.

Only report the full phase-changing handoff delivered after the authorized instruction send and required category/icon updates and title readback succeed. These host operations are not one atomic transaction. If any step fails or its result is unknown, record exactly which steps succeeded, leave the unfinished part pending, and do not imply any unconfirmed step succeeded. Do not change title prefixes before a confirmed message send. If category or status-label updates are unauthorized, leave those prefixes unchanged; read back the category and base, plus icon if authorized, and report any required prefix step as pending. If a send fails or is unknown, do not change the target title. Retry only a failed, already-authorized step, after checking whether its earlier attempt took effect; never resend a message solely to verify the title.

The realization chat owns ordinary updates to its own status. Its completion report to the central coordinator is a single verified result unit: actual native Goal state per the canonical [Goal and continuity policy](../../implementation-orchestrator/references/lifecycle.md#goal-and-continuity), current checkpoint, and, when the category rule applies, its assigned category prefix preserved and read back if the title changed. It also reports its own leading icon updated and read back when authorized, and for each selected model-profile route it dispatched, actual model identity and effort or explicitly unverified provenance, along with evidence, remaining work, and the [retrospective](../../implementation-orchestrator/references/lifecycle.md#retrospective) when the report is its final handoff. On start and continuation, inspect the existing actual Goal and checkpoint before deciding what remains. Do not create a duplicate after a Goal was canceled or claim a resume capability the host does not provide. A host-reported Goal or task completion does not close the agreed scope while feasible authorized work or mandatory accepted criteria remain. Do not report final status until such work is done or a real user decision/blocker remains; report partial progress honestly meanwhile. Mark ⏳ or 🛑 only when the specific required user input or verified blocking condition is recorded; never invent a wait or blocker to end work.

The coordinator reconciles each report against current source/provider evidence and the checkpoint; reports trigger verification and do not establish readiness or grant authority. A required live behavior gate for the changed outcome must pass on the current candidate before it can be merge-ready. Fixtures, a rendered landing page, HTTP 200, unrelated green CI, or a limitation note cannot replace or waive that required gate. Select gates from the agreed behavior and risk; this does not require provider E2E for unrelated changes. For an application change, [final functional verification](#final-functional-verification) defines this gate. If the gate is unavailable or fails, keep readiness pending and record the exact missing evidence. Do not keep retrying a genuine wait, and repeat an unanswered question only as a due reminder under [authorized monitoring](#authorized-monitoring). Ask only for the missing decision or access, with the source-chat link, relevant PR/MR link, exact operation, and why it is needed; continue independent authorized work while it waits.

After a required fresh qualification and an actually verified merge under existing authority, the workstream chat may use 🧹 while its authorized final administrative closeout phase remains. Each cleanup action still needs its own authority, which an invoked [finish package](#personal-review-and-finish) provides for its owned targets. Archive only a specifically requested target after verifying scope and, unless it is an analytical closeout, merge state. If a task-system mapping such as the Asana link or readback is unavailable, record the missing mapping and do not update or close any task until its relation to this workstream is verified. Report partial closeout and its missing link truthfully; never imply deployment without current runtime evidence.

## Discovery and ownership

On each continuation or authorized monitoring run, establish current scope from actual host state, not from a fixed list, title, or icon:

- List the actual host chats.
- Read the latest human assignment and the checkpoint of each chat that may belong to the initiative.
- Take a compact, non-blocking status read of those chats.
- Include idle and not-loaded chats that still have authorized work or an open decision.
- Find every open item, not only active implementation: an unanswered question, a proposal awaiting a decision, or an actual user request, promised checkpoint, or follow-through that never finished.
- Treat a new direct instruction from the owning user as updating actual scope, including work the user explicitly reopens.
- Leave completed, paused, or excluded work closed. Do not revive it for formalities.

Before a handoff, verify the destination and the original scoped authority. Give an inactive owner the specific remaining work and verify that it took over. Do not repeat an instruction to an active owner unless there is new scope, authority, or a dependency.

Keep one owner per resource, PR/MR, and QA environment. The coordinator never implements, diagnoses, tests, merges, or cleans up on an owner's behalf; its read-only load measurement for [shared-resource admission](../../implementation-orchestrator/references/lifecycle.md#shared-resources) is coordination.

## Authorized monitoring

Recurring checks exist only when the user explicitly authorizes them; otherwise coordination stays event-driven. Create or change a monitor only under that authority, using the host's actual automation tool and the [periodic monitor template](periodic-monitor-template.md). Reuse an existing matching monitor and never run two for one coordinator.

Two separate intervals apply, and neither replaces the other. The defaults hold unless the user chose otherwise:

| Interval | Default | Controls |
|---|---|---|
| Check | 15 minutes | How often the monitor discovers and reconciles state. |
| Reminder | 4 hours | How often the same open item that needs the user is raised again. |

Use one coordinator monitor on the check interval (15 minutes by default) and evaluate every unanswered decision on every run; the reminder interval (4 hours by default) is only an elapsed-time eligibility and cooldown condition checked inside that same run, never a second automation or schedule.

On each run:

- Notify promptly about a significant whole-scope Ready, a completion, a proposal awaiting a human decision, or an actual blocker.
- Stay silent when queues and states are unchanged.
- Bundle all due reminders and open questions into one brief message. A reminder never repeats on every check.

For each [open item](#discovery-and-ownership), record the exact decision or action, what waits on it, its chat, PR/MR, and task links, when it was first announced and last reminded, the response, and its reminder policy. Remind the user only about items that need the user. Elapsed time is never approval.

Apply the item's reminder policy:

- By default, an item is due when the reminder interval has passed since it was last raised.
- If the user named a reminder date, the item is due on that date. Remind earlier only on evidence of a deadline or worsening impact, and record that evidence.
- If the user explicitly said “odložit” or “nepřipomínat” without a date, send no automatic reminder and do not resume the item automatically. Keep it and its history in the record, and show it when the user asks for status.
- Deferring one decision or action does not pause its chat unless the user's actual words say so. The chat's other authorized work continues, and 💤 stays reserved for the whole chat scope.
- A conversation about an item, or one that has gone quiet, is not a deferral or a pause.

Stop or delete a monitor through the actual automation tool and read back the result. Do so only when all agreed work has ended, or when the user explicitly deferred it and no decision still subject to automatic reminders remains.

### CI observation

The chat that owns the candidate observes its CI within the finite [exact-head observation](../../merge-request/references/provider-delivery.md#exact-head-observation) budget. A coordinator monitor the user has already authorized may read the same state on its own schedule; do not change that schedule for one pipeline.

- Wait through the host's native wait or the owner's current task.
- Check about every 15 minutes by default, and about every 5 minutes only when observed evidence puts completion close, such as the same pipeline's recent durations or its remaining jobs.
- Stop checking once CI reaches a terminal result.
- Do not create an automation for one pipeline, job, or task completion.

The only exception is a host that explicitly supports and permits dedicated CI schedules, when the user has authorized one:

- Bind the schedule to one unique chat, source SHA, and pipeline, and first confirm that none exists for them.
- Use the same 15-minute default and evidence-based 5-minute check.
- On terminal success or failure, stop the schedule and read back that it is gone.
- If the pipeline is paused or the source SHA is replaced, stop the schedule and report the changed state. It does not follow a new SHA without its own authorization.
- Never delete the coordinator monitor, and never merge or retry from the schedule.

## Final functional verification

This gate applies to changes in an application. Instruction-only and documentation-only changes need no application browser run.

- Run the final pass over the whole changed user flow on the actual current candidate in the repository's actual documented development application, using its standard command (for example `make dev` where the repository documents it).
- Use the real backend and the runtime that flow depends on.
- Use the owner's own isolated slot and its own isolated data in the repository's standard sanitized database.
- Drive the application with an assistant-owned browser on a supported route: the one a recorded [team profile](#optional-per-initiative-team-profile) selects, otherwise the active adapter's. Never use the user's browser or profile.
- Choose the browser mode from the flow, before the run. Headless fits repeatable real-app end-to-end runs and resource efficiency; interactive browsing fits exploratory, visual, and provider flows. Both keep the same independent tester role, real backend flow, and screenshot evidence.
- Before the run, verify the host route, the browser dependency, the application context, and assistant ownership in the actual tester's context. A browser that works for the coordinator or another chat proves nothing for this tester.
- Use a browser dependency already supported in that context. Add no test framework, and install a dependency only under existing authority for that specific install.
- Capture screenshots of the relevant desktop and mobile views.
- Treat mock APIs, proxied or stubbed responses, static prototypes, component fixtures, screenshots, and green CI as supplemental. None of them replaces this pass.
- Obtain the applicable authority for runtime, provider, external-write, or AI-spend effects. The need to test does not imply it.
- Count an interrupted run as incomplete, and finish the flows it did not cover on the same candidate.
- If the application or browser fails, record the exact error, time, and impact and keep Ready pending. Do not silently switch to another browser or workaround: a browser failure triggers no automatic change of browser mode, route, or model, and no coordinator takeover.
- Honor the recorded profile, and take any genuinely unresolved alternative to the coordinator under [Roles and escalation](#roles-and-escalation). Never transfer credentials or sessions to make a browser work, and keep them out of scripts, traces, and evidence.

The owner hands off the candidate SHA, command, environment, actual functioning [URL](#development-and-qa-addresses), scenarios, results, CI, review, and material limits, together with the [Ready evidence packet](#ready-evidence-packet). The coordinator verifies Ready from that handoff and does not repeat the run. Without this gate on the current candidate, the chat is not Ready.

### Ready evidence packet

Every application Ready handoff from the owner to the coordinator, and the coordinator's personal-review message to the user, carries this packet below the status table. It shows the user what the required pass produced. It is neither functional proof by itself nor a replacement for CI.

- Attach or render the relevant screenshots through the host's supported media so the user actually sees them. A list of local paths alone does not count.
- Use only actual existing screenshots from that pass, matching the current candidate and the reported runtime. Never present a stale, failing, or prototype frame as the successful result; include one only when it is labeled as what it is, to show a defect or limit.
- Explain the testing briefly: the standard command, URL, backend and runtime, browser mode, the scenarios or steps actually performed, results, the commit the running application was built from, and material limits.
- Say which flows used synthetic fixture or demo data and which ran end to end against a live provider.
- Omit any image that would expose credentials or private customer content.
- If a safe attachment is unavailable or the change has no relevant UI, state why and supply appropriate technical evidence instead. Never fabricate an image or a result.
- That exception changes only the evidence format. A required functional pass that is missing still means the chat is not Ready.

The coordinator checks that the packet is present and consistent with the candidate, then relays the owner's images and summary without repeating the testing. If the packet is missing or inconsistent, it keeps Ready pending and returns the exact gap to the owner under existing messaging authority.

The packet grants no authority. It permits no upload to another service, no use of a personal browser or session, and no provider sync or write. A push notification is not this packet; its image stays optional under [Important notifications](#important-notifications).

## Development and QA addresses

This applies to a realization owner's isolated development or QA virtual host (vhost). It grants no setup, runtime, configuration, or external authority.

- Name a newly provisioned vhost from a short feature or thread descriptor plus the owner's existing unique worktree slot, for example `meta-oauth-6.localhost` instead of `ant-20261110-6.localhost`. Use the repository's documented naming mechanism.
- Keep a running review address. Change it only for a concrete reason, such as a collision or broken alignment, and record that reason.
- Preserve slot isolation. Keep the applicable API host and OAuth redirect or callback address aligned with the hostname, changing them only under existing authority.
- At handoff, the owner verifies and provides the actual functioning URL for the intended environment, including its actual scheme, port, and path when applicable. The coordinator relays that URL without constructing or rewriting it.
- If the URL does not work or cannot be verified, report the exact gap instead of a guessed address.

Example from (ant)brain, per the worktrees runbook at `docs/runbooks/worktrees.md` in that repository: the generated localhost name combines the first and last words of the branch name with the stable worktree slot, keeping parallel checkouts short and collision-free without changing `/etc/hosts`. A detached worktree falls back to the repository folder name. When the generated alias is unclear, use custom mode with a readable full hostname whose dot-separated labels contain only alphanumerics and hyphens. In the normal runbook setup, its host options look like `DEV_HOST_MODE=custom DEV_HOST=meta-oauth-6.localhost make worktree-setup`. Set `DEV_API_HOST=...` during that setup when the derived API host needs an override.

## Personal review and finish

A whole-scope Ready chat stays open and unarchived for the user's personal review. Ready, QA, personal review, or partial cleanup does not authorize merge, deployment, task closure, or archive. Preserve the environment needed for any promised review until authorized closeout begins.

The finish package applies when the user has explicitly adopted this finish workflow, that adoption is recorded, and after reviewing the user directly and concretely tells that chat to finish, for example “OK, finish this chat.” That instruction carries the package below without reasking. An exact different sequence from the user replaces it.

The chat's owner performs these steps in order:

1. Verify a fresh current candidate against the [merge-ready criteria](../../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate), including passing required CI, current review, and provider protections. Never bypass failed or mismatched CI.
2. Merge into the target and verify the merge with the provider.
3. Record a short nonsecret outcome in the lasting records first: update or close the existing task for the actual scope when its mapping is verified, and state the outcome in this chat.
4. Perform the [owned cleanup](#owned-cleanup), verify that every removed target is absent, and record that verification.
5. Archive the chat last through the actual host tool and read the result back.

Deployment, production, and customer-data changes need separate authority and are not required for archive.

A real blocker, a failed step, or unverified cleanup of an owned target keeps the chat open and is reported. Archiving never conceals it.

After pure analysis, “analysis is enough, finish this chat” means analytical closeout only: record the outcome in this chat, perform the owned cleanup, and archive last. Update the existing task only when it exists, its mapping to this scope is verified, and the write is authorized; this closeout never creates a task. The analysis survives in this chat and any task updated this way; local evidence copies are removed with the other owned artifacts. It makes no fix claim and authorizes no implementation or merge.

### Owned cleanup

Owned cleanup removes every resource exclusive to this chat's thread. Its scope includes:

- private isolated development or QA containers, networks, processes, routes, and slot reservations;
- persistent database, credential, and export volumes, and caches;
- temporary worktrees and branches;
- working and test artifacts, including local copies of evidence.

Keep the delivered source in the target and the enduring system records: the PR/MR, the task record, and the archived conversation. Shared, foreign, production, and uncertain resources stay outside this destructive scope, as do production or customer data and shared credential material even inside an owned QA volume.

- Inventory the concrete targets first, each by its actual identity, such as a container, volume, process, route, reservation, worktree path, branch, or artifact path. Remove only inventoried targets. Never run a broad prune, force a removal, or delete recursively beyond a verified target.
- Before removing each target, freshly verify that this thread owns it exclusively and that nothing currently uses it, including this chat's own remaining work and dependencies and any other user, chat, or service.
- For a worktree or branch, also freshly check for dirty or untracked files, stashes, and commits not landed in the target, and, where relevant, for linked or shared data. Content that is uncertain or outside this scope blocks that deletion.
- Verify landing only for an intended deliverable. Before deleting the only local copy of an agreed standalone deliverable, preserve it in a lasting record. Intentionally disposable QA artifacts, such as test data, caches, and local evidence copies, need no landing proof and are not retained by default. Analysis has no merge to verify.
- Treat a target that fails or cannot complete a check as uncertain: leave it and report it.
- Record the outcome before removal, as the finish steps order. Then remove the scoped targets and verify each is absent.
- Record the scoped cleanup verification durably in this chat and its checkpoint: each removed target verified absent, each target left and why, and every user exception. Then archive last.
- This full scope is authorized by the current recorded workflow adoption that covers it or by the user's direct, specific scope. An older, narrower adoption is not broadened retroactively; a direct finish request carries only the effects its applicable adoption or explicit terms actually cover. Ask no new approval for exact targets already authorized this way.
- Only the user chooses an exception. The mere presence of QA data or evidence does not justify keeping it. An explicit user exception remains authoritative; record it.
- Report every actual blocker and exception explicitly. An actual blocker keeps the chat open and unarchived.

The coordinator verifies cleanup from the owner's durable record and never cleans up for the owner. Missing owner evidence keeps reconciliation pending. Return the exact gap only to an open owner chat under existing messaging authority; do not reopen or revive a chat whose archive was verified merely because its report has not arrived.

## Goals in an adopted workflow

A skill never creates a Goal requirement by itself. When the user explicitly adopts this workflow with a Goal for each realization, record that instruction as the source; it is the explicit user requirement under the [Goal and continuity policy](../../implementation-orchestrator/references/lifecycle.md#goal-and-continuity). Without it, the active adapter's optional Goal policy stands.

Under that requirement, each realization chat:

- Keeps exactly one native Goal for its whole approved scope, plus its own checkpoint.
- Reads its actual Goal and reuses a matching active one.
- Creates a Goal only when one is verifiably missing and the host allows it, for the whole currently approved scope, including pure analysis. It never creates a duplicate or invents a token budget.
- Keeps working through partial results to the whole endpoint.
- Treats a completed Goal at Ready as no merge, deployment, or archive permission, and a blocked Goal as never complete.
- Applies the shared Goal status rules for completing, pausing, blocking, and collisions through the live tool schema, reporting only a status the tool verified.
- While waiting for capacity, uses a supported native wait or the coordinator's wakeup, never empty automatic continuation or status loops.
- Handles changed work without overwriting the active Goal: complete that Goal only if its endpoint was truly achieved, then create a follow-up Goal with the host's tools.

## Status reports

Unless the user chooses another form, report meaningful status in Czech as one Markdown table with exactly these headers:

| Úkol a odkazy | Co se řeší | Stav | Na co se čeká | Další krok / doporučení |
|---|---|---|---|---|

- Give each task one row. A report about a single change has one row.
- In `Úkol a odkazy`, link the direct chat and the actual PR/MR, Asana task, or other material link. Never invent a link.
- In `Co se řeší`, state the problem and the benefit.
- In `Stav`, give the real state and its [icon](#chat-titles-and-status-icons). When several gates are open, show the main one.
- In `Na co se čeká`, name who or what is awaited, and each other open gate separately.
- In `Další krok / doporučení`, give the next step and your recommendation.
- State the report's actual time once, in Europe/Prague unless another user time zone is configured.
- Omit work that is completed, cleaned up, and archived, and keep it in the record's history.

A realization owner reports to the coordinator at whole-scope Ready, an analysis proposal, a fully authorized completion, a real blocker, or needed coordination. Partial results stay in its checkpoint. A final proposal gives the problem, impact, solution, risks, the owner's recommendation, and why.

## Important notifications

Send a push notification only through a route the user explicitly approved, with the endpoint and that route's own secret directly available for this destination. This skill and its template grant no endpoint or secret authority to any adopter. Never hardcode a key, write it to an artifact, copy it, or search for credentials.

Notify only for the prompt events under [Authorized monitoring](#authorized-monitoring), never for a routine phase change or queue state. Keep the message to brief Markdown with the impact, next action, chat link, and PR/MR or Asana link. Do not include a long table or technical log. Attach an image only when it is a relevant actual screenshot from the owner.

On an approved Notifi route, the send has this shape:

```bash
curl -sS -o /dev/null -w '%{http_code}\n' -X POST https://notifi.it/send \
  -H 'Content-Type: application/json' \
  <authentication defined by the approved route> \
  -d '{"title":"<title>","message":"<brief Markdown>","link":"<chat link>","image":"<relevant screenshot URL, or omit this field>"}'
```

HTTP 202 confirms only that the service accepted the message, not that a device received it. Record only non-secret identity and result. If the secret is unavailable or the send fails, tell the user and do not imply delivery.

## Optional project task

Use Asana or another connected task system only when it is part of the agreed scope and the required connector and authority are available. Ask explicitly before creating every new task, including an analysis task; a work assignment or chat authority is not that consent. Check for an existing duplicate first. A new task also needs an established [task destination](#task-destination) and, in Asana, its [due date and priority choices](#new-task-due-date-and-priority). Creating no task is the default, and analysis can finish without one. Before creating a task or materially changing its description, scope, placement, or configured fields, settle those details with the user and preserve approved task text. Set an assignee only from the user's explicit selection recorded in the checkpoint, and read that assignee back after the write. For finish-driven task status or comment actions, apply the [coordinator's authority rule](../SKILL.md#workflow) and record the original consent source and bounds. Beyond those new-task choices, ask only meaningful missing field questions, without a fixed questionnaire.

In Asana, project section placement and the `ANT Prio` custom field are independent. A section named `Vývoj AAA` does not set or imply `ANT Prio = AAA`. Never infer or change that field from the section, task title, or priority label; set or remove `ANT Prio` only when the user explicitly instructs that field change. Apply any change only to the named tasks and read back the field separately from section placement.

Keep the task description concise: what changes, why it matters, expected benefit, decisions or dependencies (with reasons), and what evidence will establish completion. Preserve approved description text. Put material delivery updates in comments rather than rewriting the approved scope. Record a deployment date only after confirmation. Do not infer coverage of every task or PR/MR from samples; establish the relevant inventory. After an authorized write, read back the task and verify its placement, configured fields, and current status. If the connector cannot confirm a value, leave it unknown.

On an existing authorized task, record important decisions and a final brief covering what changed, why, how, and any post-deployment actions; do not keep a technical diary. Closing a task is separate from deployment and does not claim it.

For a meaningful status comment, state the user outcome, its verified state, relevant evidence, and any decision with its reason. Avoid technical dumps or duplicate comments. When deployment is in scope and authorized, record who deployed it, how it was verified, any material limitation, and the owner/action for follow-through. Say “deployed” only when current runtime evidence supports that state.

```text
Status: <verified outcome and state>
Evidence: <relevant source or link>
Decision/dependency: <what is needed and why, or none>
Deployment: <confirmed owner/date, verification, and limitation, or omit>
Follow-through: <owner and action, or none>
```

### Task destination

The task destination is the Asana project and section that new tasks in this workflow use; another connected task system applies this to its equivalent placement. This setup applies when Asana is part of the agreed workflow and its connector is available. Otherwise ask nothing about a destination, record `none` or `pending`, and continue analysis and independent work. A missing destination holds only the creation of a task.

- During setup of a new workflow, ask which project and section new tasks should use, in one concise question bundled with any other missing setup choice.
- Do not ask when a verified direct user instruction already gives both. If it gives only one, ask for the other.
- Resolve the answer read-only through the actual task connector and its existing access: confirm the project, confirm that the section belongs to it, and take their actual IDs. Never create a task to test this, put a token in a prompt, or search for credentials.
- If a name is unknown or matches more than one project or section, ask only for that specific choice.
- Record both names and IDs and the user's authority source under `Decisions and authority` in the checkpoint.
- Put the same values in an authorized monitor's [instruction](periodic-monitor-template.md), changing that monitor only through the host's automation tool and under its existing authority.
- Pass the destination in a handoff only where the receiving chat's scope involves Asana. That chat uses the destination it received and asks the coordinator when it is missing or `pending`.
- While the destination is unresolved or unverified, record it as `pending`. Never choose a default or infer one from earlier work.
- Establish the destination before any authorized task creation.
- When the user directly changes the destination, verify it the same way and update the checkpoint and monitor under the same limits.

Selecting a destination authorizes no task: every new task still needs its own explicit consent. The assignee stays a separate recorded selection.

After an authorized creation, read back the task's actual project and section memberships, separately from its assignee and `ANT Prio`. The section still implies nothing about `ANT Prio`. If a membership is wrong or cannot be confirmed, report that and do not create a second task.

### New task due date and priority

Apply this every time a new Asana task is being created. It does not apply to updating an existing task, and it grants no authority.

- Ask for the due date unless the user already gave a value for that particular task. An explicit “no due date” is a complete answer.
- Before asking about or writing a priority, read the target project's metadata through the actual task connector and take the field's actual name, ID, type, and options. Never guess a field, option, or ID.
- Ask for a priority only when that project actually has a genuine priority field, meaning one whose purpose is task priority, and the user has not already answered for that task. An explicit “no priority” is a complete answer.
- Do not treat WIP, section, size, or `ANT Prio` as that field. `ANT Prio` stays under its own explicit-instruction rule above.
- If the project has no genuine priority field, ask nothing about priority, add no field, and write no priority into another field.
- If several fields could be the priority field, ask only the choice that is actually missing.
- If the project is unresolved or its metadata is unavailable, do not conclude that it has no field. Unless the user already chose no priority for that task, record priority as `pending`. That holds only this task's creation.
- Put whatever is still missing into one brief question, together with that task's creation consent and any missing [destination](#task-destination) choice. A priority question that depends on an unresolved project follows once the project is verified. This is not a questionnaire for other work, and independent authorized implementation continues while the answer is outstanding.
- Do not treat an answer here, a destination setting, or an implementation assignment as consent to create the task. It still needs its own explicit consent.
- Record each answer, including an explicit none, under `Decisions and authority` in the checkpoint, scoped to that task. Pass it in a handoff only to the chat creating that task, and never turn it into a default for other tasks.
- After creation, read back any due date and priority that were written, separately from the memberships and assignee read back under [Task destination](#task-destination). If a value is wrong or cannot be confirmed, report that and do not create a second task.

## Closeout

Report the endpoint in its actual state and link the relevant checkpoint or task when available. Separate verified facts from hypotheses and unknowns. Name required evidence that is still missing and the next action that is already authorized. Do not call an umbrella initiative complete while its agreed work remains open.

Each realization chat's final handoff carries the short [retrospective](../../implementation-orchestrator/references/lifecycle.md#retrospective), which is required for a pure analysis too. The coordinator aggregates those in one existing project-appropriate learning log, or the initiative record when none exists, and adds no per-chat file or framework. It prepares and deduplicates any issue proposal from them automatically, and asks the user before creating each one under that [retrospective rule](../../implementation-orchestrator/references/lifecycle.md#retrospective).
