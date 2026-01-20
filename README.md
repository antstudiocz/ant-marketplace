# LeMatosDeFuk Marketplace

Claude Code skills marketplace with auto-update support.

## Installation

```bash
/marketplace add github:LeMatosDeFuk/lematodefuk-marketplace
```

## Available Skills

| Skill | Description |
|-------|-------------|
| **google-docs** | Read and extract content from Google Docs including text and images |
| **asana-task-analyzer** | Analyze Asana tasks for implementers - extracts requirements, flags unclear items |
| **handle-mr-feedback** | Analyze GitLab MR review comments, validate against code, create implementation plan |

## Install a Skill

After adding the marketplace:

```bash
/install google-docs
/install asana-task-analyzer
/install handle-mr-feedback
```

## View Installed Skills

To see your installed marketplaces and skills:

```bash
/marketplace list
```

Or in the UI: `/marketplace add` → press **Tab** to switch to **"Marketplaces"** or **"Installed"** tab.

## Update Skills

Skills auto-update when Claude Code starts, or manually:

```bash
/marketplace update
```

## Contributing

Want to add your skill?

1. Create a folder in `skills/your-skill-name/` with a `SKILL.md` file
2. Add your plugin to `.claude-plugin/marketplace.json`
3. Open a PR
