# Internal delegation and cross-thread handoff

- Status: in_progress; phase: delivery; implementation and independent review complete.
- Objective: distinguish ordinary orchestrator delegation from independent cross-thread handoff and prevent duplicate consent questions, then update draft PR 74.
- Authority: user explicitly said "jo, uprav to" after the proposal that children escalate only to orchestrator, root resolves routine decisions inside established scope, and root asks user only for scope expansion or reserved decisions. Existing scoped PR delivery authority persists; no new merge/deployment or host-refusal override.
- Continuity: existing isolated marketplace branch; preserve unrelated blocked Marketing Goal. Separate durable plan, no native automatic continuation guarantee.
- Scope: canonical lifecycle handoff paragraph; concise docs/router changes only if needed. Root owns this plan; Luna High integration owner writes instructions; Sol High independent reviewer reads only. Fresh fork none, no nested delegation.
- Acceptance: ordinary child assignment uses root capsule and existing authority without recopying original consent or directly asking user. Child reports ambiguity to parent/root. Root resolves supported in-scope decisions and does not re-request established consent. Independent-thread handoff retains provenance checks, with receiving root as adjudicator; missing proof pauses only dependent actions. User consultation reserved for genuine unresolved scope or user-owned decisions. Host authority/refusal rules unchanged.
- Checks: focused semantic review of normal delegation, in-scope repair, independent handoff with missing source, genuine scope expansion, and refusal; affected metadata/link/whitespace checks. No runtime/tests/manifest/version changes.
- Resume: owner edit, independent review, root final checkpoint/freeze, scoped commit/push and body update; finite exact-head observation.

- Implementation checkpoint: lifecycle-only clarification; owner semantic/link/whitespace checks passed. Independent Sol High review approved after clarifying that root adjudicates and the integration owner performs repairs.
- Final checkpoint: next scoped commit freezes this plan and the lifecycle edit. Focused semantic/link/whitespace gate passed; no metadata or executable changes require broader checks. Reviewed PR body reflects final behavior. Update existing draft and observe exact head within five minutes, report externally without editing frozen plan. No unrelated Goal mutation.
