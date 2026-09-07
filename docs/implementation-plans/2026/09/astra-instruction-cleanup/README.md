# Astra instruction cleanup

- Status: ready; phase: delivery.
- Objective: simplify and correct instructions, then deliver a reviewed draft PR to master.
- Scope: Rewrite plugin instruction entrypoints, lifecycle/adapters and maintainer/user docs. Keep exactly three skills, native delegated owner and independent reviewer, explicit routes capped at High, automatic authorized Goals, authority and review invariants. No runtime or model migration. Preserve brand assets and immutable release notes.
- Continuity: in-place evolution in an isolated worktree.
- Authority: user explicitly approved this rewrite and PR/MR creation, including scoped commit/push; no merge, release publication or deployment. User explicitly requests automatic Goal creation for implementations.
- Findings: prior audit identified repeated orchestration, unconditional reading/questions, a 65 KB Marketing entrypoint, obsolete paths and Google/GA4 runtime guidance. Verify against the current target checkout before editing.
- Decisions: each rule has one canonical owner; use concise bullets, conditional references and proportionate checks. Keep repo conventions separate from product chat. Do not silently change route policy or drop safety/domain constraints.
- Ownership: root owns only this planning bundle, adjudication and delivery; one Luna High integration owner owns scoped instruction/config/docs edits; independent Sol High reviewer is read-only. Children cannot write this plan directory.
- Acceptance: coherent instructions, valid metadata/links/discovery, preserved domain knowledge and explicit authority boundaries; draft PR/MR with truthful verification.
- Checks: skill YAML validation, symlink/reference resolution, diff whitespace and scoped semantic review; plugin manifest validation where applicable. No application suites for instruction-only edits. CI observed for final head within a finite budget.
- Risks: deletion of useful invariants, contradictions between runtime and developer guidance, host Goal authority, accidental process gates.
- Candidate: finalize plan before freeze; tracked mutations invalidate affected review/checks.
- Resume from here: commit the frozen scoped candidate, open a draft PR to master, and report exact-head check status without changing this plan.
- Implementation checkpoint: owner rewrote 20 instruction/doc/profile files; preserved 3 public skills, routes, ownership, Goal and brand corpus. Native Codex installation documentation replaces the external installer path. Both Claude manifest validations, JSON parsing, YAML parsing, local links and whitespace checks passed; root will run bundled skill validator with available Python environment.
- Review checkpoint: independent Sol High reviewer approved after restoring source-branch checkout, authorized Create/update regression handoff, scoped staging/validation/no-attribution and the two-cycle escalation bound.
- Retrospective: simplification must retain operational decision boundaries; those four repairs keep the leaner guidance safe. No public skill, model route, brand asset or release/version change.
- Final gate: root confirmed all 3 skill validators; run both Claude manifest validators, JSON parsing and diff whitespace on the frozen tree. GitHub repository has no workflow files; absence of checks will be reported as unverified rather than green.
