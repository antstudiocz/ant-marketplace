# Approval Policy

This file is the normative owner for authorization, stop/continue semantics, and approval recovery. It applies identically in Codex and Claude Code.

## Fail-Closed Rule For State `1.0.0`

Prompt memory, chat summaries, markdown prose, `state.json.metadata`, delivery preferences, and startup summaries never authorize mutation or delivery. They may display or point to authorization evidence only.

An action is authorized only by one of these immutable sources:

1. a complete approval payload inside a schema-valid `decision.recorded` event in `events.jsonl`; or
2. an immutable approval artifact registered in `state.json.artifacts[]` and linked from a schema-valid `decision.recorded` event through `artifactRefs`, by stable artifact id and verified content digest.

The event must validate against `event.schema.json` version `1.0.0`. Keep grant, revoke, and supersede operations inside `decision.recorded`; do not introduce new event types before a versioned contract change.

## Approval Payload

For grant/supersede, event `data` or the linked artifact must include:

- stable `approvalId` and content digest formatted `sha256:<lowercase-hex>` over the immutable approval payload using the single canonical byte algorithm below;
- `operation`: `grant`, `revoke`, or `supersede`;
- exact workspace/run/cycle/phase or milestone `scope`;
- explicit `actions`, selected from `edit`, `commit`, `push`, `mr`, `pipeline-recovery`, `merge`, and `release`;
- `stopConditions` and verification boundaries;
- grantor/actor identity and the exact user text or an immutable evidence reference;
- `grantedAt` in UTC/Zulu;
- source host/session provenance;
- `expiresAt` or explicit `noExpiry: true`;
- revocation/supersession links when applicable.

A revoke event names `revokesApprovalId`, `revokesApprovalDigest`, reason, actor, UTC/Zulu time, provenance, and evidence ref. Supersede contains a complete new approval plus `supersedesApprovalId` and `supersedesApprovalDigest`. A missing or mismatched target digest is invalid and denies authorization. `expiresAt` and `noExpiry: true` are mutually exclusive.

## Canonical Approval Bytes And Digest

Every producer and resolver on every host uses this exact algorithm. No producer-specific serialization is allowed.

1. Start with the complete approval JSON object. Remove exactly its top-level `digest` member; do not remove nested members or any other field.
2. The remaining value must be valid I-JSON: no duplicate object names, no non-finite numbers, and no lone Unicode surrogate code points.
3. Serialize it with the JSON Canonicalization Scheme (JCS), RFC 8785: object names are sorted recursively by UTF-16 code units; array order is preserved; strings and numbers use the RFC 8785/ECMAScript JSON representation; no insignificant whitespace is emitted; Unicode text is not normalized.
4. Encode the canonical JSON text as UTF-8 without a byte-order mark.
5. Compute SHA-256 over those bytes and encode the result as lowercase hexadecimal prefixed with `sha256:`.

The embedded `digest` must equal that result. A producer or resolver that cannot implement RFC 8785 exactly must deny authorization rather than choose another representation. Artifact file-byte hashes may exist separately, but they never replace this approval-payload digest.

Minimal inline grant event shape (placeholder values must be replaced):

```json
{"schemaVersion":"1.0.0","eventId":"<event-id>","runId":"<run-id>","timestamp":"<UTC/Zulu>","type":"decision.recorded","actorAgentId":"root","phaseId":"<phase-id>","agentId":"root","severity":"info","message":"Implementation approval granted","data":{"decisionKind":"approval","operation":"grant","approval":{"approvalId":"<id>","digest":"sha256:<hex>","scope":{"runId":"<run-id>","cycle":"<cycle>","phasesOrMilestones":["<id>"]},"actions":["edit"],"stopConditions":["<condition>"],"grantor":"<actor>","userTextOrEvidenceRef":"<immutable-ref>","grantedAt":"<UTC/Zulu>","provenance":"<host/session>","noExpiry":true,"supersedes":[],"revokes":[]}},"artifactRefs":[]}
```

Events remain append-only and approval artifacts remain content-addressed. A grant change, revocation, or supersession is a new schema-valid `decision.recorded` event; never edit a prior grant/artifact in place. For an artifact source, `state.json.artifacts[]` registers the artifact and the authorizing `decision.recorded` event links its stable id in `artifactRefs`. Metadata may display that pointer, but cannot create or complete the authority chain. The referenced payload plus verified digest is authoritative—not the pointer itself.

## Resolver

Before every mutating action, and again after resume, compaction, or cross-host handoff:

1. locate the approval by stable id;
2. validate the event and any linked artifact;
3. recompute and compare the digest using the canonical algorithm above;
4. verify provenance, scope, action, phase/milestone boundary, stop conditions, and expiry;
5. replay later `decision.recorded` revoke/supersede operations;
6. deny on missing, ambiguous, conflicting, expired, revoked, malformed, or unverifiable evidence.

If the producer cannot create or verify the evidence, continue read-only only and request a fresh explicit approval. Record the new approval before mutation.

## Continue And Stop

`pokračuj` or equivalent live user text authorizes only the previously stated next action or approval envelope. Before acting, persist it as an authoritative approval source above. A vague continuation never expands scope or delivery permissions.

Always stop for:

- an action outside approval scope;
- material product, architecture, contract, data, permission, security, validation, target, or delivery change;
- failed verification that cannot be fixed safely in scope;
- unknown or overlapping writer ownership;
- a stop condition named in the envelope;
- missing or invalid authorization evidence.

Open P0 findings deny phase close, automatic delivery, merge, and release. A separately recorded, finding-specific emergency approval may authorize bounded remediation only; it never enables automatic delivery or release while the P0 remains open.

## Metadata Boundary

`metadata.approval`, run contract fields, and delivery preferences may contain only display summaries and pointers such as `approvalId`, digest, and artifact ref. Consumers must resolve the authoritative event/artifact before acting. Metadata absence does not revoke a valid approval, and metadata presence never creates one.
