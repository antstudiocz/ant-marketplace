<p align="center">
  <img src="assets/logo.svg" alt="(ant)" width="200">
</p>

<h3 align="center">Three focused workflow skills for Claude Code and Codex</h3>

`(ant)` provides an instruction-only plugin for verified implementation, GitHub/GitLab delivery, merge-conflict resolution, and `(ant)` brand work.

## Install

Claude Code:

```text
/plugin marketplace add antstudiocz/ant-marketplace
/plugin install ant@ant-marketplace
/reload-plugins
```

Codex, global or project scope:

```bash
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --global
bunx codex-marketplace add antstudiocz/ant-marketplace/plugins/ant --plugin --project
```

Restart Codex or open a new session after installation/update. See [installation](docs/install.md).

## Public Skills

Invoke `/ant:skill-name` in Claude Code or `$skill-name` in Codex.

| Skill | Use it for |
|---|---|
| `implementation-orchestrator` | New applications, features, fixes, refactors, migrations, and remediation that need discovery, a presented Plan, delegated tracked edits, independent review, final validation, and optional delivery. |
| `merge-request` | Read-only PR/MR previews, scoped create/update delivery, exact-head pipeline observation, or intelligent local/remote conflict resolution. |
| `brand-design` | Designing or reviewing websites, apps, decks, documents, visuals, and UI against the `(ant)` identity and bundled assets. |

The orchestrator classifies intent, keeps root coordination-only, and uses an integration owner, independent review, targeted checks, and one final broad suite. `merge-request` covers read-only Preview and Observe/status, scoped Create/update, and conflict resolution with separate authority boundaries.

The canonical routing, Goal, recursive delegation, review-invalidation, and provider preflight matrix is in the [orchestrator guide](docs/orchestrator.md). Installation details are in [installation](docs/install.md).

## Documentation

- [Skill guide](docs/skills.md)
- [Orchestrator guide](docs/orchestrator.md)
- [Installation and updates](docs/install.md)
- [12.0.1 release notes](docs/releases/12.0.1.md)

## Update

```text
/plugin marketplace update ant-marketplace
/plugin update ant@ant-marketplace
/reload-plugins
```

For Codex, rerun the install command with the same scope and restart/open a new session.

---

<div align="center">

Made with <img src="assets/heart.svg" height="16" alt="love"> by [(ant)](https://antstudio.cz).

</div>
