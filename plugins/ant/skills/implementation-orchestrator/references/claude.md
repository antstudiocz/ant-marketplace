# Claude Code adapter

This adapter owns Claude-specific model, effort, and dispatch behavior. The shared rules are in [lifecycle.md](lifecycle.md). Native Goal support is optional unless the user explicitly requests it or the current host confirms that the current task already has one in use.

## Root and child preflight

- Root must be verified as `best` at `max`; `opusplan` is not a route.
- Claude must be version 2.1.219 or newer, ordinary root-level `Agent` dispatch must be available, and `CLAUDE_CODE_SUBAGENT_MODEL` must be unset or `inherit`.
- The child profile, model, effort, isolation, freshness, and allowlist must match the assignment. `CLAUDE_CODE_EFFORT_LEVEL` must be unset. If exact routing cannot be enforced, stop before tracked work.

| Role | Profile | Model + effort |
|---|---|---|
| Integration owner | `ant:balanced-high` | `sonnet` + High |
| Strong reviewer or strong judgment | `ant:strong-high` | `opus` + High |
| Bounded work | `ant:balanced-medium`, `ant:controlled-low`, or `ant:fast` | `sonnet` + Medium or Low |

Use one fresh isolated child context per assignment and never exceed High. The assignment must include the complete capsule from [lifecycle.md](lifecycle.md), including plan-directory read-only access, exact ownership, checks, delegation permission, and reporting. The independent reviewer never writes fixes.

## Smoke

Existing browser/E2E automation is ordinary risk-based outcome evidence. Choose appropriate interaction evidence automatically when changed behavior and risk require it: use existing browser/E2E automation or interactive smoke as suitable, including realistic states defined by the shared lifecycle; do not require a special smoke request. Preflight the environment and side effects when it applies. Evidence gathering never expands authority; reuse established authority and obtain appropriate explicit authorization for effects outside it, with destructive or data-loss actions explicitly authorized under the authority rules.
