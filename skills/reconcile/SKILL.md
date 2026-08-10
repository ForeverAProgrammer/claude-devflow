---
description: Reverse-update an HLD or LLD doc to match the real code — reads the git diff and spikes since the doc was last reconciled, updates API/Data Model sections to reality, checks off satisfied Requirements, and writes an ADR when the code intentionally diverged from the design. Use to eliminate architectural drift between docs and code.
argument-hint: "[path to HLD or LLD]"
disable-model-invocation: true
---

Eliminate architectural drift by reading passing spike/feature code and reverse-updating the HLD/LLD doc to match reality.

$ARGUMENTS is the path to the HLD or LLD file (e.g. `design/lld-user-auth-service.md`). The path may be omitted if it's already clear from this conversation — see step 1.

Steps:

1. Determine the target path:
   - If $ARGUMENTS contains a path, use it.
   - If not, look back through this conversation for an HLD or LLD path already established (created via `/hld`/`/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If none is found, ask the user to provide a path and stop.
   - Check that the file at that path exists. If it does not, tell the user and stop.

1. Read the file's frontmatter for `**Last Reconciled:**`. Determine scope:
   - If a sha is present, diff `git diff <sha>` (not `<sha>..HEAD` — a plain single-ref diff also picks up uncommitted working-tree changes, which a commit-to-commit range would silently miss if nothing's been committed since the last reconcile).
   - If blank, find the actual base to diff against — not necessarily the default branch:
     - Detect the current branch: `git branch --show-current`.
     - Detect the repo's default branch: `git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}'`; if that fails (no remote configured), check which of `main`/`master` exist locally.
     - **If the current branch is the default branch**, there's no parent branch to diff against — use `origin/<default>` (the remote-tracking ref) if it exists, to catch local commits not yet pushed. If there's no remote either, there's nothing meaningful to diff — scope to `spikes/` only and say so in the final summary rather than failing.
     - **Otherwise**, find the closest ancestor branch — the branch this one was actually created from, which is not always the default branch (e.g. a feature branch cut from `release/1.0`). Score every other branch (local and remote) by how many commits HEAD is ahead of the merge-base with it — lower score means closer ancestor:

       ```bash
       scored=$(git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/origin/ \
         | grep -v 'origin/HEAD' \
         | grep -vE "^(origin/)?$(git branch --show-current)$" \
         | sed 's|^origin/||' | sort -u \
         | while read branch; do
             base=$(git merge-base HEAD "$branch" 2>/dev/null) || continue
             echo "$(git rev-list --count "$base"..HEAD) $branch"
           done | sort -n)
       min=$(echo "$scored" | head -1 | awk '{print $1}')
       echo "$scored" | awk -v m="$min" '$1==m {print $2}'
       ```

       - If exactly one branch is returned, that's the fork-point branch — compute `git merge-base HEAD <that-branch>` and diff from that commit: `git diff <merge-base-sha>` (single-ref, so it also picks up uncommitted changes).
       - If multiple branches tie for closest ancestor (e.g. several release branches diverged at the same point), tell the user which are tied and ask which to use.
       - If no branches were returned at all, fall back to the default branch detected above.
   - Also include any files under `spikes/` created or modified more recently than `Last Reconciled` (or all of `spikes/` if blank).
   - **`git diff` alone is blind to untracked files** — a brand-new file `/implement-lld` just created has no diff at all until it's staged, since `git diff` only shows changes to files git is already tracking. Run `git status --porcelain` (or `git ls-files --others --exclude-standard`) and add any untracked file the doc's `## Scope` references to the changed-file set too. Treat an untracked file's entire current content as new — there's no prior version to diff against, just read it whole.

1. Confirm the doc's `## Scope` section (LLD) or `## System Context` / `## Components` (HLD) actually references the changed files. If the diff touches nothing the doc claims to cover, tell the user there's nothing to reconcile for this doc and stop.

1. Extract the actual exported signatures, types, and schemas from the changed code relevant to this doc.

1. Compare against the doc's `## API / Interface Design` and `## Data Models` sections (LLD), or `## Proposed Design` / `## Components` (HLD). Two cases:
   - **Code caught up to spec** (matches what was designed, just needed the exact real signatures/types filled in) — quietly update the doc's sections to reflect reality. Also resolve any `[PENDING SPIKE VALIDATION]` tags the code now confirms.
   - **Code diverged from spec** (implementation intentionally took a different approach) — make the same doc update, **and** create or append an ADR in `design/adr/` (create the directory if it doesn't exist) using the `/decision` skill's format (Context / Options Considered / Decision / Consequences). Never silently overwrite an intentional deviation without capturing why in the ADR.

1. Check off any `## Requirements` row whose behavior is now satisfied by the code (change `- [ ]` to `- [x]`). Do not touch, check off, or reinterpret any row already marked `_(Needs Review — ...)_` or `_(Needs Spike — ...)_` — leave those for a human (or for `/spike`, in the `Needs Spike` case) and list them in the final summary instead.

1. **Roll up completed parent requirements.** If the doc just reconciled is an LLD that links to an HLD: for each row just checked off that references a parent HLD requirement (`REQ-N.x` referencing HLD `REQ-N`), check every *current* row in this LLD referencing that same `REQ-N` — ignore struck-through/superseded rows (only the latest successor counts), but treat any row still `- [ ]` — including any marked `Needs Review` or `Needs Spike` — as blocking. If none are blocking, check off `REQ-N` in the HLD file too.

1. Stamp `**Last Reconciled:** <today's date> @ <short-sha of HEAD>` in the frontmatter.

1. Report a summary: files reconciled, which doc sections were updated, which Requirements rows were checked off (LLD and any rolled-up HLD rows, listed separately), any ADR created (with its path), and any `Needs Review` or `Needs Spike` rows still outstanding.

Rules:

- Never delete or silently overwrite an intentional design deviation — it must go through an ADR.
- Never touch a `Needs Review` or `Needs Spike` row — resolving those belongs to a human or to `/spike`, not to this skill.
- Only update sections whose corresponding code actually changed; do not regenerate untouched sections.
- Do not commit or push — leave that to the user.

$ARGUMENTS
