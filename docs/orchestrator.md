# Orchestrator Setup

Use `implementation-orchestrator` when a task should be taken from repository discovery through verified implementation and optional delivery.

## First Use

1. Install the plugin from [the installation guide](install.md).
2. Start a new Claude Code or Codex session.
3. Set up the active host, then invoke the skill:
   - Claude Code: establish `best` + `max` for the session with `claude --model best --effort max`, or `/model best` and `/effort max`; then invoke `/ant:implementation-orchestrator`
   - Codex: select or verify the root for the task/session, then invoke `$implementation-orchestrator`; its adapter pins child spawns only
4. Provide the goal, repository or path, relevant constraints, and any delivery request.

The orchestrator discovers repository facts before asking questions, obtains approval for a concrete plan before tracked edits, keeps review proportional to risk, and reflects on the verified execution before completion or delivery.

## Planning And Approval

Every implementation starts with read-only repository discovery and a proportional plan that the user explicitly approves before tracked edits. A tiny mechanical change may need only a compact code check, stated delta, and validation plan; planning and approval are still present unless the change is already covered by an approved plan.

For a new feature or materially new behavior, the sequence is:

1. inspect the repository and relevant code paths;
2. brainstorm the goal, users, workflow, edge cases, non-goals, options, and tradeoffs with the user;
3. ask all material questions that cannot be answered from the repository, without an arbitrary question limit;
4. after the answers, analyze architecture, contracts, data, dependencies, obsolete behavior, risks, and validation more deeply;
5. present a concrete implementation plan and wait for explicit approval;
6. only then dispatch tracked implementation work.

Read-only scouts may help before approval. Fixes and refactors without new behavior use a shorter root-cause, impact, steps, risks, and checks plan. A user-provided concrete plan or approved `create-application` brief can satisfy earlier product brainstorming after repository verification, but the orchestrator still prepares an implementation plan and asks for approval before writes. That approval covers the stable workstream, not every phase.

## Execution Shape

The workflow deliberately stays small:

| Work | Default shape |
|---|---|
| Local and well understood | One implementation owner, then final independent review |
| Multi-file or moderately uncertain | One implementation lead, optional scout, then final independent review |
| Architecture, security, data, migrations, or broad contracts | Scouts as needed, one lead, disjoint slices, independent reviewer |

Claude Code and Codex may use different delegation trees. If nested agents are unavailable, the root dispatches the same bounded work directly. If no writer-capable native delegation is available at all, the root remains coordination-only and stops before tracked edits with a blocker. The acceptance criteria and review bar stay the same.

For Codex, nested lead/worker delegation can use:

```toml
[agents]
max_depth = 2
```

This is optional. Restart Codex or open a new session after changing its configuration.

## Capability Routing

Shared instructions route by capability rather than fixed model identifiers:

- **Strong:** architecture, difficult root-cause analysis, security/data decisions, integration ownership, and independent review.
- **Balanced:** normal implementation, integration, and repository investigation.
- **Fast:** exact searches, read-heavy discovery, and deterministic mechanical work.

The shared skill stays semantic and loads exactly one host adapter before any routing decision. Codex model names are current-catalog examples; Claude uses stable aliases. Neither is the permanent shared contract.

### Codex

Select or verify Codex root at task/session level: it is the strongest available route, currently `gpt-5.6-sol` at Max. Native spawn selectors cannot change an already-running root; they pin Strong children to Sol at High, Balanced children to `gpt-5.6-terra` at High, Medium, or Low, and Fast children to `gpt-5.6-luna` at Low or Medium when exposed. Luna-to-Terra at the same Low or Medium effort is the only fallback. Every child and nested child remains at High or below and never inherits root Max. Every Codex dispatch, including nested dispatch, sets `fork_turns="none"`; omitted, `all`, and positive bounded-history values are not allowed. Give the child a concise, self-contained assignment with every task-relevant fact. If root control is unavailable, report that maximum is unverified; if Sol, Terra, the requested child effort, or `fork_turns="none"` cannot be enforced, do not dispatch.

### Claude Code

Set `best` + `max` before invocation and keep it for the entire multi-turn workflow; skill or command frontmatter cannot guarantee the root selection. `best` resolves to Fable when available, otherwise the latest Opus. Do not use `opusplan` for root because it switches to Sonnet during execution.

Bounded children use the plugin-scoped profiles in `plugins/ant/agents/`: `ant:strong-high` (`opus` + high), `ant:balanced-high`, `ant:balanced-medium`, and `ant:controlled-low` (Sonnet at the named effort), and `ant:fast` (Haiku). Haiku has no effort selector, so use it only for narrow, non-judgment-sensitive work; use `ant:controlled-low` when explicit effort control is required.

