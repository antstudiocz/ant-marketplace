# Claude Code Routing Adapter

## Native Plan and Goal

- For implementation-authorized or later-approved work with a stable verified objective, use Claude Code's native Plan to record phases or waves, dependencies, acceptance behavior, continuity mode, checks, and authorized delivery, with one top-level item `in_progress`. Actual concurrent workers are represented by native agent/thread state.
- Before tracked-writer dispatch, inspect the native Goal when the host exposes it and reuse only a semantically matching active Goal.
- If native Goal state cannot be observed or managed, report that limitation and stop before tracked writes. Do not substitute `/goal`, `/plan`, a pseudo-plan file, or a manual state contract.
- The Goal condition must be measurable and include the verified outcome, acceptance conditions, material constraints, required checks, and only delivery already authorized.
- An observable unrelated active goal must be cleared or replaced by the user before tracked execution. Do not add Stop hooks, a runtime, or synthetic state.
- A goal is complete only after its scoped implementation, required review, final validation, retrospective, and any delivery included in the condition are actually complete.
- Stable in-scope follow-ups amend the native Plan and Goal; material scope or contract changes require a delta decision and authorization.

## Root routing

- Set the root session to `best` plus `max` before invoking the orchestrator, and keep that setting for the entire multi-turn discovery, authorization, implementation, review, and retrospective workflow.
- Start Claude Code with `claude --model best --effort max`, or set durable session controls with `/model best` and `/effort max` before invoking `/ant:implementation-orchestrator`. Do not rely on skill or command frontmatter to guarantee a multi-turn root selection.
- Use stable aliases: `best` resolves to Fable when available, otherwise the latest Opus. Do not use `opusplan` for root because it switches to Sonnet during execution.

## Child routing

For bounded children, invoke the existing plugin-scoped profiles instead of merely naming a tier in the prompt:

| Profile | Model + effort | Notes |
|---|---|---|
| `ant:strong-high` | `opus` + `high` | Strong roles, including final independent review |
| `ant:balanced-high` | `sonnet` + `high` | Normal implementation and integration leads |
| `ant:balanced-medium` | `sonnet` + `medium` | Scouts, slices, validation |
| `ant:controlled-low` | `sonnet` + `low` | When explicit low effort control is required |
| `ant:fast` | `haiku` | No effort selector; only narrow, non-judgment-sensitive work |

## Dispatch preflight

Complete this observable, fail-closed preflight before every dispatch:

1. Choose the exact plugin profile. Do not pass a conflicting per-invocation model: it must be absent or exactly the profile's alias/model.
2. Inspect `CLAUDE_CODE_SUBAGENT_MODEL`. Accept only an unset value or the exact selected profile alias/model. `inherit` is a blocking override because it selects the parent model. Any other value blocks dispatch.
3. Inspect `CLAUDE_CODE_EFFORT_LEVEL`. For a fixed-effort profile, accept only unset or its exact intended `low`, `medium`, or `high`; `auto` is not exact and blocks. For `ant:fast` (Haiku, no effort support), require no fixed effort override; unset or `auto` is acceptable.
4. When the host surfaces organization `availableModels` or effort caps, verify they permit the exact profile model and intended effort. If the required state cannot be observed, block and report the limitation rather than claim enforcement.

A High-to-Medium clamp, per-invocation replacement, allowlist fallback, or environment override blocks dispatch even when it stays at or below High or broadly fits the role. After dispatch, if UI, task metadata, or transcript exposes a model or effort mismatch: immediately stop or cancel the child, discard its result, and report the mismatch. This secondary guard never replaces the preflight.

## Runtime smoke mapping

For executable, runtime, or user-visible changes, after the final suite and before readiness:

1. Discover the testing surfaces actually exposed by the Claude Code host and repository. Keep this mapping generic to host capabilities and never invent selectors.
2. Offer every applicable available surface, explain its concise implication, state the exact Plan flows, preconditions, expected observables, and evidence to capture, and give exactly one evidence-based recommendation for the user's choice (unless an explicit prior tool choice applies).
3. If only one surface is available, say so; if none is available or smoke is not meaningful, report N/A and why.
4. After selection, run the smallest realistic smoke scenarios and report environment, repository head, expected versus observed results, side effects or auth/data constraints, gaps, and screenshots for meaningful checkpoints or failures when the selected surface supports them. Screenshots supplement assertions and must protect secrets and private data.
5. A required smoke that fails, is unavailable, or is declined affects readiness; an optional declined smoke is reported unverified without an invented blocker. A smoke-discovered gap returns to implementation and requires targeted checks, focused re-review, a refreshed final suite, and repeat of the affected smoke after mutation.
