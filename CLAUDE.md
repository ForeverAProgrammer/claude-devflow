# Claude Code Guidelines

## Linting

After editing any `.md` file, run markdownlint:

```bash
markdownlint **/*.md
```

All violations must be resolved before finishing. Disabled rules are in [.markdownlint.json](.markdownlint.json) — do not add new disables without good reason.

## Skills

All skills live in `skills/<name>/SKILL.md`. Each `SKILL.md` has YAML frontmatter followed by the prompt body; `$ARGUMENTS` is replaced with user input at runtime. These are not documentation — they are instructions to Claude. Write them as direct imperatives.

Frontmatter fields to set on every skill:

- `description` — one sentence describing what the skill does and when to use it. Claude uses this to decide when to invoke the skill automatically.
- `disable-model-invocation: true` — add this for skills with side effects (git operations, file writes, GitHub API calls) that the user should trigger explicitly.
- `argument-hint` — add this for skills that take user input, to show a hint in autocomplete (e.g. `"[issue-number]"`).

Any time a skill is added, removed, or its behaviour changes, you must:

1. Update the commands table in `README.md`
2. Update or add the usage example for that skill in `README.md`
3. Check whether `install.sh` or `uninstall.sh` need changes (they currently handle all `skills/*/` directories automatically, so updates are only needed if the install logic itself changes)

## Releases

Versions are managed automatically by `.github/workflows/release.yml`. On every merge to `main`, the workflow:

1. Reads commits since the last tag and determines a semver bump (`fix:` → patch, `feat:` → minor, breaking → major).
2. Updates `version` in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.
3. Prepends a new versioned section to `CHANGELOG.md`.
4. Commits with `chore(release): bump version to vX.Y.Z` and pushes a tag.

Do not manually edit the `version` field in the plugin JSON files or add entries to the top of `CHANGELOG.md` — the workflow owns those.

## GitHub-specific skills

Skills that require the `gh` CLI must follow these rules:

- If a skill uses `gh` but can fall back to plain git or other methods, add those fallbacks so the skill works on any git host (GitLab, Bitbucket, self-hosted, etc.).
- If no reasonable fallback exists, the skill must be named with a `-github` suffix (e.g. `create-pr-github`). No fallbacks are required for `-github` skills.
- Skills that do **not** end in `-github` must work without `gh` and without a GitHub remote.
