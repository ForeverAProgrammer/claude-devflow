# Changelog

## Unreleased (minor)

### Features

- Added Living Mode (`--mode living|strict`) to `/hld` and `/lld`, tagging genuinely uncertain design detail inline with `[PENDING SPIKE VALIDATION]` instead of inventing it (this commit)
- Added a `## Requirements` checklist to `/hld` and `/lld` output, with permanent sequential IDs and lifecycle rules for changed, descoped, and new requirements (this commit)
- Added `--amend` flag to `/hld` and `/lld` for targeted Requirements-section edits, cascading `Needs Review` flags to linked docs when a parent requirement changes or a new one needs LLD design (this commit)
- Added `/spike` command to validate a design's highest-risk technical assumption with a minimal isolated test script, resolving the corresponding `[PENDING SPIKE VALIDATION]` tag (this commit)
- Added `/add-spike` command to flag an existing or new HLD/LLD requirement as resting on an unvalidated assumption, marking it `Needs Spike` until `/spike` confirms it (this commit)
- Added `/resolve-open-questions` command to walk through a design doc's Open Questions interactively and fold real answers back into the doc (this commit)
- Added `/reconcile` command to reverse-update HLD/LLD docs from real code, writing an ADR when implementation intentionally diverged from the design (this commit)
- Updated `/implement-lld` to scope to unchecked Requirements by default (or specific rows via `--req`), roll up completed LLD sub-requirements to their parent HLD requirement, and auto-invoke `/reconcile` in Living mode (this commit)
- `/hld`, `/lld --amend`, `/implement-lld`, `/reconcile`, `/add-spike`, `/resolve-open-questions`, and `/spike` now infer their target HLD/LLD path from the conversation when one isn't given, confirming a single match or asking when more than one applies (this commit)

## v0.3.0 (2026-08-09)

### Features

