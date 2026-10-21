---
name: deep-research
description: Run read-only, evidence-led investigations of a codebase, architecture, or incident when broad system discovery, independent specialist perspectives, and careful adjudication can improve a decision. Use for research and recommendations; use implementation-orchestrator when the requested outcome includes code changes.
metadata:
  short-description: Investigate systems with independent evidence reviews
---

# Deep research

Investigate a system-wide question and deliver a decision supported by evidence. Keep the investigated system read-only: this skill does not authorize code or configuration changes, provider spend, credential transfer, production experiments, external messages, or other system changes. Save sanitized research artifacts only to temporary or user-designated research locations. Hand off authorized implementation to [`implementation-orchestrator`](../implementation-orchestrator/SKILL.md).

## Set the boundary

- State the question, decision, scope, exclusions, evidence needed, and a proportionate time/tool budget. Ask when missing intent affects the decision; otherwise narrow claims and mark missing facts unknown rather than assume.
- Map the relevant end-to-end system: entry points, owners, data and authority boundaries, read/write paths, events, dependencies, configuration, runtime behavior, and operations. Follow applicable repository/domain guidance.
- Pin a common baseline for all researchers: source revision or deployment/version, relevant configuration and date, scenario, permitted evidence/tools, and known gaps. Refresh volatile facts before relying on them.
- Set a finite stopping condition. Stop when evidence supports the decision, the budget is reached, access is unavailable, or safe verification cannot resolve the uncertainty. Do not widen scope or loop indefinitely.

## Gather independent perspectives

- Use independent specialists when useful. Give each the same question, baseline, scope, and evidence rules, without other findings before its initial pass. Each dispatch packet states the assignment, shared budget, tool/data limits, whether delegation is allowed (default no), and report destination (root). Any authorized descendants inherit the same limits and budget. Assign perspectives to distinct boundaries or hypotheses; do not require a fixed team or round count.
- Honor requested models/providers/efforts after checking host support. If unavailable, disclose this and ask before substituting when it affects the decision. Repeated runs of one provider do not establish provider diversity; do not exceed user-authorized spend.
- For Codex, read the [Codex adapter](../implementation-orchestrator/references/codex.md); for Claude Code, read the [Claude Code adapter](../implementation-orchestrator/references/claude.md). Reuse host capability, permission, and identity checks for a fresh isolated read-only route. Their implementation profiles, Goal, and lifecycle are not research defaults. Honor user-selected routes only within host support and governing repository constraints, including explicit repository effort caps. Never bypass denied access or use an unapproved external route; report an unavailable perspective.
- Verify actual model/provider/effort from host invocation and usage evidence, not researcher self-report. Distinguish requested, available, and used routes; absent or denied metadata leaves provenance unverified.
- Match evidence to each claim: cite source paths/lines and revision for code/configuration facts; record runtime probes and conditions for behavior claims; label inference and unknowns. Source inspection is not runtime proof.

## Challenge and adjudicate

- Compare independent reports and cross-critique consequential claims against complete permitted reports and their evidence. If access limits review to supplied text, call it report synthesis, not a fresh source audit.
- Verify consequential claims against current primary evidence or a bounded, authorized reproduction. For incidents, separate current state from historical logs. Performance, resource, and scale benefits need reproducible measurements stating workload, environment, baseline, and method, with before/after comparison where feasible. Keep synthetic results within measured conditions; label production projections as estimates with assumptions and limits, never as measured production outcomes. Production experiments are not required.
- Resolve disagreements with direct evidence or safe reproduction, never majority vote. Mark claims confirmed, refuted, or unverified; when evidence is unavailable, name the exact missing verification.
- Preserve sound architecture and authority barriers. Compare the smallest alternatives, including keeping the current design, before recommending another cache, queue, service, or layer. Weigh end-to-end read/write/event, storage, operational, failure, and ownership costs against demonstrated needs. Test labeled hypotheses before treating their effects as established.

## Deliver the decision

- As root investigator, state the answer, decisive evidence, material gaps, alternatives, and ranked next steps. Keep it concise unless a full report is requested.
- Separate completed research from proposed work. Analysis does not authorize follow-on changes or external actions; identify the applicable handoff skill or approval boundary.
- Keep artifacts free of secrets and copied customer payloads; share only sanitized evidence needed for critique.
