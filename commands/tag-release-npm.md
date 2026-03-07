Bump the npm package version, tag the release, and push.

> **Note:** For team repos or any repo with a CI/CD pipeline, automated versioning and publishing via a pipeline (e.g. GitHub Actions triggered on merge to main) is strongly preferred over running this command manually. Use this command for solo projects or when no pipeline is set up.

Steps:
1. Run `ls package.json 2>/dev/null` to confirm this is an npm project. If not, tell the user and stop.
2. Run `git tag --sort=-version:refname | head -1` to find the most recent tag. Run `git log <last-tag>..HEAD --oneline` to see commits since the last tag. If no tags exist, use all commits. If there are no new commits, tell the user there is nothing to release and stop.
3. Determine the version bump:
   - `major` if any commit contains `BREAKING CHANGE`
   - `minor` if any commit is type `feat`
   - `patch` for all other changes
4. Show the user the current version (from `package.json`), the proposed new version, the bump reason, and the list of commits that will be included.
5. Ask the user to confirm before proceeding.
6. On confirmation, run `npm version <major|minor|patch> --no-git-tag-version` to update `package.json` and `package-lock.json` without creating a git tag yet.
7. Stage the version bump: `git add package.json package-lock.json`.
8. If `CHANGELOG.md` exists, regenerate the `## Unreleased` section using the same rules as the `/changelog` command, rename it to `## <new-version>`, and stage `CHANGELOG.md` with `git add CHANGELOG.md`.
9. Commit the version bump: `git commit -m "chore(release): <new-version>"`.
10. Create and push the tag: `git tag v<new-version> && git push && git push origin v<new-version>`.
11. Confirm the tag was pushed and print the tag name.

$ARGUMENTS
