# Orchestrator Setup

Use `implementation-orchestrator` when a task should be taken from repository discovery through verified implementation and optional delivery.

## First Use

1. Install the plugin from [the installation guide](install.md).
2. Start a new Claude Code or Codex session.
3. Invoke the skill:
   - Claude Code: `/ant:implementation-orchestrator`
   - Codex: `$implementation-orchestrator`
4. Provide the goal, repository or path, relevant constraints, and any delivery request.

The orchestrator discovers repository facts before asking questions, delegates tracked edits, keeps review proportional to risk, and reports what was actually verified.

## Execution Shape

The workflow deliberately stays small:

| Work | Default shape |
|---|---|
| Local and well understood | One implementation owner |
| Multi-file or moderately uncertain | One implementation lead, optional scout or reviewer |
| Architecture, security, data, migrations, or broad contracts | Scouts as needed, one lead, disjoint slices, independent reviewer |

Claude Code and Codex may use different delegation trees. If nested agents are unavailable, the root dispatches the same bounded work directly. The acceptance criteria and review bar stay the same.

For Codex, nested lead/worker delegation can use:

```toml
[agents]
max_depth = 2
```

This is optional. Restart Codex or open a new session after changing its configuration.

## Capability Routing

Shared instructions route by capability rather than fixed model identifiers:

- **Strong:** architecture, difficult root-cause analysis, security/data decisions, integration ownership, and independent review.
- **Balanced:** normal implementation, integration, and repository investigation.
- **Fast:** exact searches, read-heavy discovery, and deterministic mechanical work.

Current Codex examples for this release are `gpt-5.6` for demanding work and `gpt-5.6-terra` for light or read-heavy work. Leaving a child unpinned can let Codex balance quality, speed, and cost. These names are examples from the current Codex catalog, not requirements in the shared skill.

Claude Code applies the same Strong/Balanced/Fast intent through the models and effort controls available in the active Claude environment. The workflow does not assume that Claude and Codex expose identical selectors.

## Adaptive Reasoning

Reasoning is reassessed while work is active, not chosen once at startup:

- escalate when evidence conflicts, risk broadens, validation repeatedly fails, or a new contract/security/data boundary appears;
- de-escalate when a decision is settled and the remaining work is deterministic;
- keep the stronger setting through the uncertain segment to avoid rapid switching;
- when an active agent cannot change in place, steer it if supported or apply the new level at the next bounded dispatch.

Model choice, reasoning effort, permissions, and delivery authority remain separate concerns.

## Messages During Implementation

You can continue messaging the orchestrator while it works. Status questions and additive non-conflicting changes do not stop unaffected work. Corrections replan only the impacted scope. The entire run stops only for an explicit global stop/replacement or a genuinely blocking contradiction or safety issue.

Codex steering/queue controls and Claude Code message delivery are host-specific transport details; both follow the same behavior above.

## Validation

During implementation, the orchestrator runs checks targeted to each coherent phase. It does not run `FullTestSuite` or every repository check after each edit or small task.

At the final pre-delivery boundary it runs the repository's full suite once on the exact final tree. If a later relevant edit occurs, it reruns the impacted check and refreshes the final suite once. For this marketplace, the two Claude plugin validations are the final broad suite.

## Delivery

The orchestrator performs only the delivery actions the user requested. `merge-request` is the sole PR/MR creation and update workflow; `delivery-workflows` is only for merge conflicts. Merge, Draft-to-ready conversion, tag, publish, and release are never implied by commit, push, or PR creation.

The final report includes the changed areas, checks run, unverified items, and current commit/PR/MR state.
