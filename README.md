<p align="center">
  <img src="assets/logo.svg" alt="(ant)" width="200">
</p>

<h3 align="center">Workflow skills for Claude Code and Codex</h3>

<p align="center">
  <a href="#first-steps">First steps</a> ·
  <a href="#quick-install">Install</a> ·
  <a href="#choose-a-skill">Skills</a> ·
  <a href="#orchestrator">Orchestrator</a> ·
  <a href="#docs">Docs</a>
</p>

The `(ant)` marketplace gives Claude Code and Codex shared workflows for planning, implementation orchestration, delivery, frontend, Laravel, brand design, Google Docs, and Asana task analysis.

## First Steps

1. Install the plugin for your assistant: [Claude Code](#claude-code) or [Codex](#codex).
2. Reload Claude Code or restart/open a new Codex session.
3. Pick the skill that matches the task from [Choose a Skill](#choose-a-skill).
4. For new product or app ideas, start with `create-application`.
5. For implementation work, start with `implementation-orchestrator` so repository discovery and an approved plan happen before code changes, with brainstorming for new behavior.

## Quick Install

### Claude Code

Inside Claude Code:

```text
/plugin marketplace add antstudiocz/ant-marketplace
/plugin install ant@ant-marketplace
/reload-plugins
```

Or from a terminal:

```bash
claude plugin marketplace add antstudiocz/ant-marketplace --scope user
claude plugin install ant@ant-marketplace --scope user
```

### Codex

Global install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
```

Project install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

Want an assistant to do the installation for you? Use the prompts in [docs/install.md](docs/install.md).

## Choose a Skill

Use the narrowest skill that matches the work. If the task will become a multi-step implementation, use `implementation-orchestrator` first and let it delegate the right specialist roles.

### Planning And Delivery

- **Create applications**
  - Claude Code: `/ant:create-application`
  - Codex: `$create-application`
  - Use for: new apps, MVPs, prototypes, internal tools, dashboards, and major app surfaces before implementation.
- **Implementation orchestrator**
  - Claude Code: `/ant:implementation-orchestrator`
  - Codex: `$implementation-orchestrator`
  - Use for: repository discovery, user-needs brainstorming, approved implementation planning, subagents, review, verification, and delivery.
- **Merge requests**
  - Claude Code: `/ant:merge-request`
  - Codex: `$merge-request`
  - Use for: the canonical GitHub/GitLab PR/MR workflow, with descriptions rebuilt from the target merge base to final `HEAD`.
- **Delivery workflows**
  - Claude Code: `/ant:delivery-workflows`
  - Codex: `$delivery-workflows`
  - Use for: contextual merge-conflict resolution. Use `merge-request` directly for PR/MR creation or updates.

### Engineering And Design

- **Frontend best practices**
  - Claude Code: `/ant:frontend-best-practices`
  - Codex: `$frontend-best-practices`
  - Use for: React, Next.js, TypeScript, accessibility, forms, performance, responsive UI, i18n, skeletons, and composition.
- **Laravel best practices**
  - Claude Code: `/ant:laravel-best-practices`
  - Codex: `$laravel-best-practices`
  - Use for: Laravel 12+ architecture, caching, performance, Eloquent, queues, UTC time handling, and backend review.
- **Brand design**
  - Claude Code: `/ant:brand-design`
  - Codex: `$brand-design`
  - Use for: websites, apps, decks, documents, and visuals against the `(ant)` brand.

### Content And Intake

- **Google Docs**
  - Claude Code: `/ant:google-docs`
  - Codex: `$google-docs`
  - Use for: reading and extracting content from Google Docs.
- **Asana task analyzer**
  - Claude Code: `/ant:asana-task-analyzer`
  - Codex: `$asana-task-analyzer`
  - Use for: Asana goals, requirements, blockers, and implementation context.

See [docs/skills.md](docs/skills.md) for the full skill guide.

## Orchestrator

Use `implementation-orchestrator` when work should be driven end to end rather than answered as a one-off edit. Every implementation starts with read-only repository discovery and a proportional plan that the user approves before any tracked writer starts. New or materially changed behavior also adds user-needs brainstorming, all material questions, and deeper technical analysis before that plan.

Codex installations may allow a deeper subagent hierarchy with this setting in `~/.codex/config.toml`:

```toml
[agents]
max_depth = 2
```

Then restart Codex or open a new session. The orchestrator also works without nested delegation by dispatching a flatter agent graph.

The shared workflow routes by Strong, Balanced, and Fast capabilities, while each host selects from its current model catalog. Reasoning is reassessed during work: it increases when ambiguity, risk, or failures broaden and decreases for bounded deterministic segments. During implementation it runs targeted checks after coherent phases; the full suite runs once on the final tree before delivery.

Approval covers the stable plan rather than every phase. A tiny mechanical step inside that plan uses a compact cycle without duplicate approval. If the user adds materially new functionality mid-flight, only the affected writes pause for discovery, brainstorming, deeper analysis, a delta-plan, and approval; unaffected work continues.

More detail:

- [Orchestrator setup](docs/orchestrator.md)
- [10.0 release notes](docs/releases/10.0.0.md)

## Docs

The README is intentionally short. Longer guides live in `docs/` and can be mirrored into GitHub Wiki if the marketplace grows.

- [Installation guide](docs/install.md) - manual install, AI-assisted install prompts, and updates.
- [Skill guide](docs/skills.md) - what each public skill does and when to use it.
- [Orchestrator setup](docs/orchestrator.md) - execution shape, capability routing, adaptive reasoning, messages, validation, and delivery.
- [Orchestrator slide deck](docs/index.html) - visual explainer for the orchestrator lifecycle.

## Update

Claude Code:

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

Codex: rerun the same `codex-marketplace add` command with the same scope (`--global` or `--project`), then restart Codex or open a new session.

## Contributing

1. Create a folder in `plugins/ant/skills/your-skill-name/` with a `SKILL.md` file for a new public workflow.
2. Prefer adding detailed topic guidance under an existing skill's `references/` folder when it belongs to an umbrella skill.
3. Do not add same-name command aliases; Claude Code discovers skills directly from `skills/*/SKILL.md`.
4. Validate manifests and docs before opening a PR.

---

<div align="center">

## Made with <img src="assets/heart.svg" height="18" alt="love"> by (ant)

*From (WTF) ideas we create (WOW) results.*

We are a full-service digital agency from Western Czechia. For over 25 years we've been creating projects that push boundaries. We have 50+ experts and one know-how: **doing things differently**.

![25+ years](https://img.shields.io/badge/25+-years-5bffc4?style=flat-square)
![50+ experts](https://img.shields.io/badge/50+-experts-5bffc4?style=flat-square)
![Pilsen, CZ](https://img.shields.io/badge/Pilsen-CZ-5bffc4?style=flat-square)

</div>
