# Decision Gates

Use this reference to keep intake digestible and to prevent implementation from starting with vague requirements.

## Grouped Intake

Ask related decisions together in short rounds and adapt wording to the selected communication level. Do not impose a fixed number of questions or rounds.

Example opening round when the host cannot inspect the local environment directly:

1. What are we building, who uses it, and what are the first 2-3 things users must do?
2. What data/auth/integrations are involved, and is any of it private or business-critical?
3. What can you run locally today: OS, Git, package manager/runtime, Docker, and target deployment if known?

Example opening round when the host can inspect the same machine/workspace directly:

1. What are we building, who uses it, and what are the first 2-3 things users must do?
2. What data/auth/integrations are involved, and is any of it private or business-critical?
3. Where should it run after the first version, and will anyone develop or maintain it on a different machine than this one?

After each round, continue with every unresolved material decision that cannot be discovered from the repository or environment. Stop only when those decisions are answered. Do not repeat discoverable questions or turn safe, non-critical details into a checklist; record safe assumptions only for non-material details.

## Required Intake End State

At the end of intake, state exactly one status:

- **Ready for architecture approval**: enough product, environment, and risk context exists to recommend a path and ask for approval.
- **Blocked by missing product decision**: the user must decide product behavior, scope, users, permissions, data ownership, or production expectations first.
- **Blocked by missing environment/tooling**: the recommended path requires missing tools, setup, credentials, repository access, or a cloud/dev environment decision.
- **Should use existing-platform/module workflow**: the request belongs inside an existing product/module/platform architecture rather than a standalone app creation path.
- **Not a create-application task**: the request is a small feature/fix/refactor or another workflow and should go directly to the appropriate skill or orchestrator flow.

Do not hand off to `implementation-orchestrator` until the status is `Ready for architecture approval`, the user approves the recommendation, and the handoff fields are filled.

## Status Format

```text
Intake status: Ready for architecture approval / Blocked by ...
Why:
Next decision needed:
What "pokračuj" would authorize:
```
