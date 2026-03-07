Create a branch linked to a GitHub issue and check it out locally.

$ARGUMENTS is the issue number. If $ARGUMENTS is empty, ask the user to provide an issue number and stop.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Run `gh issue view $ARGUMENTS --json title,state` to confirm the issue exists. If it doesn't exist or is already closed, tell the user and stop.
3. Run `gh issue develop $ARGUMENTS --checkout` to create a branch linked to the issue and check it out locally.
   - GitHub names the branch `<number>-<issue-title-slug>` automatically (e.g. `12-add-decision-command`).
   - If the user passed a custom branch name via $ARGUMENTS (e.g. `/create-issue-branch-github 12 --name my-branch`), pass it through with `--name`.
4. Tell the user the branch name and confirm they are now on it. Note that the branch is linked to the issue — when a PR is opened from this branch, GitHub will automatically show it in the issue's Development sidebar.