Before dispatch, complete an observable, fail-closed preflight. Choose the exact plugin profile and pass no conflicting per-invocation model (it is absent or exactly the profile alias/model). Inspect `CLAUDE_CODE_SUBAGENT_MODEL`: accept only unset, `inherit` (the documented current behavior is unset), or the exact profile alias/model; any other value blocks. For fixed-effort profiles, inspect `CLAUDE_CODE_EFFORT_LEVEL` and accept only unset or the exact intended `low`, `medium`, or `high`; `auto` blocks. For `ant:fast` (Haiku, with no effort support), require no fixed effort override; unset or `auto` is acceptable. When host-visible organization `availableModels` or effort caps are surfaced, verify they allow the exact model and intended effort. If the state required to prove the route cannot be observed, block and report rather than claim enforcement. A clamp, replacement, allowlist fallback, or environment override blocks dispatch even when it stays at or below High. If UI, task metadata, or transcript later exposes a model or effort mismatch, immediately stop or cancel the child, discard its result, and report it; this is secondary to, never a substitute for, the preflight.

## Reasoning And Dispatch

Capability tier and reasoning effort are separate selections. Root uses the strongest capability and maximum available reasoning effort exposed by the active host for the entire orchestrated run. If the host cannot expose or set that control, root uses the strongest available root setting and reports the limitation without calling it maximum.

Every child dispatch pins a native model and, where that model exposes an effort selector, a supported effort explicitly. Children may use Low, Medium, or High effort, but never a host-specific level above High. A Strong child therefore does not imply above-High effort. Every assignment is concise and self-contained with the task-relevant facts; do not depend on inherited conversation history. Codex always dispatches with `fork_turns="none"`, including from nested children. If the host cannot prevent above-High inheritance or required context isolation safely, the child is not dispatched and the limitation is reported.

Typical assignments are High for implementation leads, independent review, and warranted architecture or security work; Medium for normal scouts, slices, checks, and delivery support; and Low or Medium for search and inventory. A child that cannot resolve work within High narrows or splits the assignment or returns the judgment to root. Final code review is Strong at High, while the execution retrospective remains root-owned at maximum.

Before spawning, the orchestrator checks whether an active agent already covers the same goal, evidence, and output. It steers that agent instead. New agents require materially distinct scope or evidence; overlap is reserved for intentional independent review with a distinct focus.

## Messages During Implementation

You can continue messaging the orchestrator while it works. Status questions and details within approved behavior do not stop work. Related material changes or corrections received during the same active segment are batched into one discovery, brainstorming, deeper-analysis, consolidated delta-plan, and approval cycle for the affected scope at the next safe boundary; only affected writes pause while independent work continues. An urgent stop or safety correction applies immediately. The entire run stops only for an explicit global stop/replacement or a genuinely blocking contradiction or safety issue.

Codex steering/queue controls and Claude Code message delivery are host-specific transport details; both follow the same behavior above.

## Validation

During implementation, the orchestrator runs checks targeted to each coherent phase. It does not run `FullTestSuite` or every repository check after each edit or small task.

After the final tracked mutation and required review, it runs the repository's full suite once on the exact final tree before declaring the implementation complete, whether or not delivery was requested. When delivery is requested, the same run is the final pre-delivery suite. A later relevant edit invalidates it: the orchestrator reruns the impacted check and refreshes the final suite once. For this marketplace, the two Claude plugin validations are the final broad suite.

## Execution Retrospective

After the final suite and before completion or delivery, root performs a bounded retrospective using evidence already present in the plan, messages, assignments and reports, final diff, and check results. It checks for a current correctness or verification gap and for avoidable total cost: duplicate reads or commands, overlapping agents or context, repeated polling or checks, work that could safely have been batched or deferred, premature broad validation, and reasoning or routing that was either needlessly expensive or too weak and caused rework. It preserves quality, reports at most three findings, does not reconstruct hidden reasoning, and does not invent token figures.

A current implementation gap returns to the implementation owner and invalidates the final suite until the correction, targeted checks, focused review, and refreshed suite pass. Only a material, actionable, plausibly generalizable process improvement can become upstream feedback. Before any external search, root removes client, project, and proprietary details from the candidate and derives generic, non-sensitive search terms. It then uses only those terms to search open and closed issues and PRs in `antstudiocz/ant-marketplace` and proposes at most one highest-value issue action. Creating or commenting on an issue requires explicit current or clearly applicable standing approval; implementation or delivery approval is not enough. Missing network or authentication does not block the original result.

The retrospective never creates a PR automatically. A PR is a separate approved maintenance implementation and uses the host-visible merge-request skill after its own discovery, implementation, review, and validation.

## Delivery

The orchestrator performs only the delivery actions the user requested. For PR/MR creation and updates it invokes the host-visible skill identifier: Claude Code `/ant:merge-request` or Codex `$merge-request`. For merge conflicts it uses Claude Code `/ant:delivery-workflows` or Codex `$delivery-workflows` only. Merge, Draft-to-ready conversion, tag, publish, and release are never implied by commit, push, or PR creation.

The final report includes the changed areas, checks run, unverified items, retrospective outcome, any material upstream issue URL or candidate, and current commit/PR/MR state.