- add create-mr-gitlab-git skill (#26)
- migrate commands to Claude plugin skills and rename to devflow (#24)
- add command to apply code changes from an LLD (#23)
- add /lld command and improve README (#21)
- add /hld command to generate High Level Design documents (#19)
- add end-to-end command to resolve GitHub issues (#18)
- add command to apply code changes from a GitHub issue (#17)
- add command to create issue-linked branches (#15)
- add command to create issue-linked branches (#14)
- add command to create GitHub issues from text input (#13)
- split into text-input and git-history variants (#11)
- add jira-ticket and jira-ticket-git commands (#10)
- add sync command to rebase branch onto default branch (#5)
- add command to rebase branch and resolve PR conflicts (#8)
- add code review command with structured severity-based feedback (#7)
- add tag-release, tag-release-npm, and tag-release-ansible commands (#6)
- use staged files for branch naming, fall back to all changes (#3)
- add command to auto-name and create branches from uncommitted changes (#2)
- update existing PR instead of failing if one exists
- improve commit and create-pr-github reliability

### Chores & Maintenance

- bump version to v0.2.0
- document github-specific command naming and add resolve-conflicts fallbacks (#9)
- add commit and create-pr-github commands, update gitignore
- initial commit

## v0.2.0 (2026-03-08)

### Features

- migrate commands to Claude plugin skills and rename to devflow (#24)
- add command to apply code changes from an LLD (#23)
- add /lld command and improve README (#21)
- add /hld command to generate High Level Design documents (#19)
- add end-to-end command to resolve GitHub issues (#18)
- add command to apply code changes from a GitHub issue (#17)
- add command to create issue-linked branches (#15)
- add command to create issue-linked branches (#14)
- add command to create GitHub issues from text input (#13)
- split into text-input and git-history variants (#11)
- add jira-ticket and jira-ticket-git commands (#10)
- add sync command to rebase branch onto default branch (#5)
- add command to rebase branch and resolve PR conflicts (#8)
- add code review command with structured severity-based feedback (#7)
- add tag-release, tag-release-npm, and tag-release-ansible commands (#6)
- use staged files for branch naming, fall back to all changes (#3)
- add command to auto-name and create branches from uncommitted changes (#2)
- update existing PR instead of failing if one exists
- improve commit and create-pr-github reliability

### Chores & Maintenance

- document github-specific command naming and add resolve-conflicts fallbacks (#9)
- add commit and create-pr-github commands, update gitignore
- initial commit

## v0.1.0

### Features

- Added `/implement-lld` command to read an LLD file and apply the code changes it describes, skipping stub sections and leaving commit to the user (this commit)
- Updated `/lld` command to support `--hld <path>` flag for generating an LLD from an existing HLD file, with automatic back-link in the Overview section (this commit)
- Updated `/lld` and `/hld` commands to output to a `design/` subfolder, creating it if it does not exist (this commit)
- Updated README to add table of contents, restructure Commands section into per-command subsections, and merge Usage section into Commands (this commit)
- Added `/lld` command to generate a structured Low Level Design document from a freeform description and write it to a markdown file (this commit)
- Added `/hld` command to generate a structured High Level Design document from a freeform description and write it to a markdown file (this commit)
- Added `/jira-ticket` command to turn a rough description into a Jira/Linear-style ticket with title, type, description, and acceptance criteria (this commit)
- Added `/jira-ticket-git` command to generate a ticket from all commits on the current branch compared to the default branch (this commit)
- Added `/sync` command to fetch and rebase the current branch onto the default branch, with automatic default branch detection and conflict reporting (e3682b3)
- Updated `/resolve-conflicts` to fall back to `git remote show origin` and common branch name detection when `gh` is not available, so it works on any git host (eb0c809)
- Added `/resolve-conflicts` command to rebase the current branch onto the PR target branch and resolve conflicts automatically (99dd4d5)
- Added `/review` command to give structured code feedback with severity levels, from uncommitted changes, a file, or pasted code (3e67667)
- Added `/tag-release-ansible` command to bump version in `galaxy.yml` or `meta/main.yml`, tag, and push for Ansible Galaxy collections and roles (740369d)
- Added `/tag-release-npm` command to bump `package.json` version via `npm version`, commit, tag, and push for npm projects (740369d)
- Added `/tag-release` command to suggest and apply the next semver tag based on commits since the last tag, with CI/CD guidance (740369d)
- Added `/changelog` command that creates and maintains `CHANGELOG.md` across all releases, with permanent tagged sections and an auto-updated Unreleased section (3309bf1)
- Added `/create-branch` command to automatically name and create branches from uncommitted changes, inferring type prefix and slug from the diff (18b23ad)
- Added `/create-issue-github` command to create a GitHub issue from a freeform description, with automatic label inference (b536165)
- Added `/decision` command to format a freeform description into a structured Architecture Decision Record with Context, Options, Decision, and Consequences sections (5a02c10)
- Added `/create-issue-branch-github` command to create a branch linked to a GitHub issue, with fallback for older gh versions that lack `gh issue develop` (5a02c10)
- Added `/fix-issue-github-auto` command to fully automate resolving a GitHub issue end-to-end: branch, apply changes, commit, open PR, and resolve conflicts (this commit)
- Added `/fix-issue-github` command to read a GitHub issue and apply the minimum code changes needed to resolve it (d4690f2)
- Added `/create-pr-github-git` command to push the current branch and open or update a GitHub PR, deriving title and description from git history (425cc56)
- Updated `/create-pr-github` to take a freeform text description as input instead of reading git history (this commit)
- Updated `/commit` to apply immediately without confirmation, stage all files when nothing is staged, and update `CHANGELOG.md` before committing if one exists (b2a4e0f)
- Updated `/commit` to include `CHANGELOG.md` in the same commit when regenerating it (00fcd6e)

### Documentation

- Added GitHub-specific command naming convention and fallback rules to `CLAUDE.md` (this commit)
- Updated README to note that `/commit` updates `CHANGELOG.md` automatically (00fcd6e)

### Chores & Maintenance

- Added `/commit` and `/create-pr-github` commands and excluded `settings.local.json` from git (2078b97)
- Initial project setup with install/uninstall scripts, base commands, and contributing guidelines (15648d2, 1918e14)
