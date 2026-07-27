# Claude Code Routing Adapter

Set the root session to `best` plus `max` before invoking the orchestrator, and keep that session setting for its multi-turn discovery, approval, implementation, review, and retrospective workflow. Start Claude Code with `claude --model best --effort max`, or set durable session controls with `/model best` and `/effort max` before invoking `/ant:implementation-orchestrator`. Do not rely on skill or command frontmatter to guarantee a multi-turn root selection. Use stable aliases: `best` resolves to Fable when available, otherwise the latest Opus. Do not use `opusplan` for root because it switches to Sonnet during execution.

For bounded children, invoke the existing plugin-scoped profiles instead of merely naming a tier in the prompt: `ant:strong-high` (`opus` + `high`), `ant:balanced-high`, `ant:balanced-medium`, and `ant:controlled-low` (the matching `sonnet` effort), and `ant:fast` (`haiku`). Haiku has no effort selector, so use it only for narrow, non-judgment-sensitive work; use `ant:controlled-low` when explicit effort control is required.

Before dispatch, complete this observable, fail-closed preflight:

1. Choose the exact plugin profile. Do not pass a conflicting per-invocation model: it must be absent or exactly the profile's alias/model.
2. Inspect `CLAUDE_CODE_SUBAGENT_MODEL`. Accept only an unset value or the exact selected profile alias/model. `inherit` is a blocking override because it selects the parent model. Any other value blocks dispatch.
3. Inspect `CLAUDE_CODE_EFFORT_LEVEL`. For a fixed-effort profile, accept only unset or its exact intended `low`, `medium`, or `high`; `auto` is not exact and blocks. For `ant:fast` (Haiku, with no effort support), require no fixed effort override; unset or `auto` is acceptable.
4. When the host surfaces organization `availableModels` or effort caps, verify that they permit the exact profile model and intended effort. If the required state cannot be observed, block and report the limitation rather than claim enforcement.

A High-to-Medium clamp, per-invocation replacement, allowlist fallback, or environment override blocks dispatch even when it stays at or below High or broadly fits the role. After dispatch, if UI, task metadata, or transcript exposes a model or effort mismatch, immediately stop or cancel the child, discard its result, and report the mismatch. This secondary guard never replaces the preflight.
