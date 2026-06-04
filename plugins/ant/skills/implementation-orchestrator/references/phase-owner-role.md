# Phase Owner

Use this internal reference for any role that owns a lifecycle phase or implementation subphase. The root orchestrator owns user-facing phases. The implementation lead owns `phases/06-implementation/` and any implementation subphases when the root delegates that artifact scope.

Structured run state is the source of truth; markdown phase artifacts are the human resume layer when active. Chat summaries are only UI. Before a phase transition, pause, stop, handoff, replacement worker, reviewer handoff, or completion report, update `state.json` and `events.jsonl` first, then update markdown artifacts when active or report exact artifact updates to the parent that owns the files.

For every orchestrated run, markdown is the human resume layer and the machine-readable source lives beside it:

```text
.ant/orchestrator/<run>/state.json
.ant/orchestrator/<run>/events.jsonl
```

Use `plugins/ant/contracts/orchestrator-state/` for the canonical schema, enums, event types, and UTC/Zulu timestamp rules. A phase owner that is delegated artifact ownership should update `state.json` whenever the current snapshot changes and append `events.jsonl` entries for durable lifecycle events. If the parent owns the run-level files, return the exact state/event updates needed instead of silently skipping them.

If the run has `preferredLanguage` in `state.json`, write future user-facing phase titles, markdown headings, phase summaries, checkpoints, event messages, and handoffs in that language. Supported values are `cs-CZ` and `en`. Do not translate or rewrite older artifacts when the preference is added or changed.

## Workspace Shape

Use this structure for new medium+ runs. For `Low` runs, the minimum required structure is `.ant/orchestrator/<run>/state.json` plus `.ant/orchestrator/<run>/events.jsonl`; add markdown files only when they improve resume or handoff value.

```text
.ant/orchestrator/
  active.md
  <YYYY-MM-DD-short-purpose>/
    index.md
    state.md
    state.json
    events.jsonl
    decisions.md
    handoff.md
    phases/
      01-intake/
        phase.md
        decisions.md
        handoff.md
      02-brainstorming/
        phase.md
        options.md
        decisions.md
        handoff.md
      03-discovery/
        phase.md
        findings.md
        decisions.md
        handoff.md
      04-direction/
        phase.md
        options.md
        decisions.md
        handoff.md
      05-planning/
        phase.md
        implementation-plan.md
        decisions.md
        review.md
        handoff.md
      06-implementation/
        phase.md
        implementation-plan.md
        decisions.md
        verification.md
        review.md
        handoff.md
        subphases/
          <NN-name>/
            phase.md
            decisions.md
            handoff.md
      07-review/
        phase.md
        findings.md
        decisions.md
        review.md
        handoff.md
      08-delivery/
        phase.md
        verification.md
        decisions.md
        handoff.md
```

Create only the phase folders needed for the run. Keep numbering stable once shared. If an old run already has root-level `implementation-plan.md`, keep it readable and link the canonical phase artifact from `index.md`.

## Required Phase Files

Every phase folder must contain at least:

- `phase.md` - status, owner, goal, inputs, work done, evidence, blockers, and close status.
- `decisions.md` - user decisions, safe assumptions, local decisions, and escalations. Every new user decision entry must include a full UTC/Zulu timestamp such as `2026-05-26T14:03:12Z`; do not write date-only user decisions.
- `handoff.md` - next phase handoff, files to read first, must-not-assume notes, open questions, active children, and next safe action.

Add phase-specific files when relevant:

- `findings.md` for scout or investigation evidence.
- `options.md` for strategy, architecture, rollout, or product choices.
- `implementation-plan.md` for planning and implementation subplans.
- `verification.md` for checks, manual validation, scenario evidence, and blocked checks.
- `review.md` for plan review, implementation review, findings, fix status, and re-review.

## Phase Close Gate

A phase is not complete until its folder records:

- status: `active`, `blocked`, `paused`, `ready-for-next-phase`, or `closed`;
- input: user messages, approved scope, parent prompt, relevant plan paths, and child reports used;
- work done: concise summary and changed artifact paths;
- decisions: user decisions, safe assumptions, autonomous decisions, and escalations;
- evidence: scout facts, validation, review results, or accepted residual risk;
- open questions and blockers;
- next phase handoff: what the next owner should do first;
- files to read first: run index/state plus phase-specific artifacts and key source paths from scouts/workers;
- must-not-assume notes: unresolved intent, forbidden edits, active workers, dirty-state constraints, and residual risks.

If any item is missing, keep the phase `active` or `blocked` and report what is needed before transition.

## Handoff Template

```md
# Phase Handoff

Status:

Input:

Work done:

Decisions:

Evidence:

Open questions / blockers:

Next phase handoff:

Files to read first:

Must not assume:

Active children:
```
