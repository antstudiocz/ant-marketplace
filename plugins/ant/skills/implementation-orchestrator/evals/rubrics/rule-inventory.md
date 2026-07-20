# Normative rule inventory for the synthetic 9.0.9 specification

This inventory maps source rules to synthetic cases. It does not claim the
cases were captured from a live host.

| Rule | Current sources | Baseline cases | Duplication note |
| --- | --- | --- | --- |
| Root stays dispatch-only and delegates implementation. | `SKILL.md` core model and required flow; `references/lifecycle.md` delegation gate. | `codex-native-high`, `claude-flat-named` | Same boundary is intentionally repeated at public and lifecycle layers. |
| Child context must be fresh/no-history or dispatch stops. | `SKILL.md` liveness rule; `references/lifecycle.md` no-history and task packet rules. | `codex-native-high`, `codex-flattened-high`, `codex-no-history-unsupported`, `claude-flat-named` | The public rule and executable role template overlap; no behavior is changed here. |
| Each request/follow-up receives fresh risk classification. | `SKILL.md` risk-tier model; `references/lifecycle.md` risk dispatch guidance. | `follow-up-fresh-cycle`, `review-fix-fresh-risk` | Current state metadata is a display hint, not future authorization. |
| Startup asks remaining user-owned blockers without repeating known choices. | `SKILL.md` startup contract; `references/lifecycle.md` intake/startup sections. | `codex-startup-low`, `codex-startup-medium`, `codex-startup-high` | Current prose is split between public flow and lifecycle detail. |
| Stored run state and durable events precede resume/delegation work. | `SKILL.md` persistence bootstrap; `references/lifecycle.md` state/event requirements. | `compaction-recovery` | Repeated as public gate and phase-owner discipline. |
| Review cannot approve when required orchestration context is missing. | `references/reviewer-role.md`; `references/lifecycle.md` reviewer template. | `review-manifest-missing` | Reviewer role is the detailed owner; lifecycle repeats the minimum gate. |
| Delivery is explicit; declining delivery prevents stage/commit/push/MR work. | `SKILL.md` delivery flow; `references/lifecycle.md` post-verification handoff. | `delivery-declined` | The lifecycle provides the detailed checklist. |
| Browser capability absence remains explicit residual risk. | `SKILL.md` startup/browser policy; `references/lifecycle.md` validation/delivery guidance. | `browser-unavailable` | No live browser behavior is asserted by this baseline. |
| Requested routing and actual host evidence are not interchangeable. | Planning revision 3 capability-routing contract and risk matrix; current `9.0.9` has no first-class adapter evidence. | `routing-actual-evidence-gap`, all host routing cases | This is a synthetic `known-defect` specification and a `9.2` contract target; live confirmation remains separate. |
| Metadata does not authorize mutating delivery actions. | Contract README describes metadata as display hints; plan revision 3 requires fail-closed compatibility authorization. | `metadata-authorization-denial` | This is a `must-change` adapter/resolver requirement, not a claim that `9.0.9` already enforces it. |
| MR title/body/provider flow belongs to `ant:merge-request`. | Planning revision 3 and repository MR policy; current orchestration material contains duplicate-path risk. | `canonical-mr-handoff` | Specified as `must-change` until the canonical handoff is implemented. |
