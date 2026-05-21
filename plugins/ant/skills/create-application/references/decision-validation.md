# Decision Validation

Use this reference throughout create-application intake, not only at the end. The goal is to keep validating whether the current direction still fits the user's answers.

## Validation Checkpoints

Run a validation pass:

1. after the first grouped intake answers;
2. after environment/tooling is known;
3. after choosing TypeScript-only versus Docker-based path;
4. after choosing a framework or CMS candidate;
5. after any new answer that materially changes data, auth, SEO, deployment, integrations, or team constraints;
6. before asking for architecture approval;
7. before handing off to `implementation-orchestrator`.

## Validation Questions

Ask yourself:

- What would make this recommendation wrong?
- Which user answer points toward a different path?
- Does the framework/CMS choice fit the actual project shape?
- Can the requester run the chosen stack locally or in an approved cloud/dev environment?
- Are there hidden secrets, auth, permissions, persistence, jobs, webhooks, or production concerns?
- Are we choosing a technology because it fits the request, or because it was named earlier?
- Which alternative was strongest, and why is it not the recommendation?

If the answer exposes a mismatch, stop and reconcile it with the user before approval.

## Validation Methods

Use one or more:

- **Decision ledger**: list key decisions and the user answer or fact supporting each one.
- **Reverse recommendation check**: briefly explain why the strongest alternative is not the recommended path.
- **Red flag scan**: apply `architecture-guardrails.md`.
- **Requirement-to-stack mapping**: map important requirements to architecture implications.
- **Second-pass self-review**: write a short review under a heading like "Validation pass" and challenge your own recommendation.

Keep validation concise for beginner users. The reasoning can be internal, but the user-facing result must mention any meaningful mismatch or risk in plain language.

## Independent Reviewer Or Subagent

For medium/high-risk app creation, use an independent reviewer/subagent when the host supports it.

Use independent validation when any of these are true:

- production or long-lived internal app;
- auth, private data, roles, or auditability;
- Docker/multi-language path;
- existing platform/module ownership question;
- multiple domains, teams, integrations, workers, webhooks, queues, or scheduled work;
- uncertain framework/CMS choice;
- the user requested technologies that may not fit the stated goals.

Reviewer prompt shape:

```text
Review this create-application app brief and proposed architecture. Do not implement. Look for contradictions, unsafe assumptions, missing product decisions, tooling blockers, framework/CMS mismatch, data/auth risks, and better architecture options. Return concise findings, recommended changes, and any questions that must be answered before approval.
```

If subagents are unavailable, perform the same review yourself as a clearly labeled second-pass validation.

Do not let the reviewer decide for the user. Synthesize the findings, update the recommendation, and ask the user to approve or choose between options.

## Validation Output

Before approval, capture:

- validation passes completed;
- independent reviewer/subagent notes, if used;
- alternatives considered and why rejected;
- red flags found or explicitly cleared;
- decisions already approved;
- decisions still open;
- assumptions safe to proceed with;
- assumptions to verify before coding.
