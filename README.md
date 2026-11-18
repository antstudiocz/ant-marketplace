<p align="center">
  <img src="assets/logo.svg" alt="(ant)" width="200">
</p>

<h3 align="center">Seven focused workflow skills for Claude Code and Codex</h3>

`(ant)` provides an instruction-only plugin for evidence-led research, reviewed implementation, test quality, GitHub/GitLab delivery, merge-conflict resolution, `(ant)` brand work, and marketplace release announcements.

## Install

Claude Code:

```text
/plugin marketplace add antstudiocz/ant-marketplace
/plugin install ant@ant-marketplace
/reload-plugins
```

Codex CLI:

```bash
codex plugin marketplace add antstudiocz/ant-marketplace
codex plugin add ant@ant-marketplace
```

Restart Codex or open a new session after installation/update. See [installation](docs/install.md) for desktop and local marketplace options.

## Public Skills

Invoke `/ant:skill-name` in Claude Code or `$skill-name` in Codex.

| Skill | Use it for |
|---|---|
| `implementation-orchestrator` | New applications, features, fixes, refactors, migrations, and remediation that need discovery, a root-owned Git-tracked durable plan, delegated tracked edits, independent review, final validation, and optional delivery. |
| `deep-research` | Read-only investigation of codebases, architecture, or incidents using broad system discovery, independent specialists, evidence checks, and ranked recommendations. |
| `test-design` | Decide whether automated coverage adds useful protection, then choose scenarios, an observable oracle, and an appropriate layer. |
| `test-maintenance` | Clean up, repair, or optimize existing tests when requested or needed for the agreed implementation. |
| `merge-request` | Read-only PR/MR previews, scoped create/update delivery, exact-head pipeline observation, or intelligent local/remote conflict resolution. |
| `brand-design` | Designing or reviewing websites, apps, decks, documents, visuals, and UI against the `(ant)` identity and bundled assets. |
| `ant-marketplace-release` | Previewing, preparing, verifying, and announcing releases of this marketplace: synchronized versions, the complete merged-PR inventory, release notes, tag/Release/Latest readback, and a separately authorized Czech Google Chat card. |

`deep-research` handles read-only system investigations and distinguishes source facts, runtime measurements, inference, and unknowns. The orchestrator classifies intent, derives the original goal and completion criteria, selects proportional outcome evidence from the changed surface and risk, asks only about consequential missing human intent or impacts outside established authority, keeps root coordination-only, and uses a root-owned durable plan, an optional native Goal when explicitly requested or already in use, an integration owner, independent whole-outcome review, targeted checks, and one risk-appropriate candidate gate. The canonical [review policy](plugins/ant/skills/implementation-orchestrator/references/review.md) guides provider-aware reviewer selection, conditional specialists, evidence-backed findings, and targeted review refresh. For target-project code, it selects the simplest maintainable complete design for verified current needs and requires a pre-freeze simplicity review with concrete justification for significant complexity. Missing or unavailable optional Goal support never blocks otherwise-authorized work under the plan; an explicitly requested Goal remains pending until established and verified. `merge-request` covers read-only Preview and Observe/status, scoped Create/update, and conflict resolution with separate authority boundaries. The shared test-quality policy allows removing tests without meaningful regression protection without replacing them, while preserving distinct product and integration boundaries.

The canonical routing, Goal, recursive delegation, review-invalidation, and provider preflight matrix is in the [orchestrator guide](docs/orchestrator.md). Installation details are in [installation](docs/install.md).

## Documentation

- [Skill guide](docs/skills.md)
- [Orchestrator guide](docs/orchestrator.md)
- [Installation and updates](docs/install.md)
- [13.11.0 release notes](docs/releases/13.11.0.md)
- [13.10.0 release notes](docs/releases/13.10.0.md)
- [13.9.4 release notes](docs/releases/13.9.4.md)
- [13.9.3 release notes](docs/releases/13.9.3.md)
- [13.9.2 release notes](docs/releases/13.9.2.md)
- [13.9.1 release notes](docs/releases/13.9.1.md)
- [13.9.0 release notes](docs/releases/13.9.0.md)
- [13.7.2 release notes](docs/releases/13.7.2.md)
- [13.8.1 release notes](docs/releases/13.8.1.md)
- [13.8.0 release notes](docs/releases/13.8.0.md)

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
