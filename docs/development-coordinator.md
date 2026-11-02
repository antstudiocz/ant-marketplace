# Development coordinator

The development coordinator keeps one approved multi-chat effort aligned. The central chat uses the initiative's designated record and reconciles evidence; the record's owner maintains it. Realization chats own the work assigned to them. Use this role only when the user explicitly invokes it.

## How work moves

This is a conceptual overview, not an authorization or status state machine. The [canonical coordination reference](../plugins/ant/skills/development-coordinator/references/coordination.md) defines native handoff and readback steps, permission boundaries, status precedence, evidence gates, and closeout rules.

```mermaid
flowchart TD
    U[User agrees outcome, scope, and permissions] --> C[Coordinator reads the checkpoint and actual Goal]
    C --> H[Coordinator sends scoped work through a verified, authorized handoff]
    H --> W[Realization chat analyzes or implements approved scope]
    W --> V[Run review and verification that apply to the agreed outcome]
    V --> P[Realization verifies Goal and checkpoint; reports icon, evidence, gaps, and remaining work]
    P --> R[Coordinator reconciles current evidence, chat state, title, and permissions]
    R --> N{What is the next authorized step?}
    N -->|Assigned work remains with the current owner| W
    N -->|A separate scoped handoff is needed and authorized| H
    N -->|Essential user decision or input is needed| A[Ask with the source-chat link, PR/MR link, exact action, and reason; routine merge approval stays ✅]
    A -->|After the user responds| C
    N -->|Record the achieved endpoint and its actual status| E[Keep analysis, draft, merge-ready, merged, and deployed distinct]
    E -->|Canonical merge-ready criteria pass and merge is separately authorized| M[Authorized realization owner performs the merge; verify with the provider]
    M -->|Provider confirms merge| F[Run authorized closeout; use 🧹 only for authorized cleanup]
    M -->|Merge is unconfirmed| E
```

Analysis produces evidence and a recommendation; it does not authorize implementation. Start implementation only within user-approved scope, using [implementation-orchestrator](../plugins/ant/skills/implementation-orchestrator/SKILL.md). PR/MR delivery stays with the realization chat using [merge-request](../plugins/ant/skills/merge-request/SKILL.md).

## Optional per-initiative team profile

This user-specific example applies only to an initiative whose existing checkpoint records the user's selection under “Decisions and authority.” The coordinator carries it in the handoff; the receiving realization chat applies it only to newly dispatched role routes, ahead of adapter defaults for those routes. Work the coordinator or root realization chat performs itself stays on that chat's actual host model and outside the profile. The profile does not change other routes or global adapter defaults. If the route or its scope is unclear, ask the user; unsupported routes stay pending and are never silently replaced.

| Work | Model and effort |
|---|---|
| Bounded helper, investigation, validation, or narrow delegation | GPT-6.1 Terra / High |
| Deep research perspectives | GPT-6.1 Sol / High and Claude Opus / High; no Luna deep-research route |
| Implementation | Claude Opus / High |
| Independent implementation review | GPT-6 Astra / Medium when its provider is opposite the verified implementer's provider |

The independent implementation review is a separate Astra route dispatched by the realization chat; a reviewer nested under Opus implementation does not qualify. The 🔎 status means analysis is active; it is not a model assignment. The dispatching realization chat distinguishes bounded work from deep research, asking the user if unclear. Deep research stays incomplete until both Sol and Opus contribute with verified model identity and effort. If either route is unavailable or provenance is unverified, report partial work and leave research incomplete unless the user explicitly accepts a partial result; record that choice. Other unsupported routes remain pending until the user explicitly chooses an alternative. For each selected route, report actual model and effort or mark them unverified. Record the exact host-reported Opus version; any Claude Opus version matches this profile unless the user pins one.

Use the [handoff capsule and routing safeguards](../plugins/ant/skills/development-coordinator/references/coordination.md#optional-per-initiative-team-profile) for host-availability checks, provider independence, and unsupported-route handling. If Astra is not opposite-provider to the verified implementer, report the independence gap and wait for the user's explicit choice. Existing running work and historical review evidence keep their actual model identity; a preference for future dispatch does not restart either.

## Reports and decisions

On start and continuation, each realization chat checks its actual Goal and checkpoint under the host's canonical lifecycle. It reports the verified endpoint, its own status icon when authorized, evidence, and remaining work to the coordinator. A completed Goal does not end an effort that still has feasible authorized work. Do not duplicate a canceled Goal, claim an unsupported resume, invent a blocker, or keep repeating an unanswered question.

The coordinator reconciles a report against current evidence and the shared record. A report triggers verification; it does not grant authority or prove readiness by itself. Ask only for a decision or input that is actually needed, with links to the source chat and relevant PR/MR, the exact operation, and why it is needed.

## Titles, status, and closeout

Get approval before applying or changing a chat's semantic base title. Realization chats own ordinary updates to their leading status icon; the coordinator checks relevant reports and corrects a stale icon only under the same user-granted authority. Icons show the semantic phase, not whether a task is idle or a sub-operation is running. ✅ means the current candidate is merge-ready, not merged or deployed; it stays ✅ when only routine merge approval remains. Report preview availability separately. ⏳ means an essential user decision/input is needed; 💤 means the user explicitly deferred the whole scope. The [canonical title and icon glossary](../plugins/ant/skills/development-coordinator/references/coordination.md#chat-titles-and-status-icons) defines state meanings, precedence, and terminal behavior.

After provider-confirmed merge, any cleanup still needs its own authority. 🧹 describes that authorized cleanup phase when status-label management is authorized; it grants no cleanup, task-write, merge, or archive permission. Update a task only with verified mapping and write authority, and archive only a specifically requested target. Report incomplete closeout accurately; do not imply deployment without runtime evidence.
