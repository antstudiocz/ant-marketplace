<p align="center">
  <img src="assets/logo.svg" alt="(ant)" width="200">
</p>

<h3 align="center">Skills for Claude Code and Codex</h3>

## Claude Code Installation

Inside Claude Code:

```
/plugin marketplace add antstudiocz/ant-marketplace
/plugin install ant@ant-marketplace
/reload-plugins
```

Or from a terminal:

```bash
claude plugin marketplace add antstudiocz/ant-marketplace --scope user
claude plugin install ant@ant-marketplace --scope user
```

## Codex Installation

Global install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
```

Project install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

## Available Skills

| Claude Code Command | Codex Skill | Description |
|---------------------|-------------|-------------|
| `/ant:implementation-orchestrator` | `$implementation-orchestrator` | Guide implementation from brainstorming to verified delivery |
| `/ant:frontend-best-practices` | `$frontend-best-practices` | React, Next.js, TypeScript, accessibility, forms, performance, responsive UI, i18n, skeletons, and composition |
| `/ant:laravel-best-practices` | `$laravel-best-practices` | Laravel 12+ architecture, caching, performance, Eloquent, queues, and backend review |
| `/ant:delivery-workflows` | `$delivery-workflows` | GitLab MR creation, merge conflicts, and delivery hygiene |
| `/ant:google-docs` | `$google-docs` | Read and extract content from Google Docs |
| `/ant:asana-task` | `$asana-task-analyzer` | Analyze Asana tasks for implementers |

See [docs/skills.md](docs/skills.md) for a short explanation of how each skill works.

## Update

Claude Code:

```
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

Or from a terminal:

```bash
claude plugin update ant@ant-marketplace
```

Codex: rerun the same `codex-marketplace add` command with the same scope (`--global` or `--project`). Restart Codex or open a new session so the updated skills are loaded.

## Contributing

1. Create a folder in `plugins/ant/skills/your-skill-name/` with a `SKILL.md` file for a new public workflow
2. Prefer adding detailed topic guidance under an existing skill's `references/` folder when it belongs to an umbrella skill
3. Open a PR

---

<div align="center">

## Made with <img src="assets/heart.svg" height="18" alt="love"> by (ant)

*From (WTF) ideas we create (WOW) results.*

We are a full-service digital agency from Western Czechia. For over 25 years we've been creating projects that push boundaries. We have 50+ experts and one know-how: **doing things differently**.

![25+ years](https://img.shields.io/badge/25+-years-5bffc4?style=flat-square)
![50+ experts](https://img.shields.io/badge/50+-experts-5bffc4?style=flat-square)
![Pilsen, CZ](https://img.shields.io/badge/Pilsen-CZ-5bffc4?style=flat-square)

</div>
