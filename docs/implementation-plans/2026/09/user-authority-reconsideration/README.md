# User authority and permitted reconsideration

## Scope and endpoint

Clarify user precedence over skill-owned workflow preferences and accurate blocker
classification; deliver a draft PR against the verified default branch. User consent
does not override host/system safety controls. No release, version bump, merge,
deployment, permission changes, or retry of the other task's blocked operation.

## Acceptance and evidence

- Distinguish user-changeable skill workflow choices from externally enforced limits.
- Follow complete host notices, including explicitly permitted clarification or
  reconsideration, without concealing material facts or promising acceptance.
- Distinguish capability errors/timeouts from safety denials; preserve retry limits.
- Explain the exact action, source and observed reason separately from interpretation;
  preserve authorized unaffected work and never invent missing permission.
- Keep shared policy canonical in lifecycle.md and public summaries linked.

Static scenario review: user overrides workflow preference; user tries to override
host denial; notice explicitly invites clarification; refusal forbids retry;
approval timeout; ambiguous notice; unaffected authorized work. This is not an
end-to-end guarantee of host acceptance. Incremental cadence, one coherent change,
independent Sol High review, then plugin/JSON validation and diff checks as final gate.

## Ownership and progress

Root owns this plan and delivery. Fresh isolated Luna High integration owner edits
lifecycle.md and necessary public documentation only. Fresh isolated Sol High
reviewer is read-only. Children cannot edit the plan or delegate. No native Goal
requested or in use. Preserve unrelated changes. In-place evolution on a scoped
branch from clean master, fast-forwarded before edits to fetched 6b4a99c (v13.3.0).
GitHub confirms master as default. Observe PR for at most three minutes.

## Final checkpoint

Implementation and independent Sol High review completed with no findings across
all seven scenarios. The candidate changes canonical lifecycle policy and linked
summaries in docs/orchestrator.md and docs/skills.md. README and installation remain
aligned without edits. No host permissions, manifests, versions or runtime changed.

Marketplace and plugin validation, all four JSON manifests, relative file links,
and whitespace checks passed. This is static instruction/scenario validation, not
proof that a future host will accept any particular request. The final gate is the
same plugin/JSON/whitespace validation on the frozen candidate including this plan.

Target is verified at 6b4a99c4e6c7ad362fbb89de48b6a1ea971426f9. GitHub branch
protection reports no required status checks and one approval with code-owner
review required. Draft delivery does not satisfy that external approval or authorize
merge. Commit, push, draft creation and bounded observation follow this checkpoint;
their actual result is reported with the provider URL.

Retrospective: treating an offered recovery path as an overlapping notice condition
avoids the previous absolute-denial interpretation. Linking the handoff rule to the
canonical classification keeps one policy owner without a separate approval flow.
