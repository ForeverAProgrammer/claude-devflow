Create a GitHub pull request from the current branch using a description provided by the user.

$ARGUMENTS is the PR description — a sentence, bullet points, or a paragraph explaining what the PR does and why. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Push the current branch to the remote if needed:
   - Run `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}` to check if an upstream is set.
   - If no upstream is set, run `git push -u origin HEAD` to push and set tracking.
   - If an upstream is set, run `git push` to make sure the remote is up to date.
3. Derive a PR title (imperative tense, under 72 chars) and a polished description from $ARGUMENTS:
   - What changed (2-4 sentences, plain English)
   - Why it was needed if inferrable from the input
   - No filler like "This PR..." or vague words without specifics
4. Check if a PR already exists for this branch: `gh pr view --json url,number 2>/dev/null`.
   - If no PR exists, run `gh pr create --title "<title>" --body "<description>"` to open one.
   - If a PR already exists, run `gh pr edit --title "<title>" --body "<description>"` to update it.
5. Print the PR URL.
