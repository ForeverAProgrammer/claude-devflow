Create a branch linked to a GitHub issue and check it out locally.

$ARGUMENTS is the issue number. If $ARGUMENTS is empty, ask the user to provide an issue number and stop.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Run `gh issue view $ARGUMENTS --json title,state` to confirm the issue exists. If it doesn't exist or is already closed, tell the user and stop.
3. Check if `gh issue develop` is available by running `gh issue develop --help 2>/dev/null`. Then:
   - **If available:** Run `gh issue develop $ARGUMENTS --checkout`. Pass `--name <name>` if a custom name was provided in $ARGUMENTS. GitHub names the branch `<number>-<issue-title-slug>` automatically and links it to the issue.
   - **If not available (older gh):** Derive the branch name from the issue number and title: lowercase the title, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with the issue number (e.g. `12-add-decision-command`). Run `git checkout -b <branch-name>`.
4. Tell the user the branch name and confirm they are now on it.
   - If `gh issue develop` was used: note that the branch is linked to the issue and will appear in the issue's Development sidebar automatically.
   - If the fallback was used: note that `gh issue develop` requires gh v2.11+ and suggest upgrading. Advise adding `Closes #<number>` to the PR description to link the issue when opening a PR.
