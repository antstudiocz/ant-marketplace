# LeMatosDeFuk Marketplace

Claude Code skills marketplace with auto-update support.

## Installation

1. Run `/marketplace add` in Claude Code
2. Press **Tab** to switch to **"Marketplaces"** tab
3. Select **"+ Add Marketplace"**
4. Enter: `LeMatosDeFuk/lematodefuk-marketplace`
5. Press Enter to install

## Available Skills

| Skill | Description |
|-------|-------------|
| **google-docs** | Read and extract content from Google Docs including text and images |
| **asana-task-analyzer** | Analyze Asana tasks for implementers - extracts requirements, flags unclear items |
| **handle-mr-feedback** | Analyze GitLab MR review comments, validate against code, create implementation plan |

## Install a Skill

After adding the marketplace:

```bash
/plugin install google-docs@lematodefuk-marketplace
/plugin install asana-task-analyzer@lematodefuk-marketplace
/plugin install handle-mr-feedback@lematodefuk-marketplace
```

## Update Skills

Skills auto-update when Claude Code starts, or manually:

```bash
/plugin update
```

## Contributing

Want to add your skill?

1. Create a folder in `skills/your-skill-name/` with a `SKILL.md` file
2. Add your plugin to `.claude-plugin/marketplace.json`
3. Open a PR
