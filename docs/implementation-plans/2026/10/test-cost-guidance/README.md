# Test cost guidance

User authorizes a marketplace PR updating existing test-design/test-maintenance
skills with six agreed improvements: distinguish cleanup from performance, locate
actual costs, address coherent repeated patterns, consider test-layer costs,
preserve executable contracts during consolidation, and bound honest measurement.
No new public skill, runtime, benchmark framework, version release, merge or deploy.

Separate companion authorization: remove the new purposeful-testing skill,
symlink and AGENTS routing from ant-asana MR !1005, preserving cleanup tests.
MR baseline 0360a36087ca6eb07b5156f1ea717d92ea0a3186; source branch
chore/test-suite-purposeful-cleanup. Isolated clone under /private/tmp avoids
modifying the original dirty marketplace checkout or current ant-asana checkout.

Continuity: new marketplace branch chore/test-cost-guidance from origin/master
670fe18; update same MR !1005 source with a normal follow-up commit. Endpoints:
draft marketplace PR to master and scoped MR update preserving readiness.
No Goal requested. Incremental cadence: instruction/link review and repo validators;
one narrow docs-only final gate for each candidate. No app suites for unchanged
application/test behavior. Exact provider source and required checks reported.

Root owns plan/Git/provider only. Fresh Luna High integration owner owns skill
policy/entrypoints/docs changes plus scoped removal in isolated MR clone;
no nested delegation. Anthropic overall read-only reviewer per current marketplace
cross-provider policy after frozen source; verify route/tools and full diff.
Overall-only review is proportional: no new runtime or security behavior.

Acceptance: six practical decision improvements, canonical rules in shared
policy with short entrypoints, no duplicated repo-specific policy. Useful tests
without a cheaper equivalent retained; worthless tests can be removed without
replacement. Failed or inconclusive measurement cannot become a speedup claim.
Marketplace docs aligned, links valid, validators pass or precise gaps disclosed.
MR !1005 contains no active purposeful-testing skill or AGENTS pointer; test
cleanup files untouched by this follow-up. Audit evidence kept as history with
an explicit superseding user decision where needed.

State: preflight complete; owner dispatch next. Original source checkouts remain
untouched. Root will inspect final diff, checks and independent review before
commit/push/PR, preserve foreign concurrent work and recheck source before push.

Candidate checkpoint: owner Luna High edited only shared test-quality policy
and its one-line docs/skills summary, consolidating cost rules in one section
instead of repeating guidance. Existing public entrypoints already link the
shared policy and remain unchanged. Repo marketplace/plugin validations,
manifest JSON parsing, affected relative links and diff checks passed after
simplification. Companion MR delta is four skill/symlink deletions, removal
of AGENTS routing and a superseding note in audit analysis, no code/tests changed.
Source branches verified unchanged before freeze. Opposite-provider overall
review now receives both complete deltas and canonical repo instructions.
Final gate is documentation/plugin validation; runtime/performance outcomes
are not claimed. Delivery snapshots/checks will be in provider descriptions.

Review limitation: restricted Claude CLI initialized with claude-opus-5-5,
Read/Grep/Glob only, dontAsk and no MCP servers, but the sandbox invocation
returned Not logged in. Read-only auth status confirmed authentication outside
the sandbox. The authenticated review invocation was explicitly rejected by
host automatic approval review because it would send private checkout diffs
and the prompt to a third-party Claude API without explicit user approval.
No retry, indirect dispatch or provider substitution will bypass that denial.
Opposite-provider overall review remains UNVERIFIED. Existing authority permits
publishing drafts with this material gap visible; no merge/release/readiness
change. Root will request only the missing external-review approval after the
concrete PR and scoped companion update are reviewable.

Root inspected the complete scoped diffs: shared cost guidance is canonical,
entrypoints unchanged, no new skill/framework. Companion removes only the
skill/routing and annotates audit history. These source/static observations do
not prove future agent decisions or performance improvement. Final document
checks repeat after this plan checkpoint; provider snapshots remain separate
from implementation validation. No known material source finding remains;
independent review is pending, not accepted by inference.
