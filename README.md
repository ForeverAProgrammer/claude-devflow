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

## Commands

| Command | Description |
| --- | --- |
| `/tldr` | Shorten tech-heavy text into 2-4 plain-English sentences for a manager |
| `/standup` | Turn rough notes into a standup update |
| `/standup-git` | Pull yesterday's git commits and generate a standup update |
| `/pr` | Generate a PR title and description from a summary or diff |
| `/email` | Turn rough notes into a polished professional email |
| `/action-items` | Extract action items from meeting notes or a wall of text |
| `/commit` | Generate a conventional commit message from current branch changes |
| `/create-pr-github` | Create a GitHub PR from the current branch using `gh` |

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

**`/commit`** — no input needed, reads your git diff automatically:

```text
/commit
```

> `fix: resolve null pointer in checkout when cart is empty`

**`/create-pr-github`** — no input needed, reads your branch commits and opens a PR via `gh`:

```text
/create-pr-github
```

> **Add rate limiting to login endpoint**
>
> Adds Redis-backed rate limiting to the login endpoint, capping authentication attempts at 5 per IP per minute. Requests over the limit receive a 429 response.
>
> <https://github.com/your-org/your-repo/pull/42>

Pass extra `gh` flags as arguments if needed (e.g. `/create-pr-github --draft --base staging`).

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

## Uninstall

```bash
./uninstall.sh
```

Only removes symlinks created by `install.sh` — any commands you added manually are left untouched.

## Adding Commands

Add a new `.md` file to `commands/` and run `./install.sh` again. Use `$ARGUMENTS` as the placeholder for user input.
