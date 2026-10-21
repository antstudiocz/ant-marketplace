# Claude Code adapter

This adapter owns Claude-specific model, effort, and dispatch behavior. The shared rules are in [lifecycle.md](lifecycle.md). Native Goal support is optional unless the user explicitly requests it or the current host confirms that the current task already has one in use.

## Root and child preflight

- Root must be verified as `best` at `max`; `opusplan` is not a route.
- Claude must be version 2.1.219 or newer, ordinary root-level `Agent` dispatch must be available, and `CLAUDE_CODE_SUBAGENT_MODEL` must be unset or `inherit`.
- The child profile, model, effort, isolation, freshness, and allowlist must match the assignment. `CLAUDE_CODE_EFFORT_LEVEL` must be unset. Do not dispatch an assignment if its exact route cannot be enforced; continue other independently authorized work. An unavailable cross-provider reviewer leaves required review pending.

| Role | Profile | Model + effort |
|---|---|---|
| Integration owner | `ant:balanced-high` | `sonnet` + High |
| Anthropic strong judgment or focused review | `ant:strong-high` | `opus` + High |
| Bounded work | `ant:balanced-medium`, `ant:controlled-low`, or `ant:fast` | `sonnet` + Medium or Low |

For independent overall review, follow the [review policy](review.md). Use a verified route from the provider opposite the implementation author: Claude models can review OpenAI-authored work, while Anthropic-authored work requires an OpenAI route. The default Codex CLI route is a fresh `codex exec` session with an explicitly selected verified OpenAI model and `--sandbox read-only`; verify identity, availability, and the effort ceiling before dispatch. Preserve an explicit user model choice under the canonical policy. A focused review supplements the overall review; a strong-judgment route may serve as overall reviewer when its provider is opposite the source author and it meets the independence requirements.

## Read-only research dispatch

For a Claude Code researcher, use a fresh, noninteractive `claude -p` process rather than implementation-only agent profiles. Check `claude -p --help` for current options and honor an explicit user model/effort choice within host support and governing repository limits. The read-only route uses safe and restricted modes, a read-only tool allowlist, no MCP configuration, and denied permission prompts:

```text
claude -p --safe-mode --restricted --model MODEL_VALUE --effort EFFORT_VALUE --permission-mode dontAsk --tools 'Read,Grep,Glob' --allowedTools 'Read,Grep,Glob' --strict-mcp-config --no-session-persistence --output-format stream-json --verbose
```

Replace the placeholders with the verified requested route and pass the complete dispatch packet on stdin, including the research instructions and applicable repository guidance because safe mode disables their automatic discovery. Do not add write, shell, network, MCP, or remote-control capabilities. Inspect host output for the actual model, usage, errors, and permission denials; if the route or restrictions cannot be verified, mark that perspective unavailable. This is a research-only route and does not change the implementation profiles or lifecycle above.

For implementation child assignments, use one fresh isolated context per assignment and never exceed High. The assignment must include the complete capsule from [lifecycle.md](lifecycle.md), including plan-directory read-only access, exact ownership, checks, delegation permission, and reporting. The independent reviewer never writes fixes.

## Smoke

Existing browser/E2E automation is ordinary risk-based outcome evidence. Choose appropriate interaction evidence automatically when changed behavior and risk require it: use existing browser/E2E automation or interactive smoke as suitable, including realistic states defined by the shared lifecycle; do not require a special smoke request. Preflight the environment and side effects when it applies. Evidence gathering never expands authority; reuse established authority and obtain appropriate explicit authorization for effects outside it, with destructive or data-loss actions explicitly authorized under the authority rules.
