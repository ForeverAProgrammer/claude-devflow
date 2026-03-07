Rebase the current branch onto the target branch to resolve PR conflicts.

Steps:
1. Run `gh pr view --json baseRefName,headRefName,url 2>/dev/null` to get the PR's target branch. If no PR exists for this branch, use the repo default branch from `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`.
2. Run `git fetch origin` to ensure the latest remote changes are available.
3. Run `git rebase origin/<target-branch>`.
4. If the rebase succeeds with no conflicts, confirm to the user and skip to step 8.
5. If the rebase stops with conflicts:
   - Run `git diff --name-only --diff-filter=U` to list conflicting files.
   - For each conflicting file, read the file and show the conflict markers clearly.
   - Resolve each conflict by choosing the correct code based on context:
     - Prefer the incoming change (`theirs`) if it supersedes the current change.
     - Prefer the current change (`ours`) if the incoming change is unrelated.
     - Merge both sides if both changes are needed.
   - After editing each file, run `git add <file>` to mark it resolved.
6. Once all conflicts are resolved, run `git rebase --continue` to proceed. If more conflicts arise, repeat step 5.
7. If at any point a conflict is too ambiguous to resolve safely, run `git rebase --abort`, explain what was ambiguous, and ask the user to resolve it manually.
8. Run `git push --force-with-lease` to update the remote branch.
9. Report the result: confirm the branch is rebased, the PR conflicts are resolved, and print the PR URL.

$ARGUMENTS
