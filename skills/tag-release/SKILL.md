---
description: Suggest and apply the next semver tag based on commits since the last tag.
disable-model-invocation: true
---

Suggest and apply the next semver tag based on commits since the last tag.

> **Note:** For team repos or any repo with a CI/CD pipeline, automated tagging via a pipeline (e.g. GitHub Actions triggered on merge to main) is strongly preferred over running this command manually. Use this command for solo projects or when no pipeline is set up.

Steps:
1. Run `git tag --sort=-version:refname | head -1` to find the most recent tag. If no tags exist, suggest `v0.1.0` as the first tag.
2. Run `git log <last-tag>..HEAD --oneline` to see commits since the last tag. If there are no commits since the last tag, tell the user there is nothing to release and stop.
3. Determine the next semver version:
   - Bump **major** if any commit contains `BREAKING CHANGE`
   - Bump **minor** if any commit is type `feat`
   - Bump **patch** for all other changes
4. Show the user the proposed tag, the version bump reason, and the list of commits that will be included.
5. Ask the user to confirm before proceeding.
6. On confirmation, run `git tag <version>` to create the tag, then `git push origin <version>` to push it.
7. Confirm the tag was pushed and print the tag name.

$ARGUMENTS
