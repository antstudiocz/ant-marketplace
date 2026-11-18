---
name: ant-marketplace-release
description: Preview, prepare, verify and announce GitHub releases of antstudiocz/ant-marketplace — three synchronized plugin version fields, exact previous..current tag range with every merged PR, docs/releases notes, tag vs GitHub Release vs Latest readback, and a Czech Google Chat Cards v2 announcement for one release or one combined card for several published releases. Use only for ant-marketplace releases; GitHub provider writes follow the bundled sibling merge-request skill. Not for other repositories, generic changelogs, or non-release chat messages.
---

# ant-marketplace release

Scope: the GitHub repository `antstudiocz/ant-marketplace`, its SemVer releases, and the
Czech Google Chat release card. Anything else is out of scope.

## Three independent endpoints

| Endpoint | What it does | Needs |
| --- | --- | --- |
| **Preview** (read-only) | Release evidence, notes draft, human-readable card preview or draft text, plain-text fallback | Nothing external. Always available, even with no publisher or sender. Proceeds with the evidence available and names any gaps |
| **Publish** | Release-prep PR, tag, GitHub Release, Latest | The bundled sibling `merge-request` workflow + scoped user authorization |
| **Announce** | Send the Czech card to Google Chat | Verified Chat app or webhook route + explicit user approval of the destination and exact content |

- GitHub provider writes (branches, PRs, merges, tags, releases) follow the existing `merge-request`
  workflow under the user's authority. This skill builds the evidence and handoff and reads the result back afterwards.
