<p align="center">
  <img src="logo.svg" alt="Ant Studio" width="200">
</p>

# (ant) Marketplace

Ant Studio skills for Claude Code.

## Installation

1. Run `/marketplace add` in Claude Code
2. Press **Tab** to switch to **"Marketplaces"** tab
3. Select **"+ Add Marketplace"**
4. Enter: `LeMatosDeFuk/lematodefuk-marketplace`
5. Press Enter to add marketplace

## Available Skills

| Plugin | Command | Description |
|--------|---------|-------------|
| `ant:google-docs` | `/ant:google-docs` | Read and extract content from Google Docs |
| `ant:asana-task-analyzer` | `/ant:asana-task-analyzer` | Analyze Asana tasks for implementers |
| `ant:handle-mr-feedback` | `/ant:handle-mr-feedback` | Handle GitLab MR review feedback |

## Install Skills

```bash
/plugin install ant:google-docs@ant-marketplace
/plugin install ant:asana-task-analyzer@ant-marketplace
/plugin install ant:handle-mr-feedback@ant-marketplace
```

## Update

```bash
/plugin update ant:google-docs
/plugin update ant:asana-task-analyzer
/plugin update ant:handle-mr-feedback
```

## Contributing

1. Create a folder in `skills/your-skill-name/` with a `SKILL.md` file
2. Open a PR
