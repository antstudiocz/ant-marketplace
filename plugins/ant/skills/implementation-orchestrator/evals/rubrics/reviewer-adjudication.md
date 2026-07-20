# Baseline reviewer adjudication

For each changed case or golden, verify:

1. The classification matches the source rule and does not label a defect as
   expected behavior.
2. Required and forbidden actions represent the scenario's safety boundary.
3. Requested routing and simulated actual values remain separate; checked-in
   traces use only `synthetic-` evidence labels.
4. The structural assertions prove more than serialized snapshot equality.
5. Any normalized field is nondeterministic and cannot carry approval,
   capability, routing, or action-result evidence.
6. `edge.type` appears only in the synthetic invalid fixture.

Record the specification-review result as `approved`, `needs-fixes`, or
`cannot-verify`. This approves only fixture/rubric quality, never live-host
behavior. A changed golden must not be accepted without that independent
adjudication.
