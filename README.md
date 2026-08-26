<p align="center">
  <img src="assets/logo.svg" alt="(ant)" width="200">
</p>

<h3 align="center">Practical workflow skills for Claude Code and Codex</h3>

<p align="center">
  <a href="#quick-install">Install</a> ·
  <a href="#use-the-right-entry-point">Use a skill</a> ·
  <a href="#implementation-orchestrator">Orchestrator</a> ·
  <a href="#docs">Docs</a>
</p>

`(ant)` gives Claude Code and Codex a small set of reusable workflows for turning product ideas, repository tasks, delivery work, and source material into dependable outcomes. It keeps the public entry points broad, while each skill loads detailed guidance only when it is relevant.

Use it to scope a new application, plan and delegate a verified implementation, improve a React or Laravel codebase, work from an Asana task or Google Doc, resolve a merge conflict, or prepare a PR/MR with a truthful final-diff description.

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

Reload Claude Code, or restart Codex/open a new Codex session, after installation or an update. More installation and AI-assisted setup prompts are in the [installation guide](docs/install.md).

## Use The Right Entry Point

Invoke skills with `/ant:skill-name` in Claude Code or `$skill-name` in Codex. Choose the narrowest entry point that matches the request.

| Need | Start with | Example |
| --- | --- | --- |
| Shape a new product, MVP, dashboard, or app surface | `create-application` | “Turn this client portal idea into an approved product brief.” |
| Drive a feature, fix, refactor, migration, or remediation through verified delivery | `implementation-orchestrator` | “Analyze this failing checkout flow only” or “Fix it and test it end-to-end.” |
| Build or review React, Next.js, or TypeScript UI | `frontend-best-practices` | “Make this settings form responsive and accessible.” |
| Improve Laravel architecture, Eloquent, caching, or queues | `laravel-best-practices` | “Find the cache ownership issue in this endpoint.” |
| Apply or audit the `(ant)` visual identity | `brand-design` | “Review this landing page against the `(ant)` brand.” |
| Read requirements from a Google Doc or Asana task | `google-docs` or `asana-task-analyzer` | “Extract acceptance criteria and open questions from this link.” |
| Resolve a merge conflict | `delivery-workflows` | “Resolve these conflicts without losing either branch’s intent.” |
| Prepare or create/update a GitHub PR or GitLab MR | `merge-request` | “Prepare an English MR proposal from the current branch.” or “Create a Draft MR from the current branch.” |
| Ask a one-off question or make a tiny, isolated change | Use the relevant specialist skill directly—or no skill | “Explain this query plan” or “Rename this local label and run its focused check.” |

See the [complete skill guide](docs/skills.md) for the full scope of every public skill.

## Implementation Orchestrator

Use `implementation-orchestrator` when the outcome needs end-to-end ownership: repository discovery, an implementation plan, delegated tracked edits, independent review, validation, and an optional delivery handoff. It is especially useful when the task spans multiple files, has uncertain root cause, changes behavior, touches data/security/contracts, or needs a trustworthy final verification.

Do not use it just to answer a question, inspect a file, draft copy, make a genuinely isolated one-off edit, or invoke a specialist workflow such as a merge-conflict resolution or PR/MR request. Those tasks are faster and clearer when handled directly.

At intake, it distinguishes analysis-only, implementation-authorized, and ambiguous requests. It always performs read-only discovery before the continuity decision and concrete plan, deriving only material quality attributes and constraints from evidence and recording lighter/heavier rationale in the Plan and writer/reviewer assignments. It chooses the smallest durable solution, requires deterministic async/concurrency tests with retries used only for diagnosis, and checks both hidden expedient debt and speculative overengineering. After discovery, it first honors any already explicit continuity choice. Otherwise, it records Incrementally verifiable without asking when the modes do not materially change local implementation order; when they do, it asks the single predefined choice with a context-based recommendation. Integrated replacement needs explicit acceptance and a checkout dedicated to the work, and it never relaxes final safety or migration requirements. “Analyze this only” stays read-only; “fix it and test it end-to-end” continues after the plan checkpoint when scope and risk remain unchanged. A request to wait for approval, or a material scope/risk change, still pauses. New or materially changed behavior also requires user-needs exploration, material unanswered questions, and deeper technical analysis. Root is the sole user-facing adjudicator: delegated agents escalate evidence, options, a recommendation, and paused scope only to their parent, while root resolves from repository evidence and prior decisions before batching any genuinely new authority into one question. The root remains coordination-only; if the host cannot delegate a writer safely, it stops before edits rather than silently taking over.

