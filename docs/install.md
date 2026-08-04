# Installation

Use this guide for installation, updates, and copy-paste prompts for AI-assisted setup.

## Claude Code

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

Reload Claude Code after installing or updating.

For the orchestrator, establish the root selection before invocation: start with `claude --model best --effort max`, or set `/model best` and `/effort max` in the session. Then invoke `/ant:implementation-orchestrator`. Keep that session setting through the multi-turn workflow; skill frontmatter does not guarantee it. For implementation work, run the exact plan-tailored `/goal` command it gives you before tracked writes unless it can observe a matching session goal; the command replaces any current session goal.

## Codex

Global install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
```

Project install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

Restart Codex or open a new session after installing or updating.

## Install With AI

### Claude Code Prompt

```text
Install the (ant) Claude Code plugin from antstudiocz/ant-marketplace for my user account.

Use these commands:
claude plugin marketplace add antstudiocz/ant-marketplace --scope user
claude plugin install ant@ant-marketplace --scope user

After installation, verify that the plugin is available. If Claude Code needs a reload, tell me to run /reload-plugins. Do not modify the current repository.
```

### Codex Prompt

```text
Install the (ant) Codex plugin globally from antstudiocz/ant-marketplace/plugins/ant.

Use this command:
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global

After installation, verify that the plugin is available and tell me whether I need to restart Codex or open a new session. Do not modify the current repository.
```

## Update

Claude Code:

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

Or from a terminal:

```bash
claude plugin update ant@ant-marketplace
```

Codex: rerun the same `codex-marketplace add` command with the same scope (`--global` or `--project`), then restart Codex or open a new session.

## Verify The Orchestrator

In a fresh session, invoke `implementation-orchestrator` on a small repository task and confirm that it:

- classifies “analyze only” as read-only, “fix it and test it end-to-end” as implementation-authorized, and genuinely ambiguous requests with an early clarification question;
- performs read-only discovery and presents a proportional plan before tracked edits; it continues after that checkpoint for unchanged explicitly authorized work, but waits when the user asked for approval or discovery materially changes scope, behavior, architecture, data, safety/risk, or introduces destructive action;
- for new behavior, brainstorms user needs, asks material questions, and analyzes more deeply before the plan;
- chooses a proportional agent shape and reports a blocker before tracked edits if no writer-capable native delegation is available;
- routes by capability while selecting a real native model and, where supported, effort for every child;
- keeps root at the host's maximum available reasoning effort and pins every child explicitly at High or lower, independently from capability tier; in Codex, history-free children use `fork_turns="none"` and the primary tracked writer may receive only one directly authorizing user turn with `fork_turns="1"`;
- after a stable implementation plan, uses a measurable native goal before tracked-writer dispatch: Codex inspects and reuses or creates a matching goal when native tools are available, while Claude Code gives the user an exact `/goal` command to activate;
- runs targeted checks during work, completes the required review, then runs one broad suite before completion and optional delivery;
- performs a bounded root retrospective after the final suite, corrects any current gap, and proposes no more than one sanitized upstream feedback action only when the finding is material and generalizable;
- asks for separate approval before writing to an upstream issue and never creates a retrospective PR automatically;
- continues unaffected work when you send a status question or authorized-behavior detail;
- batches related material changes from the same active segment into one affected-scope planning and approval cycle at the next safe boundary, without delaying an urgent stop or safety correction;
- invokes `/ant:merge-request` and `/ant:delivery-workflows` in Claude Code or `$merge-request` and `$delivery-workflows` in Codex for delivery handoffs.

Version 10.1 is instruction-only and does not require an orchestration database, state contract, generated runtime, or migration command. See [the 10.0 release notes](releases/10.0.0.md).
