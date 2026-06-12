---
user-invocable: true
name: hermes-tweet
description: Install, configure, and use Hermes Tweet for Hermes Agent X/Twitter search, reads, and approval-gated actions through Xquik.
---

# Hermes Tweet

**Announce at start:** "I'll verify the Hermes Tweet setup and keep write actions approval-gated."

Use this skill when the user wants Hermes Agent, Claude Code, or Codex guidance
for X/Twitter workflows powered by the Hermes Tweet plugin.

Hermes Tweet is a native Hermes Agent plugin published as `hermes-tweet`. It
adds catalog-first tools for X search, account reads, trends, monitors, media,
draws, and controlled account actions through Xquik.

## Baseline

- Read the repository or workspace instructions first.
- Never ask for API key values in chat, issues, logs, or tool arguments.
- Keep `tweet_action` disabled unless the user explicitly needs private reads,
  writes, monitors, webhooks, extraction jobs, media, draws, or
  account-changing actions and the runtime has
  `HERMES_TWEET_ENABLE_ACTIONS=true`.
- Prefer read-only exploration and reads for unattended, scheduled, gateway, or
  background sessions.
- Do not guess Xquik endpoint paths. Use `tweet_explore` before `tweet_read` or
  `tweet_action`.

## Install

For a normal Hermes Agent install:

```bash
hermes plugins install Xquik-dev/hermes-tweet --enable
```

If the plugin is already installed but hidden, enable it:

```bash
hermes plugins enable hermes-tweet
hermes tools list
```

Set `XQUIK_API_KEY` in the Hermes runtime environment or in `~/.hermes/.env`.
For remote gateway profiles, configure the remote Hermes host where plugin tools
execute. Do not put key values in chat.

## Workflow

1. Use `tweet_explore` for endpoint discovery and capability lookup.
2. Use `tweet_read` for catalog-listed public read-only endpoints after the API
   key is available.
3. Use `tweet_action` only for private reads, writes, monitors, webhooks,
   extraction jobs, media, draws, or account-changing actions after the user
   approves the exact endpoint, method, and payload.

## Troubleshooting

- If only `tweet_explore` appears, configure `XQUIK_API_KEY` where Hermes runs.
- If `tweet_action` is unavailable, confirm the user wants private reads,
  writes, monitors, webhooks, extraction jobs, media, draws, or
  account-changing capability and set `HERMES_TWEET_ENABLE_ACTIONS=true` only
  for that controlled session.
- If Hermes Desktop uses a remote gateway profile, install and configure Hermes
  Tweet on the remote host, not only on the desktop client.
- If copied endpoint URLs fail, normalize them to catalog-listed `/api/v1/...`
  paths returned by `tweet_explore`.

## Safety Checklist

- API keys remain in the runtime environment.
- Private reads, writes, monitors, webhooks, extraction jobs, media, draws, and
  account-changing actions are user-approved before `tweet_action`.
- Read-only workflows stay on `tweet_explore` and `tweet_read`.
- Account connection, re-authentication, billing, credit, support, and API-key
  admin endpoints are not used through this plugin.
