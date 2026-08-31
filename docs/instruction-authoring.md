# Instruction Authoring

Use this guide when creating or changing plugin instructions. Its purpose is to make instructions easy to select, load, execute, review, and maintain.

## Core Standard

- Assume the model is capable. Add only non-obvious guidance that changes a decision or materially improves reliability.
- Preserve the user's intent, scope, and authority. Instructions never grant permission for additional writes, delivery, destructive actions, or external side effects.
- Match prescription to risk. Use fixed sequences and absolute rules only for safety, correctness, permissions, or genuinely fragile operations.
- Prefer plain language. Introduce a specialized term only when it shortens the contract; define it at first use.
- Keep examples minimal. An example clarifies a rule but does not silently expand it.

## Put Each Rule In One Place

Give every rule one canonical owner:

| Content | Canonical location |
|---|---|
| Repository-wide maintainer invariants | `AGENTS.md` |
| Skill purpose, routing, and essential workflow | `SKILL.md` |
| Conditional or detailed shared procedure | The relevant `references/*.md` file |
| Host-specific models, tools, or preflights | The active host adapter |
| User-facing behavior and migration guidance | Active documentation |

Other files should link to the canonical owner or summarize only what their audience needs. Do not copy the complete policy into multiple files.

## Write Executable Rules

- Put one decision or action in each bullet.
- Order instructions as: prerequisite → decision → action → evidence → failure or fallback.
- Express branches as short conditions with an explicit outcome:

  ```text
  If <condition>, do <action>.
  Otherwise, do <fallback>.
  ```

- State required evidence where completion could otherwise be guessed.
- Distinguish obligation from guidance:
  - **must / never** — required invariant, safety rule, or authority boundary;
  - **should / default** — preferred behavior that may yield to stronger evidence;
  - **may** — optional behavior.
- Keep exceptions beside the rule they modify. Do not hide several gates or exceptions in one paragraph.
- State a stopping or escalation condition for bounded retries and externally blocked work.

## Keep Instructions Proportional

- Add a rule for a demonstrated, repeatable failure mode, not as a universal reaction to one incident.
- Describe the required outcome and decision criteria when several implementations are valid.
- Prescribe exact tools or steps only when the target environment exposes them and alternatives would violate a real constraint.
- Use progressive disclosure: keep the entrypoint short and load detailed references only for the active mode.
- Do not create a new reference, script, alias, or public skill unless it has a distinct maintained purpose.

## Review Checklist

Before completing an instruction change, verify:

- Every sentence changes a decision, preserves an invariant, or routes to necessary detail.
- Every rule has one canonical owner and no conflicting duplicate.
- Preconditions, authority, evidence, fallback, and stopping conditions are explicit where needed.
- Shared policy is host-neutral; host-specific details remain in the relevant adapter.
- Terms are defined, references are discoverable, and links resolve.
- Active user documentation describes current behavior without reproducing internal mechanics.
- The instruction works for at least one realistic normal case and one relevant failure or unavailable-capability case.
- Validation checks behavior and maintained invariants rather than matching exact prose.

Prefer the smallest correction that satisfies this checklist. Do not add runtime machinery or a synthetic evaluation framework solely to enforce instruction wording.
