# Decision Gates

Use this reference to keep intake short and to prevent implementation from starting with vague requirements.

## Minimum Viable Questions

Start with at most 3 grouped questions. Adapt wording to the selected communication level.

Good first round:

1. What are we building, who uses it, and what are the first 2-3 things users must do?
2. What data/auth/integrations are involved, and is any of it private or business-critical?
3. What can you run locally today: OS, Git, package manager/runtime, Docker, and target deployment if known?

Continue asking only when answers expose a real blocker, contradiction, or required decision. Do not turn intake into a long checklist when the missing detail is safe to decide later.

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
