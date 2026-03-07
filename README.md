# Claude Code Commands

A collection of slash commands for the [Claude Code](https://github.com/anthropics/claude-code) VS Code extension.

> **Platform support:** Linux and macOS only. The install script uses bash and symlinks — Windows paths and tooling are not compatible.

## Install

```bash
git clone https://github.com/ForeverAProgrammer/claude-commands
cd claude-commands
./install.sh
```

This symlinks all commands into `~/.claude/commands/`, making them available globally in every workspace. Because they're symlinks, pulling updates to this repo automatically updates your commands — no reinstall needed.

To get the latest commands:

```bash
cd claude-commands && git pull
```

## Commands

| Command | Description |
| --- | --- |
| `/tldr` | Shorten tech-heavy text into 2-4 plain-English sentences for a manager |
| `/standup` | Turn rough notes into a standup update |
| `/standup-git` | Pull yesterday's git commits and generate a standup update |
| `/pr` | Generate a PR title and description from a summary or diff |
| `/email` | Turn rough notes into a polished professional email |
| `/action-items` | Extract action items from meeting notes or a wall of text |
| `/changelog` | Generate a changelog from commits since the last git tag |
| `/commit` | Generate a conventional commit message from current branch changes |
| `/create-branch` | Create a branch named to match the current uncommitted changes |
| `/create-pr-github` | Create a GitHub PR from the current branch using `gh` |
| `/resolve-conflicts` | Rebase the current branch onto the PR target branch and resolve conflicts |
| `/review` | Review code or a diff and give structured feedback with severity levels |
| `/sync` | Fetch and rebase the current branch onto the default branch |

## Usage

**`/tldr`** — paste any wall of text to get a 2-4 sentence plain-English summary:

```text
/tldr We're migrating from a monolithic Rails app to microservices using
Kubernetes to improve scalability and reduce deploy risk...
```

> The team is breaking the current all-in-one app into smaller, independent services that can be updated and scaled separately. This reduces the risk of one change taking everything down, and lets different parts of the system grow on their own.

**`/standup`** — paste rough notes:

```text
/standup fixed the auth bug, reviewed Sara's PR, still blocked on API keys from infra
```

> **Yesterday**
>
> - Shipped the auth bug fix
> - Reviewed Sara's PR
>
> **Blockers**
>
> - Waiting on API keys from the infra team

**`/standup-git`** — no input needed, pulls yesterday's commits automatically:

```text
/standup-git
```

> **Yesterday**
>
> - Fixed a null pointer crash in the checkout flow
> - Added test coverage for the payment service
> - Upgraded a dependency to patch a security vulnerability
>
> **Today**
>
> - Continue work on current priorities

**`/pr`** — paste a description or diff of your changes:

```text
/pr Added rate limiting to the login endpoint using Redis. Limits to 5 attempts per minute per IP.
```

> **Add rate limiting to login endpoint**
>
> Protects the login endpoint from brute-force attacks by limiting requests to 5 attempts per minute per IP address, using Redis to track counts across instances.
>
> **Test plan**
>
> - [ ] Verify requests are blocked after 5 failed attempts
> - [ ] Confirm the counter resets after 1 minute
> - [ ] Test that successful logins are not affected

**`/email`** — paste bullet points or rough notes:

```text
/email need to tell the team the deploy is delayed, infra issue, new date is Thursday, sorry for short notice
```

> Hi team,
>
> Heads up — today's deploy is delayed due to an infrastructure issue. The new target date is Thursday.
>
> Sorry for the short notice. I'll send another update if anything changes.

**`/action-items`** — paste meeting notes or any text with tasks buried in it:

```text
/action-items Sara will follow up with the infra team about the API keys.
John said he'd update the onboarding doc by end of week. We all need to
review the Q3 roadmap before Friday's planning session.
```

> - [ ] @sara — follow up with infra team on API keys
> - [ ] @john — update the onboarding doc with new flow
> - [ ] @all — review the Q3 roadmap before Friday

**`/changelog`** — no input needed, reads commits since the last tag automatically:

```text
/changelog
```

> ## v1.1.0
>
> **Features**
>
> - Added `/create-branch` command to auto-name branches from uncommitted changes (a3f9c1)
>
> **Bug Fixes**
>
> - Resolved null pointer crash in checkout when cart is empty (b2e4d8)
>
> **Chores & Maintenance**
>
> - Updated `.gitignore` to exclude `settings.local.json` (c1a2b3)

Automatically suggests the next semver version based on commit types. Bumps patch for fixes only, minor for any new feature, major if a breaking change is detected.

**`/commit`** — no input needed, commits immediately without asking for confirmation:

```text
/commit
```

> `fix: resolve null pointer in checkout when cart is empty`

If there are staged changes, only those are committed. If nothing is staged, all modified and untracked files are staged and committed automatically. If a `CHANGELOG.md` exists in the repo root, it is updated and included in the same commit automatically.

**`/create-branch`** — no input needed, reads your uncommitted changes and creates a branch:

```text
/create-branch
```

> Created and switched to branch `feature/rate-limit-login`

Branch type is inferred automatically: `feature/`, `fix/`, `chore/`, `docs/`, `refactor/`, or `ci/`.

**`/create-pr-github`** — no input needed, reads your branch commits and opens a PR via `gh`:

```text
/create-pr-github
```

> **Add rate limiting to login endpoint**
>
> Adds Redis-backed rate limiting to the login endpoint, capping authentication attempts at 5 per IP per minute. Requests over the limit receive a 429 response.
>
> <https://github.com/your-org/your-repo/pull/42>

Creates a new PR if one doesn't exist for the branch, or updates the title and description of the existing PR if one does. Pushes the branch to the remote automatically if it hasn't been pushed yet. Pass extra `gh` flags as arguments if needed (e.g. `/create-pr-github --draft --base staging`).

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/resolve-conflicts`** — no input needed, detects the PR target branch and rebases automatically:

```text
/resolve-conflicts
```

Fetches the latest remote changes, rebases the current branch onto the PR's target branch, and resolves conflicts by reading context from both sides. If a conflict is too ambiguous to resolve safely, it aborts and explains what needs manual attention. Force-pushes the rebased branch on success.

**`/review`** — no input reviews your uncommitted changes; pass a file path or paste code directly:

```text
/review
```

```text
/review src/auth/login.js
```

> **Summary:** Adds rate limiting middleware to the login endpoint using Redis.
>
> **Issues**
>
> - [ ] [Security] User IP taken from `req.headers['x-forwarded-for']` without validation — can be spoofed; use a trusted proxy header or `req.socket.remoteAddress`
> - [ ] [Bug] Redis client errors are silently swallowed — a Redis outage will fail open and bypass rate limiting entirely
>
> **Suggestions**
>
> - Extract the Redis key format (`ratelimit:${ip}`) into a named constant so it's easy to change
>
> **Looks good**
>
> - TTL is set atomically with the counter increment — no race condition

**`/sync`** — no input needed, fetches and rebases onto the default branch:

```text
/sync
```

> Branch is up to date with `origin/main`.

The default branch is detected automatically via `gh`. If that fails, it checks for `main` or `master` on the remote — if both exist, it asks which to use. If there are conflicts, it lists the affected files and stops — it does not attempt to resolve them automatically.

## Uninstall

```bash
./uninstall.sh
```

Only removes symlinks created by `install.sh` — any commands you added manually are left untouched.

## Adding Commands

Add a new `.md` file to `commands/` and run `./install.sh` again. Use `$ARGUMENTS` as the placeholder for user input.
