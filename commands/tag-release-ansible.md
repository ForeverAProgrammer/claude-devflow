Bump the version in an Ansible Galaxy collection or role, tag the release, and push.

> **Note:** For team repos or any repo with a CI/CD pipeline, automated versioning and publishing via a pipeline (e.g. GitHub Actions triggered on merge to main) is strongly preferred over running this command manually. Use this command for solo projects or when no pipeline is set up.

Steps:
1. Detect the project type:
   - If `galaxy.yml` exists, this is an Ansible **collection**.
   - If `meta/main.yml` exists but no `galaxy.yml`, this is an Ansible **role**.
   - If neither exists, tell the user this does not appear to be an Ansible Galaxy project and stop.
2. Read the current version from `galaxy.yml` (field: `version`) or `meta/main.yml` (field: `version` under `galaxy_info`).
3. Run `git tag --sort=-version:refname | head -1` to find the most recent tag. Run `git log <last-tag>..HEAD --oneline` to see commits since the last tag. If no tags exist, use all commits. If there are no new commits, tell the user there is nothing to release and stop.
4. Determine the version bump:
   - `major` if any commit contains `BREAKING CHANGE`
   - `minor` if any commit is type `feat`
   - `patch` for all other changes
5. Show the user the current version, the proposed new version, the bump reason, and the list of commits that will be included.
6. Ask the user to confirm before proceeding.
7. On confirmation, update the `version` field in `galaxy.yml` or `meta/main.yml` to the new version.
8. Stage the changed file: `git add galaxy.yml` or `git add meta/main.yml`.
9. If `CHANGELOG.md` exists, regenerate the `## Unreleased` section using the same rules as the `/changelog` command, rename it to `## <new-version>`, and stage `CHANGELOG.md` with `git add CHANGELOG.md`.
10. Commit the version bump: `git commit -m "chore(release): <new-version>"`.
11. Create and push the tag: `git tag <new-version> && git push && git push origin <new-version>`.
12. Confirm the tag was pushed and print the tag name and a reminder to import the new version on [Ansible Galaxy](https://galaxy.ansible.com) if not using an automated import webhook.

$ARGUMENTS
