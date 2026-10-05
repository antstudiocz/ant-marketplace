---
name: test-design
description: Decide whether automated tests add useful protection, and design or review coverage for a specific change. Use during implementation planning, test changes, or independent review; do not use to launch broad test-suite cleanup.
---

# Test Design

Use this skill to decide whether coverage is warranted and to select meaningful scenarios, an observable oracle, and an appropriate test layer. For cleanup, repair, or optimization of existing tests, use [test-maintenance](../test-maintenance/SKILL.md).

Follow the shared [test-quality policy](../implementation-orchestrator/references/test-quality.md). Inspect repository guidance and existing tests before proposing coverage. Tie each proposed test to a distinct failure it can detect; account for setup side effects, mock boundaries, synchronization, and whether the assertion proves the contract. Keep recommendations proportional and use the project's documented commands.

When used through implementation-orchestrator, apply this policy during planning and test changes, then during independent review when automated coverage is part of the candidate. The orchestrator owns routing and evidence decisions; this skill does not create a separate required agent or check ceremony.
