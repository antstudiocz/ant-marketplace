# Installation And Updates

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

For orchestrator startup, use the host-specific route and preflight in the [canonical guide](orchestrator.md); Claude root uses `best` at `max`, while Codex root model and effort are developer-selected (`gpt-5.6-sol` at High is recommended). The root-owned durable plan is the shared planning gate, Codex additionally requires its native Goal, and child routing remains mandatory and fail-closed.

## Codex

Global install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
```

Project install:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

Restart Codex or open a new session. Tracked orchestration requires the repository's durable plan, Codex Goal and delegation tools; host-provided planning UI is not required. Detailed routing, fresh-context capsules, and fail-closed preflight are in the [canonical guide](orchestrator.md).

## Update

Claude Code:

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

Codex: rerun the same install command with the same scope, then restart or open a new session.

## Verify

After loading a fresh session, confirm the plugin exposes only:

- `implementation-orchestrator`;
- `merge-request`;
- `brand-design`.

Maintainers validate the repository and plugin manifests using the commands in [AGENTS.md](../AGENTS.md). Version 13.0.0 is instruction-only and needs no orchestration database, runtime, migration, hook, or global helper installation. Durable plans are ordinary human-readable Markdown under each repository's `docs/implementation-plans/` directory.
