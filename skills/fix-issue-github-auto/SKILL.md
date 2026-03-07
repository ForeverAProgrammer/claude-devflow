---
description: Fully automate resolving a GitHub issue: create a linked branch, apply code changes, commit, open a PR, and resolve any conflicts.
argument-hint: "[issue-number]"
disable-model-invocation: true
---

Fully automate resolving a GitHub issue: create a linked branch, apply code changes, commit, open a PR, and resolve any conflicts.

$ARGUMENTS is the issue number. If $ARGUMENTS is empty, ask the user to provide an issue number and stop.

Steps:

1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop. Run `gh issue view $ARGUMENTS --json title,state` to confirm the issue exists and is open. If it doesn't exist or is already closed, tell the user and stop.

2. Check if `gh issue develop` is available by running `gh issue develop --help 2>/dev/null`. Then:
   - If available: run `gh issue develop $ARGUMENTS --checkout`. GitHub names the branch `<number>-<issue-title-slug>` automatically and links it to the issue.
   - If not available (older gh): derive the branch name from the issue number and title — lowercase, spaces and special characters replaced with hyphens, truncated to ~5 words, prefixed with the issue number (e.g. `12-add-decision-command`). Run `git checkout -b <branch-name>`.

3. Run `gh issue view $ARGUMENTS --json title,body,comments,labels` to fetch the full issue context. Analyse the title, body, and comments to understand what is being requested. Explore the codebase to find the relevant files, reading them to understand the current implementation before making any changes. Apply the minimum code changes needed to resolve the issue — fix bugs by correcting the root cause, add features by following existing patterns, and do not refactor or change unrelated code.

4. Run `git diff --staged --stat` to check for staged changes. If nothing is staged, run `git add -A` to stage everything. Run `git diff --staged` to review what will be committed. Run `ls CHANGELOG.md 2>/dev/null` — if a changelog exists, regenerate the `## Unreleased` section treating the new changes as already included, write it back to `CHANGELOG.md`, and run `git add CHANGELOG.md`. Write a commit message in Conventional Commits format (`type(scope): short description`, imperative tense, under 72 characters). Commit immediately with `git commit -m "..."`.

5. Get the default branch with `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`. Check if an upstream is set with `git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null`. If not set, run `git push -u origin HEAD`. If set, run `git push`. Run `git log --oneline <base>..HEAD` and `git diff <base>...HEAD --stat` to understand the branch changes. Derive a PR title (imperative tense, under 72 chars) and description from the commits and issue context. Include `Closes #$ARGUMENTS` in the PR body to link the issue. Check if a PR already exists with `gh pr view --json url,number 2>/dev/null`. If no PR exists, run `gh pr create --title "<title>" --body "<description>"`. If one exists, run `gh pr edit --title "<title>" --body "<description>"`.

6. Run `gh pr view --json mergeable --jq '.mergeable'`. If the result is `CONFLICTING`:
   - Run `git fetch origin` then `git rebase origin/<base>`.
   - If the rebase stops with conflicts, run `git diff --name-only --diff-filter=U` to list conflicting files. For each file, read it, resolve conflicts by merging both sides if both changes are needed, preferring incoming (`theirs`) if it supersedes the current change, or keeping current (`ours`) if the incoming change is unrelated. Run `git add <file>` after resolving each file. Run `git rebase --continue` when all conflicts are resolved.
   - If a conflict is too ambiguous to resolve safely, run `git rebase --abort`, explain what was ambiguous, and ask the user to resolve it manually.
   - On success, run `git push --force-with-lease`.

7. Print the PR URL, confirm the issue is linked, and summarise what code was changed and why.

$ARGUMENTS
