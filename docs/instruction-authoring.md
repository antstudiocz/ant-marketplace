# Instruction authoring

Use this guide when changing plugin instructions. Write only guidance that changes a decision, preserves an invariant, or materially improves reliability.

## Canonical ownership

Give each rule one owner:

| Content | Owner |
|---|---|
| Repository invariants | `AGENTS.md` |
| Skill purpose, routing, essential workflow | `SKILL.md` |
| Conditional procedure | relevant `references/*.md` |
| Host models, tools, preflights | active host adapter |
| User-facing behavior and migration guidance | active documentation |

Link to the owner from other files. Do not copy a complete policy into summaries, adapters, or user documentation.

## Authoring rules

- Keep the entrypoint short and route to detailed references only when the current mode needs them.
- Assume the model is capable; remove generic advice, repeated instructions, ritual questionnaires, and speculative edge cases.
- Preserve user intent and authority. Instructions never grant permission for extra writes, delivery, destructive actions, or external effects.
- Match prescription to risk. Use absolute rules for safety, correctness, authority, or fragile operations; describe decision criteria where several implementations are valid.
- Put one decision or action in each bullet. Order guidance as prerequisite, decision, action, evidence, then fallback or stopping condition.
- Define specialized terms at first use and keep examples minimal.
- Preserve compatible scope, useful domain knowledge, and existing assets. Do not add a runtime, alias, script, reference, or public skill without a distinct maintained purpose.

## Review

Before completing an instruction change, verify that:

- every rule has one owner and no duplicate contradicts it;
- authority, preconditions, evidence, fallback, and stopping conditions are explicit where needed;
- shared policy is host-neutral and host details stay in adapters;
- terms and relative links resolve;
- user documentation describes current behavior without reproducing internal mechanics;
- the instructions work for a normal case and a relevant failure or unavailable-capability case;
- checks validate maintained invariants and behavior rather than matching prose.

Prefer the smallest correction that meets this review. Do not create synthetic evaluation infrastructure solely to enforce wording.
