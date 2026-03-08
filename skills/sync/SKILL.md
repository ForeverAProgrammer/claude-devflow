---
description: Sync the current branch with the latest changes from the default branch.
disable-model-invocation: true
---

Sync the current branch with the latest changes from the default branch.

Steps:
1. Run `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'` to get the default branch name. If that fails, check which of `main` or `master` exist on the remote with `git branch -r`. If only one exists, use it. If both exist, ask the user which to use. If neither exists, tell the user and stop.
2. Run `git fetch origin` to get the latest remote changes.
3. Run `git rebase origin/<default-branch>` to rebase the current branch on top of it.
4. If the rebase succeeds, confirm to the user that the branch is up to date.
5. If the rebase hits conflicts, run `git diff --name-only --diff-filter=U` to list the conflicting files and tell the user which files need to be resolved. Do not attempt to resolve conflicts automatically.

$ARGUMENTS
