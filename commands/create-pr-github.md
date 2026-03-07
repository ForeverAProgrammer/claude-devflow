Create a GitHub pull request from the current branch.

Steps:
1. Run `git log --oneline $(git merge-base HEAD @{upstream} 2>/dev/null || git merge-base HEAD origin/HEAD)..HEAD` to see commits on this branch not yet in the base. If that fails, run `gh pr create --fill --dry-run` to preview what `gh` would infer.
2. Run `git diff $(git merge-base HEAD origin/HEAD)...HEAD --stat` to understand what changed.
3. Derive a PR title (imperative tense, under 72 chars) and description from the commits and diff:
   - What changed (2-4 sentences, plain English)
   - Why it was needed if inferrable
   - Notable implementation details as bullet points (optional)
   - No filler like "This PR..." or vague words without specifics
4. Run `gh pr create --title "<title>" --body "<description>"` to open the PR.
   - If the user provided extra flags or a base branch override in $ARGUMENTS, append them.
   - If `gh` is not installed or not authenticated, tell the user and stop.
5. Print the PR URL returned by `gh`.

$ARGUMENTS
