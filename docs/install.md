# Installation and updates

## Claude Code

From Claude Code:

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

## Codex

The current Codex CLI supports marketplace sources directly:

```bash
codex plugin marketplace add antstudiocz/ant-marketplace
codex plugin marketplace list
codex plugin add ant@ant-marketplace
```

Then install or enable `ant` from the configured marketplace using the CLI or Codex desktop Plugins Directory. For a repository-local marketplace, use the repo's `.agents/plugins/marketplace.json`; restart Codex or the desktop app after installing or updating. See the [official plugin packaging guide](https://developers.openai.com/plugins/build/plugins) for current CLI and desktop behavior.

If the installed CLI does not expose `codex plugin marketplace`, update it or use the desktop Plugins Directory. Do not edit `config.toml` by hand when the CLI can manage the source.

## Updates and verification

Claude Code:

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

Codex: refresh or upgrade the configured marketplace, then reinstall/enable the plugin and restart the host.

After a fresh session, verify that only `implementation-orchestrator`, `merge-request`, and `brand-design` are exposed. Maintainers use the checks in [`AGENTS.md`](../AGENTS.md). The plugin is instruction-only and needs no runtime, migration, hook, or database setup.
