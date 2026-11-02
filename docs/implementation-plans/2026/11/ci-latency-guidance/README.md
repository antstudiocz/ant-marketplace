# CI latency guidance

User authorizes the reviewed small test-policy clarification, PR creation, admin merge, and release.
Base: master32ef8de137db3326e9bc5fcaf3ce4c5f1ee974e9; previous releasev13.9.1.

Scope: existing shared test-quality policy only; include CI queue/dependency waiting in cost diagnosis and distinguish individual/summed job durations from pipeline critical-path latency. No new skills, hooks, frameworks or mandatory benchmark process. Release patch13.9.2 with synchronized manifests, concise release notes and index.

Owner: fresh Opus High implementation, no shell/MCP/nested delegation; root owns this plan, checks and delivery. Independent OpenAI reviewer read-only.
Checks: plugin validation both scopes, JSON/version coherence, diff check and manual normal/failure scenarios. Faster noncritical job must remain a component observation; unavailable queue evidence cannot prove whole-pipeline speedup. No runtime effectiveness claim.
Endpoint: reviewed exact candidate PR to master, verify provider checks/mergeability, user-authorized admin squash merge, release pinned to merged commit with PR and previous-tag comparison.

Freeze checkpoint: Opus authored scoped policy/release metadata; plugin validate both scopes, JSON/version coherence and diff check passed. Only existing icon warning; no runtime efficacy claim. Normal scenario: faster noncritical job remains a component observation; missing queue data leaves pipeline impact unproven. Independent exact-commit review pending before PR Ready/admin merge.