For executable, runtime, or user-visible changes, the Plan defines the smallest realistic smoke flows. After the final suite, the orchestrator discovers actual available testing surfaces, offers every applicable option with exactly one evidence-based recommendation, and leaves tool selection to the user (honoring an explicit prior choice). Smoke evidence includes environment/head, exact flows, expected versus observed outcomes, side effects, gaps, and screenshots where supported; it supplements automated checks. All verified material actionable adjacent findings are reported separately from the at-most-three execution retrospective findings, with current gaps fixed or readiness lowered/blocked and no automatic CI enforcement.

For Claude Code, establish `best` + `max` before invoking `/ant:implementation-orchestrator` (for example, `claude --model best --effort max`). Before tracked writes, the workflow uses the host's native Plan and Goal; if either cannot be observed or managed, it reports the limitation and stops before edits. In Codex, select or verify the root route for the task/session before invoking `$implementation-orchestrator`; native Goal tools are mandatory before tracked-writer dispatch, and unavailable Goal tools fail closed after read-only discovery/planning.

### Current Routing Examples

The workflow selects capability and reasoning effort independently. The Codex rows are the active routing policy; the shared lifecycle remains host-neutral and the active adapter remains the operational source.

| Use case | Codex route | Claude Code route |
| --- | --- | --- |
| Root coordination, decisions, integration, and retrospective | `gpt-5.6-sol` · High | `best` + Max: Fable when available, otherwise latest Opus |
| Architecture, security, migrations, or complex root cause | `gpt-5.6-sol` · High | Opus · High |
| Mandatory independent final review | `gpt-5.6-sol` · High | Opus · High |
| Standard implementation and integration | `gpt-5.6-luna` · High | Sonnet · High |
| Repository investigation, bounded slices, and validation | `gpt-5.6-luna` · Medium | Sonnet · Medium |
| Exact searches and mechanical work | `gpt-5.6-luna` · Low/Medium | Haiku, or Sonnet · Low when explicit effort control is required |
| PR/MR support | `gpt-5.6-luna` · Medium | Sonnet · Medium |

Root uses `gpt-5.6-sol` at High in Codex. Every child is explicitly routed and capped at High; a Strong task does not imply above-High effort. In Codex, Strong children use Sol High and every other child uses Luna at proportional High, Medium, or Low effort; each child—including nested work—gets concise self-contained context and uses `fork_turns="none"`. There is no Terra route or fallback. If the required route or isolation cannot be enforced, it is reported rather than assumed.

The [orchestrator guide](docs/orchestrator.md) contains its lifecycle, routing details, validation, review, retrospective, delivery boundaries, and optional Codex nested-agent setup.

## Prerequisites And Integrations

Install the plugin into a working Claude Code or Codex environment. The Codex commands above use `bunx`; use the appropriate scope for your setup. The plugin does not require a separate orchestration database, generated runtime, or migration command.

The Google Docs skill supports publicly shared Google Docs. The Asana skill requires active host MCP/access and authorization for the task and its linked content. PR/MR support uses the repository’s existing GitHub or GitLab access: a preparation request returns a read-only title/body preview, while an explicit create/update request safely commits scoped work when needed, pushes, creates a Draft by default or preserves an existing request's readiness, and observes the matching pipeline for the resolved head. If no matching checks/pipeline registers within the repository-appropriate bounded window, it reports an unverified external-state outcome rather than green. It resolves repository-set language and target choices without asking again, and asks only about material unresolved conflicts. Missing external access is reported without blocking unrelated local work.

## Docs

- [Installation guide](docs/install.md) — installation, updates, and assisted setup prompts.
- [Skill guide](docs/skills.md) — scope and usage of each public skill.
- [Orchestrator guide](docs/orchestrator.md) — full execution, routing, review, validation, and delivery guidance.
- [Orchestrator visual explainer](docs/index.html) — a visual overview of the lifecycle.
- [11.1.0 release notes](docs/releases/11.1.0.md) — proportional quality, deterministic tests, runtime smoke choice, and adjacent findings.
- [11.0.0 release notes](docs/releases/11.0.0.md) — breaking native Plan/Goal and Luna/Sol orchestration update.

## Update

In Claude Code:

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

For Codex, rerun the same `codex-marketplace add` command using the same scope (`--global` or `--project`), then restart Codex or open a new session.

## Contributing

Keep public skills focused and broad. Add new public workflows under `plugins/ant/skills/`; put detailed guidance that belongs to an existing umbrella skill in its `references/` directory. Avoid same-name Claude command aliases, keep plugin versions aligned when releasing, and validate manifests and relevant documentation before opening a PR.

---

<div align="center">

Made with <img src="assets/heart.svg" height="16" alt="love"> by [(ant)](https://antstudio.cz) — a full-service digital agency from Western Czechia.

</div>
