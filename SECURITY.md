# Security Policy

## Reporting a Vulnerability

Please do not report suspected security vulnerabilities through public issues.

Use GitHub's private security advisory flow when available for this repository.
If you cannot access private advisories, contact the repository maintainers
directly and include:

- the affected file, skill, manifest, or release version;
- a clear reproduction path or abuse scenario;
- any observed exposure of secrets, credentials, tokens, or private data;
- whether the issue is already public.

Maintainers should acknowledge valid reports, triage impact, and publish a fix or
mitigation before discussing exploit details publicly.

## Supported Versions

The latest released plugin version is supported for security fixes.
Older versions may receive fixes only when the same issue affects the current
release line.

## Scope

Security-sensitive areas include:

- plugin and marketplace manifests;
- public skill instructions and bundled reference material;
- install/update instructions;
- release tags and published plugin versions;
- repository settings that protect `master` and releases.