- Publication rules are canonical in
  [provider-delivery.md#release-publication](../merge-request/references/provider-delivery.md#release-publication).
- This skill owns the Cards v2 assembly and the separately authorized Chat send through a verified Chat app
  or webhook. Card design and the send procedure are in
  [references/google-chat-card.md](references/google-chat-card.md).
  The single-release example is [references/card-example.json](references/card-example.json); the
  combined example is [references/combined-card-example.json](references/combined-card-example.json).
- Default to one release per card. Use the combined card only when the user selects two or more
  published stable releases for one announcement.

## Authorization rules

- Explicit, scoped user authorization is enough. For a release, scope means repo, version/tag, the agreed
  release-prep branch and the Latest intent. When the merge of that branch creates the target SHA, pin that
  SHA and verify it (step 5). Do not ask the user to pre-authorize a SHA that does not exist yet.
- Merging and any admin/branch-protection bypass need their own authorization unless already granted.
- For Chat, the user must explicitly approve the destination channel and the exact payload. Organization
  configuration may establish an available route, but on its own it is not permission to send. This skill
  stores no destination and no secret.
- Do not ask again about an effect that is already authorized. If any part is missing, show a
  concrete preview first, then ask only about the missing part.
- Never silently switch the repo, commit, tag, release target or Chat receiver. If something differs from the authorization, stop and ask.
- A denial is final for that effect. Do not try it again through another tool, route or wording.
- Never send twice, retag, or republish/edit an existing release without being asked.
- Never put secrets (tokens, webhook URLs, keys) in previews, source, notes, logs or reports.

## Release evidence (preview, read-only)

1. **Repository**: confirm that `origin` is `github.com/antstudiocz/ant-marketplace`. Read the
   *current* default branch from the provider (e.g. `gh repo view --json defaultBranchRef`). Do not
   assume the name. Fetch refs and tags.
2. **Clean checkout**: if `git status --porcelain` is empty, use the existing checkout. If it is
   dirty, isolate the read-only work (e.g. read refs directly with `git show <ref>:<path>`, or use a
   separate worktree/clone) and report that the checkout was dirty. Never stash, reset or discard
   user work, and never stall all read-only work because of it.
3. **Versions**: read all three fields:
   `.claude-plugin/marketplace.json` → `metadata.version`,
   `plugins/ant/.claude-plugin/plugin.json` → `version`,
   `plugins/ant/.codex-plugin/plugin.json` → `version`.
   In the preview, the new version is a *proposed* bump over the current default-branch values. At the
   exact tag-ready commit (step 5), all three must match the new version. For existing tags, read the
   tagged manifests (`git show <tag>:<path>`), not the working tree.
4. **SemVer**: pick major/minor/patch from the user's intent. If the intent is unclear, propose one and say why.
5. **Target commit**: the exact, verified default-branch commit SHA where all three versions equal the
   new version. If the release-prep merge creates it, pin the resulting SHA after the merge and verify
   it. Record the full SHA and use it from here on.
6. **Previous release**: the preceding *published stable* SemVer release in the relevant line
   whose commit is an ancestor of the target (`git merge-base --is-ancestor`). Exclude drafts and
   prereleases. Never choose it by publish timestamp. If there is no previous release/tag (first
   release), either explicitly verify the base used for the range or omit the comparison, and report
   the scope covered.
7. **PR inventory**: list every commit in `<prev-tag>..<target>` from local git (paginate; never
   rely on a provider compare that may be truncated). If a GitHub comparison is truncated, derive the
   complete range from local Git and verify the actual PR mapping per commit. Map commits to PRs through provider
   associations (`repos/{owner}/{repo}/commits/{sha}/pulls`). Then confirm each PR is merged into the
   default branch and its merge commit is in the range. Include **all** verified PRs, not just the
   headline ones. Flag direct commits that have no PR, mappings that could not be resolved, and
   compare output that was truncated or unavailable.
   **Provisional vs final**: an inventory built before the final target exists is provisional. It may
   inform previews, the release-prep PR and enumeration previews, and none of those are blocked by it.
   Immediately before publication (tag, GitHub Release, Latest) and again immediately before a production
   announce, recompute the complete inventory over `<prev-tag>..<target>` using the exact final target SHA
   from step 5, including the release-prep merge. Every commit in that range needs either a verified merged
   PR association (as above) or positive evidence that it is a direct commit; a failed, truncated or empty
   lookup is not evidence. If any commit's coverage is unresolved, stop publication or the production send
   and report the gap.
8. **Notes**: the canonical notes live in `docs/releases/<version>.md`. Add the new version to
   the README release index and keep all earlier entries. When announcing, read the notes at the tag.
9. **Existing state**: if the tag already exists and (peeled to its commit) points to the target, reuse it. If it
   points somewhere else, stop. An existing GitHub Release is never re-created or edited silently.

## Combined announcement (two or more releases)

For preview or announcement of already published releases: it composes one card for them and changes no tag,
release, Latest or Git state. Publish each release separately through the normal flow.

1. **Normalize**: map `13.10.0` and `v13.10.0` to the canonical tag `v13.10.0`. Merge duplicates and
   disclose that in the preview. Reject or flag invalid versions, missing tags, drafts and prereleases.
2. **Verify each release independently**: tagged manifests (step 3), notes at the tag (step 8), the
   peeled tag commit as target, its own preceding stable ancestor tag (step 6), and the complete
   commit-to-merged-PR mapping (step 7), even when the card omits PR chips.
3. **No absorption**: a nonconsecutive selection covers only the selected releases; skipped releases are
   neither shown nor merged into a neighbor's range.
4. **Order**: sort by numeric SemVer ascending for sections and buttons.
5. **Current stable**: read Latest (see remote readback) as the verified current stable release for the
   intended audience and record whether the newest selected release equals it. The card reference decides the update line from that.
6. **Gaps**: show incomplete or unresolved evidence in the preview. It blocks a production send.

Layout, fallback and send identity are in
[references/google-chat-card.md](references/google-chat-card.md#combined-card-two-or-more-releases).

## Publication handoff (via `merge-request`)

Give the `merge-request` workflow the verified evidence. Release preparation (version bumps, notes,
README index) goes through a normal PR. Publishing follows the canonical `#release-publication` section.

- Hand off tag/Release publication only after the final inventory recompute (step 7) passes for the exact
  target SHA. Unresolved coverage stops publication.
- A tag and a GitHub Release are separate objects. Verify each one separately.
- For an authorized historical catch-up, pin the older exact commit (`--target <sha>`) and
  pass `--latest=false`. Only the intended current release becomes Latest.
  See [gh release create](https://cli.github.com/manual/gh_release_create).

## Verification and reporting

- **Local validation**: manifests agree, notes file and README index exist, card JSON parses,
  links point to the tag. This is static evidence only.
- **Remote readback**: `git ls-remote --tags origin 'refs/tags/v<version>' 'refs/tags/v<version>^{}'`
  (tag → SHA; for an annotated tag the peeled `^{}` line is the commit to compare with the target),
  `gh release view v<version> --json tagName,targetCommitish,isDraft,isPrerelease,url`, and
  `gh api repos/antstudiocz/ant-marketplace/releases/latest` (Latest). Report each one separately.
  `targetCommitish` is release metadata, not proof of where the tag points.
- Static checks never prove that anything was installed, published or sent. Report actual receipts
  (release URL, Chat message name) exactly as returned. Mark native card rendering as
  *unverified* until someone has seen it.
