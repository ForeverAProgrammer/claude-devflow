Create a GitHub pull request from the current branch.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Get the repo's default branch: `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`. Use this as the base for all comparisons below (referred to as `<base>`).
3. Push the current branch to the remote if needed:
   - Run `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}` to check if an upstream is set.
   - If no upstream is set, run `git push -u origin HEAD` to push and set tracking.
   - If an upstream is set, run `git push` to make sure the remote is up to date.
4. Run `git log --oneline <base>..HEAD` to list commits on this branch.
5. Run `git diff <base>...HEAD --stat` to understand what changed.
6. Derive a PR title (imperative tense, under 72 chars) and description from the commits and diff:
   - What changed (2-4 sentences, plain English)
   - Why it was needed if inferrable
   - Notable implementation details as bullet points (optional)
   - No filler like "This PR..." or vague words without specifics
7. Check if a PR already exists for this branch: `gh pr view --json url,number 2>/dev/null`.
   - If no PR exists, run `gh pr create --title "<title>" --body "<description>"` to open one. Append any user-provided flags from $ARGUMENTS.
   - If a PR already exists, run `gh pr edit --title "<title>" --body "<description>"` to update it.
8. Print the PR URL.

$ARGUMENTS
