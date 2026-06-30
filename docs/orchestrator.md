# Orchestrator Setup

Use `implementation-orchestrator` when a task needs an end-to-end workflow instead of a direct one-off answer.

The orchestrator is responsible for:

- checking git context and delivery expectations first;
- clarifying the goal and blocking product or technical decisions;
- planning the implementation shape before editing;
- delegating scouts, implementation leads, slice workers, and reviewers when useful;
- keeping validation and review loops explicit;
- handing off final delivery evidence and PR/MR readiness.

## First Use

1. Install the plugin from [docs/install.md](install.md).
2. Start a new Claude Code or Codex session.
3. Invoke the orchestrator:
   - Claude Code: `/ant:implementation-orchestrator`
   - Codex: `$implementation-orchestrator`
4. Give it the goal, relevant repo/path, and any delivery expectations.
5. Let it ask clarification questions before implementation starts.

## Codex Subagent Depth

For the full hierarchy `Root Orchestrator -> Implementation Lead -> Slice Worker/Reviewer`, Codex must allow spawned agents to spawn child agents:

```toml
[agents]
max_depth = 2
```

Add this to `~/.codex/config.toml`, then restart Codex or open a new session.

Without this setting, the orchestrator can still run in a flattened mode, but the implementation lead cannot spawn its own slice workers or reviewers.

## Model Routing

The root orchestrator model is selected by the user/session. During orchestration, route child agents by role and risk:

| Work class | Codex model | Codex reasoning | Claude Code tier | Use for |
|------------|-------------|-----------------|------------------|---------|
| Decision, lead, review, high-risk | `gpt-5.5` | `high` / `xhigh` | Opus | implementation lead, architecture, root-cause debugging, review, security, billing, tenant/data risk |
| Bounded small-medium work | `gpt-5.4-mini` | `low` / `medium` | Sonnet | read-only scouting, clearly scoped implementation slices, non-mutating checks |
| Tiny mechanical work | `gpt-5.3-codex-spark` | `medium` | Haiku | renames, copy/text edits, metadata updates, isolated low-risk changes |

Do not route new orchestrator child agents to `gpt-5.4` or `gpt-5.3-codex`.

If a smaller model hits ambiguity, conflicting evidence, contract changes, data/cache/permission risk, or review-level judgment, it must stop and escalate to `gpt-5.5` / Opus.

## Run State

Orchestrated runs should maintain local ignored structured state under:

```text
.ant/orchestrator/<run>/
```

The machine-readable contract lives in:

- [plugins/ant/contracts/orchestrator-state/README.md](../plugins/ant/contracts/orchestrator-state/README.md)
- [state.schema.json](../plugins/ant/contracts/orchestrator-state/state.schema.json)
- [event.schema.json](../plugins/ant/contracts/orchestrator-state/event.schema.json)

## Explainer

For a visual walkthrough of the lifecycle, root role, delegated subagents, review loop, and durable state, open:

[orchestrator-explainer.vercel.app](https://orchestrator-explainer.vercel.app/)
