# Changelog

## Unreleased (v0.1.0)

### Features

- Added `/review` command to give structured code feedback with severity levels, from uncommitted changes, a file, or pasted code (this commit)
- Added `/tag-release-ansible` command to bump version in `galaxy.yml` or `meta/main.yml`, tag, and push for Ansible Galaxy collections and roles (740369d)
- Added `/tag-release-npm` command to bump `package.json` version via `npm version`, commit, tag, and push for npm projects (740369d)
- Added `/tag-release` command to suggest and apply the next semver tag based on commits since the last tag, with CI/CD guidance (740369d)
- Added `/changelog` command that creates and maintains `CHANGELOG.md` across all releases, with permanent tagged sections and an auto-updated Unreleased section (3309bf1)
- Added `/create-branch` command to automatically name and create branches from uncommitted changes, inferring type prefix and slug from the diff (18b23ad)
- Added `/create-pr-github` command to push the current branch and open or update a GitHub PR via `gh` (76e6eb3)
- Updated `/commit` to apply immediately without confirmation, stage all files when nothing is staged, and update `CHANGELOG.md` before committing if one exists (b2a4e0f)
- Updated `/commit` to include `CHANGELOG.md` in the same commit when regenerating it (00fcd6e)

### Documentation

- Updated README to note that `/commit` updates `CHANGELOG.md` automatically (00fcd6e)

### Chores & Maintenance

- Added `/commit` and `/create-pr-github` commands and excluded `settings.local.json` from git (2078b97)
- Initial project setup with install/uninstall scripts, base commands, and contributing guidelines (15648d2, 1918e14)
