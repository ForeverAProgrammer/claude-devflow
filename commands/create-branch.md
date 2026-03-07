Create and checkout a git branch named to match the current uncommitted changes.

Steps:
1. Run `git diff --staged --stat` to check for staged changes.
   - If there are staged files, run `git diff --staged` to see what will be in the branch.
   - If nothing is staged, run `git diff HEAD --stat` and `git status --short` to see all uncommitted changes.
   - If there are no staged or uncommitted changes at all, tell the user and stop.
2. Infer the branch type and a short slug from the changes:
   - Use `feature/` for new functionality
   - Use `fix/` for bug fixes or error corrections
   - Use `chore/` for tooling, config, dependencies, or non-functional changes
   - Use `docs/` for documentation-only changes
   - Use `refactor/` for restructuring without behaviour change
   - Use `ci/` for CI/CD pipeline, workflow, or build configuration changes
3. Derive a short, lowercase, hyphen-separated slug (2-5 words) that describes what the changes do — not what files changed. Examples: `feature/rate-limit-login`, `fix/null-pointer-checkout`, `docs/add-contributing-guide`.
4. Run `git checkout -b <type>/<slug>` to create and switch to the branch.
5. Tell the user the branch name and confirm they are now on it.

$ARGUMENTS
