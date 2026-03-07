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
| `/decision` | Format a description into a structured Architecture Decision Record (ADR) |
| `/jira-ticket` | Turn a rough description into a well-formed Jira/Linear-style ticket with acceptance criteria |
| `/jira-ticket-git` | Generate a Jira/Linear-style ticket from the current git changes or last commit |
| `/changelog` | Generate a changelog from commits since the last git tag |
| `/commit` | Generate a conventional commit message from current branch changes |
| `/create-branch` | Create a branch named to match the current uncommitted changes |
| `/create-issue-branch-github` | Create a branch linked to a GitHub issue and check it out locally |
| `/create-issue-github` | Create a GitHub issue from a text description |
| `/create-pr-github` | Create a GitHub PR from the current branch using a text description |
| `/create-pr-github-git` | Create a GitHub PR from the current branch, deriving title and description from git history |
| `/fix-issue-github` | Read a GitHub issue and apply code changes to resolve it |
| `/fix-issue-github-auto` | Fully automate resolving a GitHub issue: branch, fix, commit, PR, and resolve conflicts |
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

**`/decision`** — paste a rough description of the decision to get a formatted ADR:

```text
/decision we chose PostgreSQL over MongoDB for the new reporting service because our data is relational and we needed strong consistency
```

> ## Decision: Use PostgreSQL for the reporting service
>
> **Date:** 2026-03-06
>
> **Status:** Proposed
>
> ### Context
>
> The new reporting service needs a primary datastore. The data being stored is relational in nature (reports reference users, projects, and time periods with foreign-key relationships), and the queries require aggregations across multiple entities with strong consistency guarantees.
>
> ### Options Considered
>
> - **PostgreSQL** — mature relational database with strong consistency, rich query language, and native support for aggregations; requires a defined schema upfront
> - **MongoDB** — flexible document store suited to evolving schemas; weaker consistency guarantees and less natural fit for relational queries
>
> ### Decision
>
> PostgreSQL was chosen because the reporting data model is inherently relational and the query patterns (cross-entity aggregations, joins) map directly to SQL. MongoDB's flexibility is not needed here, and its eventual consistency model would complicate report accuracy.
>
> ### Consequences
>
> **Positive:**
>
> - Strong consistency guarantees mean reports are always accurate at query time
> - SQL aggregations are expressive and well-supported by reporting tooling
>
> **Drawbacks / risks:**
>
> - Schema changes require migrations, which adds overhead when the data model evolves
> - Vertical scaling limits apply; sharding would be complex if write volume grows significantly

**`/jira-ticket`** — paste a rough description to get a structured ticket:

```text
/jira-ticket users should be able to reset their password via email
```

> **Title:** Add password reset via email
>
> **Type:** Story
>
> **Description:** Users currently have no self-service way to recover access when they forget their password. This ticket adds a password reset flow that sends a time-limited link to the user's registered email address.
>
> **Acceptance Criteria**
>
> - [ ] Requesting a reset for an unknown email returns the same response as a known email (no user enumeration)
> - [ ] Reset links expire after 1 hour and cannot be reused
> - [ ] Clicking a valid link allows the user to set a new password and logs them in
> - [ ] Clicking an expired or already-used link shows a clear error message
>
> **Out of Scope**
>
> - SMS-based reset
> - Admin-triggered password resets

**`/jira-ticket-git`** — no input needed, reads your current changes or last commit automatically:

```text
/jira-ticket-git
```

> **Title:** Add password reset via email
>
> **Type:** Story
>
> **Description:** Users have no self-service way to recover access when they forget their password. This adds a reset flow that sends a time-limited link to the user's registered email address.
>
> **Acceptance Criteria**
>
> - [ ] Requesting a reset for an unknown email returns the same response as a known one (no user enumeration)
> - [ ] Reset links expire after 1 hour and cannot be reused
> - [ ] A valid link lets the user set a new password and logs them in
> - [ ] An expired or already-used link shows a clear error

Uses staged changes if any are staged, falls back to all uncommitted changes, then falls back to the last commit.

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

**`/create-issue-branch-github`** — pass an issue number to create a linked branch and check it out:

```text
/create-issue-branch-github 12
```

> Created and switched to branch `12-add-decision-command`
>
> Branch is linked to issue #12. When you open a PR from this branch, GitHub will automatically show it in the issue's Development sidebar.

Branch name is generated from the issue number and title automatically. Pass `--name <branch>` to override (e.g. `/create-issue-branch-github 12 --name feature/decision-command`).

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/create-issue-github`** — pass a description and it opens a GitHub issue via `gh`:

```text
/create-issue-github login fails with a 500 error when the email contains a + sign
```

> **Fix login failure for email addresses containing + sign**
>
> Attempting to log in with an email address that contains a `+` character (e.g. `user+tag@example.com`) results in a 500 Internal Server Error. The email is likely not being URL-encoded before being passed to the auth service.
>
> **Steps to reproduce**
>
> 1. Navigate to the login page
> 2. Enter an email containing `+` and any valid password
> 3. Observe 500 error
>
> <https://github.com/your-org/your-repo/issues/7>

Automatically infers a label (`bug`, `enhancement`, or `documentation`) from the description when one clearly applies. Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/create-pr-github`** — pass a description and it opens a PR via `gh`:

```text
/create-pr-github Added Redis-backed rate limiting to the login endpoint, 5 attempts per IP per minute
```

> **Add rate limiting to login endpoint**
>
> Adds Redis-backed rate limiting to the login endpoint, capping authentication attempts at 5 per IP per minute. Requests over the limit receive a 429 response.
>
> <https://github.com/your-org/your-repo/pull/42>

Creates a new PR if one doesn't exist for the branch, or updates the title and description of the existing PR if one does. Pushes the branch to the remote automatically if it hasn't been pushed yet.

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/create-pr-github-git`** — no input needed, reads your branch commits and opens a PR via `gh`:

```text
/create-pr-github-git
```

> **Add rate limiting to login endpoint**
>
> Adds Redis-backed rate limiting to the login endpoint, capping authentication attempts at 5 per IP per minute. Requests over the limit receive a 429 response.
>
> <https://github.com/your-org/your-repo/pull/42>

Derives title and description from all commits on the branch relative to the default branch. Creates a new PR if one doesn't exist, or updates the existing PR. Pushes the branch automatically if it hasn't been pushed yet. Pass extra `gh` flags as arguments (e.g. `/create-pr-github-git --draft --base staging`).

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/fix-issue-github`** — pass an issue number to read and resolve it automatically:

```text
/fix-issue-github 42
```

Reads the issue title, body, and comments from GitHub, explores the relevant parts of the codebase, and applies the minimum changes needed to resolve it. Follows existing code conventions — no unrelated refactoring, extra comments, or unnecessary changes. Summarises what was changed and why before stopping, leaving commit and push to you.

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

**`/fix-issue-github-auto`** — pass an issue number to fully automate the end-to-end fix:

```text
/fix-issue-github-auto 42
```

Runs the full workflow in sequence: creates a branch linked to the issue, reads the issue and applies code changes, commits with a conventional commit message, opens a PR with `Closes #42` in the body, and checks for merge conflicts — rebasing and resolving them automatically if found. Requires no further input unless a conflict is too ambiguous to resolve safely.

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
