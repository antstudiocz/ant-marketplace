# Periodic coordinator monitor template

Use this template only after the user explicitly authorizes a recurring coordinator monitor. It is a ready-to-use instruction for the host's own automation tool. It adds no runtime and grants no authority; authority comes from the user's recorded instruction. [Authorized monitoring](coordination.md#authorized-monitoring) owns the rules.

## Set up

1. Record the user's authorization source, check interval, reminder interval, and stop condition under `Monitoring` in the initiative checkpoint.
2. Use the host's actual automation tool. If the host has none, or its policy refuses this monitor, tell the user and do not create a substitute.
3. List the existing automations. If one already monitors this coordinator chat, reuse it, and change it only under the user's authority while preserving its identity, schedule, and status unless the user asks otherwise. Never run two monitors for one coordinator.
4. If Asana is part of the agreed workflow and no destination is recorded yet, establish the [task destination](coordination.md#task-destination). Fill the destination placeholders from the user's verified answer in the checkpoint, never from fixed IDs or an earlier initiative. Change an existing monitor to carry them only as step 3 allows.
5. Replace every placeholder with a verified value. Do not add a fixed chat or task list, a key or other secret, or a token budget.
6. Create the automation with the instruction below. Do not create a monitor for one pipeline, job, or task completion.
7. Read back its identity, schedule, and status, and record them in the checkpoint.

| Placeholder | Value |
|---|---|
| `<COORDINATOR_CHAT>` | Verified link or identity of the coordinator chat. |
| `<INITIATIVE_RECORD>` | Path of the initiative checkpoint. |
| `<AUTHORITY_SOURCE>` | Link to, or faithful quote of, the user's authorization, and its bounds. |
| `<CHECK_INTERVAL>` | Interval for checks, by default 15 minutes unless the user chose otherwise. Set it as the automation's schedule. |
| `<REMINDER_INTERVAL>` | Interval for repeating one open item that needs the user, by default 4 hours unless the user chose otherwise. |
| `<TIME_ZONE>` | The user's configured time zone, for example Europe/Prague. |
| `<STATUS_READ>` | The host's compact non-blocking status read; on Codex, `wait_threads` with `timeoutMs: 0`. |
| `<NOTIFICATION_ROUTE>` | The route the user explicitly approved, identified without its secret, or `none`. |
| `<TASK_ASSIGNEE>` | The assignee the user explicitly selected, verified in the task system, or `none`. |
| `<TASK_PROJECT>` | Name and ID of the project the user chose for new tasks, verified in the task system. `pending` while unresolved, `none` when Asana is not part of the workflow. |
| `<TASK_SECTION>` | Name and ID of the section the user chose in that project, verified in the task system. `pending` while unresolved, `none` when Asana is not part of the workflow. |
| `<TASK_DESTINATION_SOURCE>` | Link to, or faithful quote of, the user's answer choosing that project and section, or `none`. |
| `<STOP_CONDITION>` | The agreed end of this monitor. |

## Instruction

```text
Periodic monitor for coordinator chat <COORDINATOR_CHAT>. Check interval: <CHECK_INTERVAL>. Perform one check, then end.

AUTHORITY
Authorized by <AUTHORITY_SOURCE>. Initiative record: <INITIATIVE_RECORD>. This monitor grants no new authority. Before acting, read the development-coordinator skill and its references/coordination.md; section names in parentheses refer to that file. Do not implement, diagnose, test, merge, or clean up for any owner. Do not create or change any other automation.

1. DISCOVER (Discovery and ownership)
List the actual host chats. Read the latest human assignment and the checkpoint of each chat that may belong to the initiative. Use <STATUS_READ>. Include idle and not-loaded chats with remaining authorized work or an open decision. Find every open item, not only active implementation: an unanswered question, a proposal awaiting a decision, or an actual user request, promised checkpoint, or follow-through that never finished. Do not rely on a fixed list, a title, or an icon. A new direct instruction from the owning user updates scope, including explicitly reopened work. Leave completed, paused, or excluded work closed.

2. RECONCILE
Compare each chat's actual state with the initiative record and with verified PR/MR, CI, task, and Goal state. A report is a trigger to verify, not proof, and it grants no authority. CI queued or pending, waiting for a runner or admission, is 🕒; CI actually running is 🧪. State the CI state in text; neither alone is blocked or a user wait. When several gates are open, the icon shows the actual main holding condition and the report names each other gate separately (Chat titles and status icons). Do not create an automation for one pipeline (CI observation). An application change is Ready only with its final verification handoff on the current candidate (Final functional verification). Before accepting that Ready, verify the handoff shows the actual screenshots and briefly summarizes the actual testing, or truthfully explains why an attachment is unavailable, unsafe, or irrelevant and supplies alternate technical evidence (Ready evidence packet). Otherwise keep Ready pending and return the exact gap to the owner; do not redo the QA. Ready never authorizes merge, task closure, or archive; keep the chat open for personal review (Personal review and finish). For a chat in authorized finish, verify its cleanup from its owner's durable cleanup record (Owned cleanup): the recorded nonsecret outcome, each inventoried thread-exclusive target removed and verified absent, shared, foreign, production, and uncertain resources left alone, and every blocker or user exception named. If owner evidence is missing, keep reconciliation pending. Return the exact gap only to an open owner chat under existing messaging authority; never reopen or revive a chat whose archive was verified merely because its report has not arrived. Never remove, prune, or archive an owner's resource or chat on the owner's behalf.

3. ACT ONLY WITHIN AUTHORITY
If an inactive owner has remaining authorized work with no pause or open user decision holding that work, and messaging that verified destination is authorized, send the specific remaining work once and verify that it took over. Do not repeat an instruction to an active owner unless there is new scope, authority, or a dependency. Keep one owner per resource, PR/MR, and QA environment. After a verified release of a shared resource, wake the next queued owner once under the implementation-orchestrator lifecycle's Shared resources section. Create a new realization chat only under its own explicit authority, and make its first handoff complete, including the instruction to use the development-executor skill and, where its scope involves Asana, the task destination (New realization chats). Update titles or icons only under recorded authority. Never create an issue without the user's specific GO for that issue; a proposal from a retrospective stays an open item that needs the user (Closeout). Never create a task without the user's explicit consent for that task. If one is authorized, assign it only to <TASK_ASSIGNEE>, and leave it unassigned if that value is none. Place an authorized task only in project <TASK_PROJECT>, section <TASK_SECTION>, chosen by the user in <TASK_DESTINATION_SOURCE>; that choice is not consent for any task. If the project or section is pending or none, do not create the task or pick a default; keep it as an open item for the specific missing choice. Before creating a task, obtain its due date and, only if the project's actual metadata shows a genuine priority field, its priority, unless the user already answered for that task; never reuse an answer from another task or store one in this instruction (New task due date and priority). After creation, read back the task's actual project and section memberships separately from its assignee and ANT Prio (Task destination), and read back any due date or priority written.

4. OPEN ITEMS AND REMINDERS (Authorized monitoring)
For each open item, keep the exact decision or action, what waits on it, chat, PR/MR, and task links, first announced, last reminded, response, and reminder policy. Remind the user only about items that need the user. This one monitor runs every <CHECK_INTERVAL> (default 15 minutes unless the user chose otherwise) and evaluates every unanswered decision on every run; <REMINDER_INTERVAL> (default 4 hours unless the user chose otherwise) is only an elapsed-time eligibility and cooldown condition checked inside this same run, never a second automation or schedule. By default a reminder is due only when <REMINDER_INTERVAL> has passed since the item was last raised. A date the user named replaces that; remind earlier only on recorded evidence of a deadline or worsening impact. After an explicit undated “odložit” or “nepřipomínat”, send no automatic reminder and do not resume the item automatically; keep it and its history, and show it when the user asks for status. Deferring one decision or action does not pause its chat unless the user's actual words say so, and a conversation about an item, or one that has gone quiet, is not a pause. Elapsed time is never approval.

5. SPEAK ONLY WHEN IT MATTERS (Status reports, Important notifications)
Report promptly a significant whole-scope Ready, a completion, a proposal awaiting a human decision, or an actual blocker. Bundle every due reminder and open question into one brief message. If nothing significant changed and no reminder is due, end silently.
Write the report in Czech as a Markdown table with exactly these headers:
| Úkol a odkazy | Co se řeší | Stav | Na co se čeká | Další krok / doporučení |
Give each task one row with its direct chat link and actual PR/MR, task, or other material link. Never invent a link. State the problem and benefit, real state and icon, who or what is awaited, and the next step with your recommendation. State the actual time once in <TIME_ZONE>. A single change is one row. Omit work that is completed, cleaned up, and archived. Below the table of an application Ready report, relay the owner's Ready evidence packet so the user sees the images and the testing summary.
Send a notification only through <NOTIFICATION_ROUTE>, unless it is none, and only for an event above, never for a routine phase or queue state. Use the route's own directly available secret; never search for or copy credentials. If it is unavailable or the send fails, tell the user. An accepted send does not prove device delivery.

6. RECORD
Record reminders and changed decisions where the initiative record's owner permits. Keep unverified state unknown.

7. STOP
Stop this monitor only when <STOP_CONDITION> is met: all agreed work has ended, or the user explicitly deferred it and no decision still subject to automatic reminders remains. Delete it through the actual automation tool and read back the result. A finished pipeline never ends this monitor.
```
