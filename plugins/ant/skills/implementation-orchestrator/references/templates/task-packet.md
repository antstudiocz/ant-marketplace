# Task Packet Template

Use this shape for every delegated child. Fill it from durable artifacts; never attach the parent conversation.

```text
Role and parent:
Required capabilities:
Complexity tier and signals:
Requested reasoning tier and elevation reason, if any:
Runtime capability artifact ref:
Route request id and requested fields:
Observed actual/unknown reasoning and host value, evidenceSource, and fallbackReason:
Execution/permission mode (independent from reasoning):

Delegation contract:
- This is a precise fresh assignment, not a forked conversation.
- Use only this packet and the named artifacts.
- If inherited chat is visible, ignore it and report `Delegation violation: inherited conversation history`.

Goal:
Approved plan / decision refs:
Run / cycle / phase:
Preferred language:

Owned scope and paths:
Allowed reads:
Allowed writes:
Forbidden areas and actions:
Non-goals:
Contracts and safe assumptions:
Dirty-state / unrelated-change constraints:

Artifacts to read first:
Validation and evidence expected:
Checkpoint expectations:
Escalate when:
Exact output format:
```

For task-scoped implementation, add brief/report paths and require status `DONE`, `DONE_WITH_CONCERNS`, `BLOCKED`, or `NEEDS_CONTEXT`.
