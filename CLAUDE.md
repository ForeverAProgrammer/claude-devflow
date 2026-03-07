# Claude Code Guidelines

## Linting

After editing any `.md` file, run markdownlint:

```bash
markdownlint **/*.md
```

All violations must be resolved before finishing. Disabled rules are in [.markdownlint.json](.markdownlint.json) — do not add new disables without good reason.

## Commands

All slash commands live in `commands/`. Each file is a prompt template; `$ARGUMENTS` is replaced with user input at runtime. These are not documentation — they are instructions to Claude. Write them as direct imperatives.

Any time a command is added, removed, or its behaviour changes, you must:

1. Update the commands table in `README.md`
2. Update or add the usage example for that command in `README.md`
3. Check whether `install.sh` or `uninstall.sh` need changes (they currently handle all `.md` files automatically, so updates are only needed if the install logic itself changes)

## GitHub-specific commands

Commands that require the `gh` CLI must follow these rules:

- If a command uses `gh` but can fall back to plain git or other methods, add those fallbacks so the command works on any git host (GitLab, Bitbucket, self-hosted, etc.).
- If no reasonable fallback exists, the command must be named with a `-github` suffix (e.g. `create-pr-github`). No fallbacks are required for `-github` commands.
- Commands that do **not** end in `-github` must work without `gh` and without a GitHub remote.
