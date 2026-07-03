# Ant Marketplace - Development Instructions

## Project Structure

```
.claude-plugin/
  marketplace.json    # Claude marketplace config
.agents/plugins/
  marketplace.json    # Codex marketplace metadata
plugins/ant/
  .claude-plugin/
    plugin.json       # Claude plugin metadata with version
  .codex-plugin/
    plugin.json       # Codex plugin metadata with matching version
  commands/           # Claude command aliases only; avoid duplicates of skill names
  skills/             # Shared Claude/Codex public skill folders
    */agents/         # Codex skill UI metadata such as openai.yaml
    */references/     # Internal topic guidance loaded by umbrella skills
assets/               # Shared README and branding assets
```

## Pull Requests

- Always use the `ant:merge-request` / `$merge-request` skill when preparing, creating, or updating a PR/MR.
- Write PR/MR titles in Conventional Commit style and keep PR/MR descriptions in English by default, unless the user explicitly requests another language.
- Use the Merge Request skill's structured description format, including the short summary at the top, the `---` separator, validation notes, and reviewer focus.

## Adding a New Skill

Prefer a new public skill only for a distinct workflow or domain entrypoint. If the topic belongs under frontend, Laravel, delivery, or orchestration, add it as a reference under the existing umbrella skill instead.

1. **Create skill folder and SKILL.md:**
   ```
   plugins/ant/skills/my-skill/SKILL.md
   ```

2. **SKILL.md format:**
   ```markdown
   ---
   user-invocable: true
   name: my-skill
   description: Short description for skill discovery
   ---

   # Skill Title

   Instructions for Claude Code and Codex to follow...
   ```

3. **Do not register skills in marketplace.json.**
   - Claude discovers `plugins/ant/skills/*/SKILL.md` from the plugin root.
   - Codex discovers the same folder through `plugins/ant/.codex-plugin/plugin.json` → `"skills": "./skills/"`.
   - Explicit skill lists in the Claude marketplace can duplicate the same public skills.

4. **Update README.md** - add to Available Skills table

5. **Release new version** (see below)

## Adding Umbrella Skill References

Detailed guidance that should not appear as a public skill belongs in a `references/` file under the owning umbrella skill:

```
plugins/ant/skills/frontend-best-practices/references/my-topic.md
plugins/ant/skills/laravel-best-practices/references/my-topic.md
plugins/ant/skills/delivery-workflows/references/my-topic.md
```

Do not name internal reference files `SKILL.md`; Codex and Claude Code may discover those as public skills.

## Adding a New Command

Commands are optional Claude aliases. Do not create a command with the same name as a public skill; Claude treats `commands/*.md` as flat skill files and this duplicates the exposed skill. Use commands only for meaningful alternate names such as `asana-task` → `asana-task-analyzer`.

1. **Create command file:**
   ```
   plugins/ant/commands/my-command.md
   ```

2. **Command format:**
   ```markdown
   ---
   description: "Short description"
   disable-model-invocation: true
   ---

   Invoke the ant:my-skill skill and follow it exactly as presented to you.
   ```

## Releasing a New Version

**Version files to update:**
- `plugins/ant/.claude-plugin/plugin.json` → `"version": "X.Y.Z"` (Claude plugin update authority)
- `plugins/ant/.codex-plugin/plugin.json` → `"version": "X.Y.Z"` (Codex plugin version)
- `.claude-plugin/marketplace.json` → `"metadata.version": "X.Y.Z"` (marketplace display metadata)

**Version bumping:**
- **Major (X.0.0)** - Breaking changes
- **Minor (X.Y.0)** - New features (new skills)
- **Patch (X.Y.Z)** - Bug fixes, improvements

**Release process:**

1. **Update all version files to the same version:**
   - `plugins/ant/.claude-plugin/plugin.json` → change `"version": "X.Y.Z"`
   - `plugins/ant/.codex-plugin/plugin.json` → change `"version": "X.Y.Z"`
   - `.claude-plugin/marketplace.json` → change `"metadata.version": "X.Y.Z"`

   Claude Code resolves plugin version from `plugins/ant/.claude-plugin/plugin.json` first. Keep marketplace metadata aligned for readability, but do not rely on it as the plugin update authority.

2. **Validate:**
   ```bash
   claude plugin validate .
   claude plugin validate ./plugins/ant
   jq empty .agents/plugins/marketplace.json .claude-plugin/marketplace.json plugins/ant/.claude-plugin/plugin.json plugins/ant/.codex-plugin/plugin.json
   ```

3. **Commit, push and create release:**
   ```bash
   git add -A && git commit -m "feat/fix: description"
   git push origin master
   gh release create vX.Y.Z --title "vX.Y.Z" --notes "## Changes
   - Description of changes"
   ```

**Users update with Claude Code:**
```
/plugin update ant
```

**Users update with Codex:**
Rerun the Codex install command for `antstudiocz/ant-marketplace/plugins/ant`.

## Testing Locally

Claude Code:
```
claude plugin validate .
claude plugin validate ./plugins/ant
claude --plugin-dir ./plugins/ant
```

Codex:
- verify JSON manifests with `jq empty`;
- rerun the plugin install command for the `plugins/ant` path;
- restart Codex or open a new session so updated skills are loaded.

## Skill Best Practices

- Use `AskUserQuestion` tool for user choices with predefined options
- For simple text input, just ask directly (no options needed)
- Reference other skills with `ant:skill-name` or `superpowers:skill-name`
- Keep the public skill list small. Prefer umbrella skills with targeted `references/` over many narrow public skills.
- Add `**Announce at start:**` for clarity on what skill is being used
