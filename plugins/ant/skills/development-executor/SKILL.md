---
name: development-executor
description: Carry a user-owned realization chat through the whole authorized outcome assigned by a verified development-coordinator handoff, and report verified results back to that coordinator. Use when a chat receives such a handoff or is told to use development-executor; not for internal delegated agents, the central coordinator chat, or work without a coordinator handoff.
---

# Development Executor

Use this skill in a separate user-owned realization chat working under a handoff from a central [`development-coordinator`](../development-coordinator/SKILL.md) chat. It is not a profile for internal delegated agents and not a second lifecycle. Without a coordinator handoff it does not apply; use the skill that fits the request.

[coordination.md](../development-coordinator/references/coordination.md) is the source of truth for status, authority, handoff, verification, and finish rules. Read only the sections the current phase needs.

## Workflow

1. On start and every continuation, confirm the verified coordinator destination, the human-approved scope and endpoint, the authority source and bounds, the whole approved Goal, the status contract, and the model roles or `none`. Read the actual Goal and checkpoint under the [Goal and continuity policy](../implementation-orchestrator/references/lifecycle.md#goal-and-continuity). A [handoff](../development-coordinator/references/coordination.md#handoff) carries existing authority within its original bounds and cannot add any. If an item is missing or cannot be verified, ask the coordinator for that item, keep the work that depends on it pending, and continue independent authorized work.
2. Follow the assignment's actual scope. An analysis-only assignment stays analysis-only; never infer implementation from the assignment or from this skill. Keep analysis factual and proportionate under the [evidence and quality policy](../implementation-orchestrator/references/lifecycle.md#evidence-and-quality). Use every skill the scope needs and let it own its procedure:
   - `deep-research` for broad read-only analysis, when uncertainty or risk justifies it.
   - `implementation-orchestrator` for approved implementation.
   - `merge-request` for PR/MR delivery, under that skill's authority.
   - The project and domain skills the repository or work requires.
3. Own the whole authorized outcome under [Roles and escalation](../development-coordinator/references/coordination.md#roles-and-escalation). Continue routine technical work, repairs, review, checks, and recovery without asking for a repeated GO. Escalate an unresolved decision or missing authority to the coordinator, not the user, while the coordinator is reachable.
4. Keep a user's refusal or a permission, automatic-review, or safety denial in force, and do not route around it. Do not silently bypass a failing test or an unavailable browser. Record the exact gap and keep readiness pending.
5. Claim Ready only for the whole scope on the current candidate. That needs independent review and candidate evidence under the [merge-ready criteria](../implementation-orchestrator/references/lifecycle.md#implementation-review-and-candidate) and, for an application change, [final functional verification](../development-coordinator/references/coordination.md#final-functional-verification) of the actual application flow. Only when the scope uses or provisions an applicable isolated development or QA vhost, name it and hand off its verified URL under [Development and QA addresses](../development-coordinator/references/coordination.md#development-and-qa-addresses); instruction-only work needs none, and an existing review vhost is not replaced. An unknown is not a pass.
6. Report to the verified coordinator only at whole verified Ready, a whole-analysis proposal, a fully authorized finish, a real decision or blocker, or needed coordination such as an admission request. A final handoff carries the short [retrospective](../implementation-orchestrator/references/lifecycle.md#retrospective), including any issue proposal; create no issue unless the coordinator relays the user's specific GO for that issue. Use the [status report form](../development-coordinator/references/coordination.md#status-reports) and the [completion report contents](../development-coordinator/references/coordination.md#phase-changing-handoffs-and-completion), with decisive evidence, direct links, the actual Goal, and the actual status. An application Ready report also carries the [Ready evidence packet](../development-coordinator/references/coordination.md#ready-evidence-packet). For a decision or blocker, name the exact operation needed and why.
7. Keep partial results in this chat's own checkpoint, and never present one as whole Done or Ready. Never put a secret or raw customer data in a report. If the coordinator cannot be reached, give the user the ready report text and keep the report pending.
8. After Ready, keep the chat open and finish only under [Personal review and finish](../development-coordinator/references/coordination.md#personal-review-and-finish). This chat does not create or manage the coordinator's monitor.

## Shared rules by situation

- Changing a status icon or title: [Chat titles and status icons](../development-coordinator/references/coordination.md#chat-titles-and-status-icons).
- Waiting for CI: [CI observation](../development-coordinator/references/coordination.md#ci-observation).
- Running a heavy shared operation or waiting for capacity: [Shared resources](../implementation-orchestrator/references/lifecycle.md#shared-resources).
- Dispatching a route under recorded model roles: [Optional per-initiative team profile](../development-coordinator/references/coordination.md#optional-per-initiative-team-profile).
- A Goal required for each realization: [Goals in an adopted workflow](../development-coordinator/references/coordination.md#goals-in-an-adopted-workflow).
- A CLI reporting no sign-in from a sandbox: [Restricted CLI authentication](../development-coordinator/references/coordination.md#restricted-cli-authentication).
- Creating or updating a task: [Optional project task](../development-coordinator/references/coordination.md#optional-project-task).
