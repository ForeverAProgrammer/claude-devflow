---
description: Create a GitLab merge request from the current branch, deriving the title and description from the branch's git history.
disable-model-invocation: true
---

Create a GitLab merge request from the current branch, deriving the title and description from the branch's git history.

Steps:
1. Check that `glab` is installed and authenticated by running `glab auth status`. If not, tell the user and stop.
2. Determine the target branch:
   - If the user passed an explicit target branch in $ARGUMENTS (e.g. `--target-branch <name>` or `--target <name>`), use `<name>` directly as `<base>` and skip the rest of this step.
   - Otherwise, find the closest remote ancestor of the current branch — i.e. the branch this feature branch was actually created from, not necessarily the repository's default branch. Run the following to score each remote branch by how many commits HEAD is ahead of the merge-base with that branch (lower = closer ancestor), then list every branch tied for the lowest score:

     ```bash
     scored=$(git for-each-ref --format='%(refname:short)' refs/remotes/origin/ \
       | grep -v 'origin/HEAD' \
       | grep -v "origin/$(git branch --show-current)" \
       | while read branch; do
           base=$(git merge-base HEAD "$branch" 2>/dev/null) || continue
           echo "$(git rev-list --count "$base"..HEAD) $branch"
         done | sort -n)
     min=$(echo "$scored" | head -1 | awk '{print $1}')
     echo "$scored" | awk -v m="$min" '$1==m {print $2}' | sed 's|origin/||'
     ```

   - If exactly one branch is returned, use it as `<base>`.
   - If multiple branches tie for the lowest score (e.g. several release branches diverged at the same point), tell the user which branches are tied and ask them which one to target. Use their answer as `<base>`.
   - If no branches were returned at all (no remote branches found), fall back to the repository's default branch: `glab repo view --output json | jq -r '.defaultBranch'`.
3. Push the current branch to the remote if needed:
   - Run `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}` to check if an upstream is set.
   - If no upstream is set, run `git push -u origin HEAD` to push and set tracking.
   - If an upstream is set, run `git push` to make sure the remote is up to date.
4. Run `git log --oneline <base>..HEAD` to list commits on this branch.
5. Run `git diff <base>...HEAD --stat` to understand what changed.
6. Check for a GitLab MR description template:
   - Look for `.gitlab/merge_request_templates/Default.md` (the template GitLab applies automatically in the UI).
   - If that doesn't exist, look for any other file under `.gitlab/merge_request_templates/*.md` and use the first one found.
   - If no template file exists, there is no template to follow.
7. Derive an MR title (imperative tense, under 72 chars) from the commits and diff.
8. Derive the MR description from the commits and diff:
   - If a template was found in step 6, fill it in: keep its section headers, checklists, and structure intact, and populate each section with real content derived from the commits and diff. Do not invent content for sections that don't apply — leave them empty or remove placeholder instructional text, but keep the section headers. Do not add sections the template doesn't have.
   - If no template was found, use this freeform structure instead:
     - What changed (2-4 sentences, plain English)
     - Why it was needed if inferrable
     - Notable implementation details as bullet points (optional)
   - Either way, no filler like "This MR..." or vague words without specifics.
9. Check if an MR already exists for this branch: `glab mr list --source-branch "$(git branch --show-current)" --output json 2>/dev/null`.
   - If no MR exists (empty list), run `glab mr create --title "<title>" --description "<description>" --target-branch "<base>"` to open one. Append any user-provided flags from $ARGUMENTS.
   - If an MR already exists, extract its IID from the JSON and run `glab mr update <iid> --title "<title>" --description "<description>" --target-branch "<base>"` to update it.
10. Print the MR URL.

$ARGUMENTS
