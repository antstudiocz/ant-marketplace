# Approval Envelope Template

The authorization semantics are owned by `../policies/approval-policy.md`. Persist this shape in an allowed immutable source before mutation.

```yaml
approvalId: <stable-id>
operation: grant
scope:
  runId: <id>
  cycle: <id>
  phasesOrMilestones: [<ids>]
actions: [edit]
phaseApprovalPolicy: <manual|auto-after-verified|full-workstream>
verificationBoundaries: [<scenario/check requirements>]
stopConditions: [<conditions>]
grantor: <identity>
userTextOrEvidenceRef: <immutable text/ref>
grantedAt: <UTC/Zulu>
provenance: <host/session>
expiresAt: <UTC/Zulu|null>
noExpiry: <true|false>
supersedes: []
revokes: []
digest: <content digest>
```

User-facing summary:

```text
Approved workstream:
Automatic continuation boundary:
Verification required:
Delivery boundary:
Always stop for:
Exact reply that grants this envelope:
```
