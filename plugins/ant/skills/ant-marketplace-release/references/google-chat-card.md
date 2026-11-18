# Czech Google Chat release card

The card is built from the canonical release evidence: tagged manifests, `docs/releases/<version>.md`
at the tag, and the complete PR inventory (SKILL.md step 7). Reusable example:
[card-example.json](card-example.json), the known read-only v13.10.0 example. It is demonstrative only:
it shows the payload shape for that release and does not establish the delivery state of any announcement.

Official docs: [Cards v2 `Card`](https://developers.google.com/workspace/chat/api/reference/rest/v1/Card),
[`spaces.messages.create` (incl. `requestId`)](https://developers.google.com/workspace/chat/api/reference/rest/v1/spaces.messages/create).

## Routes

| Route | Cards v2 | Safe retry |
| --- | --- | --- |
| Verified Chat app (`spaces.messages.create`) | Yes | One stable `requestId` per authorized send. The API returns the existing message for a repeated ID. Readback only if authorized |
| Intentionally authorized incoming webhook | Yes | Do not assume `requestId`/`messageId` support. A webhook cannot read messages, so there is no readback |
| Other Chat connector or tool | Only if its current documentation or help confirms Cards v2; otherwise plain text only | Only what its current documentation confirms. Otherwise never resend after an unknown result |

- Nothing is stored: no credential, no source config, no destination. The user names the route and
  explicitly approves the destination alias for each send. Organization configuration may establish an
  available route, but on its own it is not permission to send.
- Webhook config is optional and must be approved by the user. Read it into memory only. Never print,
  log, echo or write the URL or its key/token. Redact it in errors.
- If the authorized route cannot render cards, send the plain-text fallback only if that content is
  also authorized. Otherwise stop and ask. Never switch to another route or receiver on your own.

## Card design

- **Header title**: `Novinky v (ant) pluginu <version>`, with the bare version **at the end** and no `v`
  prefix, e.g. `Novinky v (ant) pluginu 13.10.0`.
  A short Czech `subtitle` gives the topic, e.g. `Plánování a review`. Do not add a plain release URL anywhere on the card.
- **Section headers**: `Co se mění` for the changes, `PR v tomto vydání` for the PR chips.
- **Changes**: a flat list of 2–4 `decoratedText` widgets. Each has a Material `startIcon`
  (`{"materialIcon":{"name":"…"}}`), short Czech copy with `wrapText: true`, and a small native
  `bottomLabelText` link to the skill(s) whose behavior **actually** changed in that item.
  Pin the links to the release tag: `https://github.com/antstudiocz/ant-marketplace/blob/v<version>/plugins/ant/skills/<skill>/SKILL.md`.
  Decide this per item from the diff. Do not repeat the same list of skills on every item.
- **PRs**: one `chipList` with `layout: "WRAPPED"`. Each verified PR gets one chip, labeled
  `#<n> · <krátký český název>`, with `onClick.openLink` to the PR. Never drop a PR.
- **Long PR lists only** (roughly more than 8): split the chips into several `chipList` widgets in one
  section with `collapsible: true` and a bounded `uncollapsibleWidgetsCount` (e.g. 1). Every chip stays
  reachable when the section is expanded.
- **Update instruction**: one `textParagraph` above the button:
  `<b>Aktualizujte (ant) plugin na <version></b> a otevřete novou relaci.`
- **CTA**: one `buttonList` with a single button, `Zobrazit release v<version>`, linking to the actual
  GitHub Release URL.
- `cardId` stays stable for each release: `ant-marketplace-release-v<version>`.

## Test vs production

- **Test**: insert a first section with
  `{"textParagraph":{"text":"<b>TEST</b> – ukázka, nejedná se o oficiální oznámení."}}`, use a test destination
  that the user has authorized, and give it a separate test `requestId`. Any sample PR or link that is not part
  of the release is labeled `UKÁZKA` and appears in tests only.
- **Production**: remove the test section and all sample items. Only links that belong to the release
  remain. Send to the production destination the user explicitly approved for this exact content.

## Plain-text fallback (text-only or no card route)

Write Czech text with visible links, using `<url|label>` syntax:
- the title with the version at the end, same as the card header (`Novinky v (ant) pluginu <version>`)
- every change, with its skill link
- **every** PR as a link
- the update instruction
- the release link

## Send procedure (authorized only)

1. Show the final preview: route, exact destination alias (never the secret), the exact content as a
   human-readable card preview or the draft text (raw JSON is not required; show it only on request), and the
   `requestId` if the route supports it. The send needs explicit user approval of this exact recipient and content.
   A production card must be built from the complete inventory recomputed for the exact final target
   immediately before the send (SKILL.md step 7); unresolved coverage stops the production send.
2. Before sending, check for a prior send: use authorized receipts or authorized readback, plus any
   available nonsecret run evidence (no new registry or state store is needed), matching repo/tag,
   destination alias and test/production scope. If a confirmed matching send exists, that send is already
   done: report its receipt and send another only if the user specifically authorizes it. On resume, reuse
   the same `requestId` where the exact route supports it. If an earlier attempted webhook send is still
   uncertain and there is no authorized readback, ask for verification in the recipient destination before
   risking a duplicate.
3. If the authorization covers all of it, send **once**. Record the receipt exactly as returned
   (HTTP status, `name` of the message).
4. If the result is unknown (timeout, connection reset), do **not** resend by default. Retry only with the
   same `requestId` on a route documented to support it. Otherwise check an authorized readback, or
   stop and ask before risking a duplicate. An incoming webhook has no readback.
5. An accepted API response is not proof that the card renders correctly. Report rendering as
   unverified until someone has looked at it.

## Static validation checklist

- JSON parses. Top level is `cardsV2[].cardId` + `card`.
- The version in the title (no `v`) matches the tag, the button (`Zobrazit release v<version>`) and the update instruction.
- Section headers are `Co se mění` and `PR v tomto vydání`.
- Every PR in the complete inventory (recomputed for the final target, SKILL.md step 7) has exactly one chip, and no other PRs are present.
- Skill links use `/blob/v<version>/`. The CTA points to `/releases/tag/v<version>`.
- No secrets and no destination identifiers in the payload, source or logs.
- In production there is no test banner and no sample label.
