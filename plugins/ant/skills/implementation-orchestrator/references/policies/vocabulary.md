# Canonical Vocabulary

This file is the normative owner for implementation-orchestrator terminology. Other references use these terms without redefining them.

- **Run** — one durable user workstream stored under `.ant/orchestrator/<run-id>/`.
- **Cycle** — one request inside a run, such as initial implementation, a follow-up, review fix, or delivery. Every cycle is risk-classified independently.
- **Phase** — an ordered lifecycle stage with one owner, entry conditions, close evidence, and a handoff.
- **Task** — a reviewable implementation unit inside a phase. A task has one write owner, a brief, validation, and a report.
- **Approval** — an explicit, scoped authorization whose provenance and integrity can be verified. Under state contract `1.0.0`, only the sources allowed by `approval-policy.md` authorize actions.
- **Approval envelope** — an approval that covers named phases/actions until a listed stop condition. It is not an unlimited authorization.
- **Checkpoint** — a durable progress snapshot that records status, evidence, blockers, ownership, and the next safe action. A checkpoint is not completion evidence by itself.
- **Validation** — a repeatable check of a named acceptance or risk scenario.
- **Evidence** — a record supporting a claim. Evidence levels and required fields are owned by `evidence-policy.md`.
- **Finding** — a review result with severity, evidence, required disposition, and status.
- **Blocker** — a condition that prevents the next safe transition or action.
- **Delivery** — approved repository or provider actions after implementation, including staging, commit, push, MR/PR, pipeline recovery, merge, or release.
- **Requested** — the capabilities, model class, reasoning class, history mode, nesting, or execution mode asked of a host adapter.
- **Actual** — the host-observed result. If the host does not report it, actual is `unknown`; requested must never be copied into actual.
- **Degraded** — a documented route that preserves approval boundaries and acceptance criteria with reduced capability or evidence strength.
- **Residual risk** — a named unverified or unresolved risk with an owner and explicit disposition. It is not the same as a passed check.
- **Lease** — exclusive writer ownership in the future `1.1` contract. State `1.0.0` has no typed lease; do not invent one. Under `1.0.0`, enforce one writer per path operationally and record ownership in existing agent/task metadata.

Machine enum values remain those defined by `plugins/ant/contracts/orchestrator-state/`; this vocabulary does not add schema values.
