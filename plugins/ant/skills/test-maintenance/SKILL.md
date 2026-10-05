---
name: test-maintenance
description: Clean up, repair, or optimize an existing test suite when the user requests it or it is needed for the agreed implementation. Do not start broad test maintenance during unrelated work.
---

# Test Maintenance

Use this skill only for requested cleanup, repair, or optimization, or when such work is necessary to complete the agreed implementation. Do not turn ordinary implementation into a broad suite audit.

Analysis-only work stays read-only. For implementation-authorized maintenance, follow the [implementation-orchestrator lifecycle](../implementation-orchestrator/SKILL.md); this skill supplies the test-specific decisions within that workflow and grants no delivery authority.

Follow the shared [test-quality policy](../implementation-orchestrator/references/test-quality.md) to distinguish reusable setup from distinct scenarios, preserve regression protection and synchronization, classify failures, and bound performance claims.

Use repository-defined commands and run checks proportional to the affected tests. Report protections removed, combined, or retained and any unresolved failures without claiming unsupported suite-wide improvement.
