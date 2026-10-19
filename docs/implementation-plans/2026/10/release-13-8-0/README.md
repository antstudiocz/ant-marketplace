# Release 13.8.0

User explicitly requested admin merge of PR95 and release on 2026-10-19. PR95 merged as `8c67a17be340658d7990aad29d9f1a1d5b981b0d`, source `75867d7a80a5366cb80c96fadba738967e590b49`. Latest release v13.7.2 at e7b24e7. Choose minor 13.8.0 for the expanded cross-provider review workflow and specialist/evidence capabilities; five existing public skills remain. No installation or unrelated changes.

Endpoint: aligned manifests, concise English release notes and README link, reviewed/checked release PR, authorized admin merge, exact-merge tag v13.8.0 and stable latest GitHub release. Notes link included merged PR95 and release PR plus previous-tag comparison. Verify inclusion, tag target, release flags and versions at tag. No history rewrite or branch deletion.

Root writes only this plan and owns Git/provider/tag/publication. Fresh Luna High integration owner writes three version manifests, docs/releases/13.8.0.md and README release link; plan read-only, no nested delegation. Independent review read-only. Overall-only reviewer sufficient for deterministic release metadata with no policy/runtime edits; compare entire diff and version/notes accuracy. Prior policy review remains applicable because release preparation does not change instructions. No Goal requested or created.

Checks: both plugin validators; jq four manifests; version equality; release link; diff whitespace; source/policy unchanged; independent release review. Final local package gate is sufficient; finite 60-second provider observation budget for release PR. Admin merge approval bypass authorized by user. Source PR checks passed and validators rerun before merge; verify exact source SHA for release checks separately.

Status: release owner preparation next. Preserve historical notes and all other files. Freeze checkpoint will record final review and checks before commit/delivery.

Final checkpoint: owner prepared exactly five assigned release files. Independent fresh Claude Opus High text-only review (`claude-opus-5-5`, successful, zero permission denials) found no material issues; minor semver and overall-only rationale confirmed. Root inspected complete manifests: no separate plugin-entry version field. Earlier PR95 evidence supports the bounded route claim; no new policy/E2E result claimed. Full source, agents, assets and historical notes unchanged by release metadata.

Final gate passed: both plugin validators, four-manifest jq, three versions exactly 13.8.0, README/new-notes path, diff whitespace, source/agent diff empty. Compare-link resolution remains publication readback, because new tag does not exist yet. Freeze now, then scoped commit/push/release PR/admin merge/tag/publication. Provider URLs/SHAs and final tag/release readback remain external delivery evidence; no post-freeze source edits required.
