# Communication Level

Use this reference at the start of create-application intake. The goal is to make the skill usable for non-technical vibe coders without slowing down advanced users.

## First Question

Ask the requester to choose one:

- **Beginner / non-technical**: "I know what I want the app to do, but I do not know coding or infrastructure."
- **Intermediate**: "I understand some technical terms and want to understand how the app will work, but I do not want deep implementation details."
- **Advanced**: "You can talk to me technically and include architecture, stack, tradeoffs, and implementation details."

If the user does not answer, default to intermediate and keep explanations concise but clear.

## Beginner / Non-Technical

Primary goal:

- understand what the user wants to achieve;
- understand how the app should work from a user's point of view;
- avoid unnecessary implementation jargon.

How to ask:

- ask in plain language;
- explain terms before using them;
- use examples instead of abstract labels;
- ask about outcomes, people, screens, data, approvals, and risks;
- translate technical choices into practical consequences.

Explain concepts like:

- **Docker**: a way to run all required app parts, such as database and backend, in the same predictable setup on each computer;
- **database**: where the app stores information so it is still there later;
- **authentication**: how users log in;
- **authorization**: what each user is allowed to see or change;
- **CMS**: an admin area where non-developers can manage content or structured data;
- **background job**: work the app does later or repeatedly, even when nobody is clicking a button.

Output style:

- show one recommended path and one simpler/stronger alternative;
- explain why in business/user terms;
- avoid long lists of technologies unless the user asks;
- explicitly say what the user needs to install or decide next.

## Intermediate

Primary goal:

- explain how the app will work during the full flow;
- include enough technical detail for informed decisions;
- avoid deep implementation internals unless needed.

How to ask:

- use normal product and light technical terms;
- explain terms that are easy to misunderstand, such as Docker, CMS, auth, database, worker, webhook;
- include tradeoffs and operational consequences;
- describe the implementation process at a high level.

Output style:

- show the two implementation paths with practical pros/cons;
- name likely technologies and why they fit;
- describe the planned flow: intake, architecture choice, setup check, app brief approval, orchestrator handoff, implementation, validation.

## Advanced

Primary goal:

- make all relevant technical tradeoffs explicit;
- preserve speed and precision;
- avoid over-explaining common concepts.

How to ask:

- use technical vocabulary normally;
- ask directly about architecture, data model, auth boundaries, deployment target, CI, observability, queues, migrations, and integration contracts;
- ask for exact constraints when they matter.

Output style:

- include implementation path, stack rationale, data/storage choice, auth/authorization model, runtime/deployment assumptions, framework/CMS tradeoffs, risks, and validation plan;
- be explicit about unknowns, assumptions, and decision gates.

## Handoff Requirement

Record the selected communication level and explanation style in the app brief so `implementation-orchestrator` can keep the same tone.
