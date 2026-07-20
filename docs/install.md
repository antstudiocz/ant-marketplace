# Installation

Use this guide when you need exact installation commands, update commands, or copy-paste prompts for AI-assisted installation.

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

After installing, reload Claude Code so the skills are available.

## Codex

Global install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
```

Project install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

After installing, restart Codex or open a new session so the updated skills are loaded.

Do not treat a successful package command alone as an orchestrator smoke test. In the fresh session, invoke `implementation-orchestrator` and confirm that it records runtime preflight/route evidence, uses an explicit degraded mode when a capability is unavailable, and fails closed when only delivery metadata exists without immutable approval evidence.

## Install With AI

Paste the relevant prompt into a new assistant session if you want Claude Code or Codex to run the installation for you.

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

## Compatibility And Rollback

Plugin `9.2.0` still writes orchestrator state schema `1.0.0`. Runtime/routing and approval display data are additive metadata, so a rollback to `9.1.0` does not require a state migration. Older readers may ignore the additive fields.

Before release, test install/update/invocation on fresh Claude Code and Codex environments. If the `9.2.0` runtime behavior fails, stop delivery, restore the exact previously verified `9.1.0` tag/revision through the same host installation channel, reload/restart the host, and reopen the existing 1.0 run. Do not infer authorization from metadata during or after rollback; request fresh approval when the older runtime cannot verify the immutable event/artifact.

See [the 9.2.0 release-candidate notes](releases/9.2.0.md) for the required evidence matrix and known manual checks.
