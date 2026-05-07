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
  commands/           # Claude command files (aliases for skills)
  skills/             # Shared Claude/Codex public skill folders
    */references/     # Internal topic guidance loaded by umbrella skills
assets/               # Shared README and branding assets
```

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

   Instructions for Claude to follow...
   ```

3. **Register in marketplace.json:**
   ```json
   "skills": [
     "./skills/google-docs",
     "./skills/my-skill"  // Add here, relative to plugins/ant
   ]
   ```

4. **Update README.md** - add to Available Skills table

5. **Release new version** (see below)

## Adding Umbrella Skill References

Detailed guidance that should not appear as a public skill belongs in a `references/` file under the owning umbrella skill:

```
plugins/ant/skills/frontend-best-practices/references/my-topic.md
plugins/ant/skills/laravel-best-practices/references/my-topic.md
plugins/ant/skills/delivery-workflows/references/my-topic.md
```

Do not name internal reference files `SKILL.md`; Codex may discover those as public skills.

## Adding a New Command

Commands are optional aliases that reference skills. The skill itself is what matters.

1. **Create command file:**
   ```
   plugins/ant/commands/my-command.md
   ```

2. **Command format:**
   ```markdown
   ---
   description: "Short description"
   ---

   Invoke the ant:my-skill skill and follow it exactly as presented to you
   ```

## Releasing a New Version

**All manifests must have matching versions:**
- `plugins/ant/.claude-plugin/plugin.json` → `"version": "X.Y.Z"`
- `plugins/ant/.codex-plugin/plugin.json` → `"version": "X.Y.Z"`
- `.claude-plugin/marketplace.json` → `"version": "X.Y.Z"`

**Version bumping:**
- **Major (X.0.0)** - Breaking changes
- **Minor (X.Y.0)** - New features (new skills)
- **Patch (X.Y.Z)** - Bug fixes, improvements

**Release process:**

1. **Update all version files to the same version:**
   - `plugins/ant/.claude-plugin/plugin.json` → change `"version": "X.Y.Z"`
   - `plugins/ant/.codex-plugin/plugin.json` → change `"version": "X.Y.Z"`
   - `.claude-plugin/marketplace.json` → change `"version": "X.Y.Z"` (in metadata section)

   ⚠️ **CRITICAL: All versions MUST match, otherwise plugin won't work correctly!**

2. **Commit, push and create release:**
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

After making changes, Claude Code users need to run `/plugin update ant` to get the latest version from the GitHub release. Codex users should rerun the plugin install command for the `plugins/ant` path.

## Skill Best Practices

- Use `AskUserQuestion` tool for user choices with predefined options
- For simple text input, just ask directly (no options needed)
- Reference other skills with `ant:skill-name` or `superpowers:skill-name`
- Keep the public skill list small. Prefer umbrella skills with targeted `references/` over many narrow public skills.
- Add `**Announce at start:**` for clarity on what skill is being used
