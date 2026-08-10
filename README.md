# Claude Devflow

A collection of slash commands for the [Claude Code](https://github.com/anthropics/claude-code) VS Code extension.

## Contents

- [Install](#install)
- [Commands](#commands)
- [Uninstall](#uninstall)
- [Adding Commands](#adding-commands)

## Install

Clone the repo, then run these two commands from inside it (works on Windows, macOS, and Linux):

```bash
git clone https://github.com/ForeverAProgrammer/claude-devflow
cd claude-devflow
claude plugin marketplace add ./
claude plugin install devflow@devflow
```

Skills are available as `/devflow:<skill-name>` (e.g. `/devflow:commit`).

To update to the latest skills:

```bash
cd claude-devflow && git pull
claude plugin marketplace update devflow
```

### Try without installing

To test the plugin in a single session without installing:

```bash
claude --plugin-dir ./claude-devflow
```

## Commands

### `/tldr`

Shorten tech-heavy text into 2-4 plain-English sentences for a manager.

```text
/tldr We're migrating from a monolithic Rails app to microservices using
Kubernetes to improve scalability and reduce deploy risk...
```

> The team is breaking the current all-in-one app into smaller, independent services that can be updated and scaled separately. This reduces the risk of one change taking everything down, and lets different parts of the system grow on their own.

### `/standup`

Turn rough notes into a standup update.

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

### `/standup-git`

Pull yesterday's git commits and generate a standup update. No input needed.

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

### `/pr`

Generate a PR title and description from a summary or diff.

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

### `/email`

Turn rough notes into a polished professional email.

```text
/email need to tell the team the deploy is delayed, infra issue, new date is Thursday, sorry for short notice
```

> Hi team,
>
> Heads up — today's deploy is delayed due to an infrastructure issue. The new target date is Thursday.
>
> Sorry for the short notice. I'll send another update if anything changes.

### `/action-items`

Extract action items from meeting notes or a wall of text.

```text
/action-items Sara will follow up with the infra team about the API keys.
John said he'd update the onboarding doc by end of week. We all need to
review the Q3 roadmap before Friday's planning session.
```

> - [ ] @sara — follow up with infra team on API keys
> - [ ] @john — update the onboarding doc with new flow
> - [ ] @all — review the Q3 roadmap before Friday

### `/decision`

Format a description into a structured Architecture Decision Record (ADR).

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

`/hld`, `/lld`, `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, and `/reconcile` all take an HLD or LLD path, but the path is optional everywhere it's used — if you're working through a design in one continuous conversation (the common case: `/hld`, then `/lld`, then `/spike`/`/add-spike`/`/resolve-open-questions` as questions come up, then `/implement-lld`, then `/reconcile`), each command looks back through the conversation for a path already established rather than making you repeat it every time. If exactly one applicable doc is found, it's confirmed with you before proceeding rather than assumed silently; if more than one could apply, you're asked which; if none can be found, you're asked for a path as before. Passing a path explicitly always works and skips inference entirely.

### `/hld`

Generate a High Level Design document from a freeform description and write it to `design/<slug>.md`. Both `/hld` and `/lld` output a `## Requirements` checklist and support two doc modes: **Strict** (default — fully populated, no provisional tagging) and **Living** (high-level sections stay fully populated, but genuinely uncertain low-level detail is tagged `[PENDING SPIKE VALIDATION]` instead of invented). Pass `--mode living|strict` to set it.

```text
/hld user authentication service with JWT tokens and refresh token rotation
```

> Written to `design/hld-user-authentication-service-jwt.md`
>
> Sections populated: Overview, Goals, Non-Goals, System Context, Proposed Design, Components, Data Flow, Alternatives Considered, Requirements
>
> Stubs (fill in before sharing): Open Questions

The filename is derived from the description slug automatically. Sections that cannot be inferred from the description are included as stubs with a prompt to fill in. Running `/hld` again against a slug that already exists edits the file in place — existing `REQ-*` rows, `Mode`, `Last Reconciled`, and `Last Amended` are preserved rather than overwritten.

Pass `--amend <path> <change description>` to make a targeted edit to just the `## Requirements` section of an existing HLD — no other section is touched. Changed or descoped requirements are struck through and kept (never deleted), with a successor row or reason noted. Amending also cascades into any linked LLDs (Requirements section only, in each): a changed or descoped requirement flags its existing referencing rows `Needs Review`; a brand-new requirement gets a new stub row appended (since no LLD row exists to flag yet), also marked `Needs Review` — it stays out of `/implement-lld`'s reach until you run `/lld` against it to fill in the actual design, which clears the flag.

```text
/hld --amend design/hld-user-authentication-service-jwt.md drop biometric login, it's out of scope for v1
```

### `/lld`

Generate a Low Level Design document from a freeform description and write it to `design/<slug>.md`. Pass `--hld <path>` to generate from an existing HLD file — the LLD inherits the HLD's `Mode` unless `--mode` overrides it.

```text
/lld user authentication service with JWT tokens and refresh token rotation
```

```text
/lld --hld design/hld-user-auth-service.md
```

> Written to `design/lld-user-authentication-service-jwt.md`
>
> Sections populated: Overview, Scope, API / Interface Design, Data Models, Component Interactions, Error Handling, Edge Cases, Testing Considerations, Requirements
>
> Stubs (fill in before sharing): Open Questions

Pass `--hld <path>` to generate the LLD from an existing HLD file. The HLD content is used as the primary source of context, with the Overview section linking back to it. The filename is derived from the description or HLD title slug automatically. Sections that cannot be inferred are included as stubs with a prompt to fill in. Requirements reference their parent HLD requirement with a dotted sub-ID (`REQ-1.1`, `REQ-1.2` for HLD `REQ-1`). As with `/hld`, running it again against an existing slug edits in place, and `--amend <path> <change description>` targets just the Requirements section. If a run supplies the real design for a row currently marked `Needs Review` (whether from an `/hld --amend` cascade or a parent-change flag), that annotation is cleared once the design is filled in.

### `/resolve-open-questions`

Walk through an HLD or LLD's `## Open Questions`, asking you for a real answer to each one, then fold the answers back into the doc.

```text
/resolve-open-questions design/hld-user-auth-service.md
```

For every unchecked question, proposes 2-4 concrete answer options grounded in the doc's actual content (never generic placeholders) and waits for your answer. It never guesses or defaults on your behalf. Once answered: checks off the question with a resolution note (the original question text is never deleted), and either updates `## Requirements` (new row, or a struck-through row with a successor, using the same lifecycle rules as `--amend`) if the answer creates a new obligation, or updates the relevant design section directly if it's just a clarification. If your answer itself is uncertain, the resulting requirement is marked `Needs Spike` with a `[PENDING SPIKE VALIDATION]` tag instead of being written as settled — same convention as `/add-spike`. Run against an HLD, cascades any resulting Requirements changes to linked LLDs exactly like `/hld --amend` does.

### `/implement-lld`

Read a Low Level Design document and apply the code changes it describes to the codebase.

```text
/implement-lld design/lld-user-auth-service.md
```

```text
/implement-lld design/lld-user-auth-service.md --req REQ-3.1
```

Reads the LLD's Mode, Scope, API / Interface Design, Data Models, Component Interactions, Error Handling, Edge Cases, and Requirements sections and applies the code changes needed to implement them, checking off each Requirements row as it's completed. By default it scopes to every unchecked (`- [ ]`) row and leaves already-completed ones untouched, so re-running it after a doc changes only implements the delta — pass `--req <ID>[,<ID>...]` to instead target specific rows explicitly (this also lets you re-implement an already-checked row on purpose). Rows marked `Needs Review` or `Needs Spike` are always excluded from scope, `--req` or not, and listed in the summary. Follows existing code conventions — no unrelated refactoring, extra comments, or unnecessary changes. Stub sections (marked `_TODO:_`) are skipped and listed in the summary. A missing `Mode` field behaves as `Strict` (unchanged from before this field existed): implement exactly as specified, no deviation. In **Living** mode, deviations are allowed where the code reveals a better approach (left for `/reconcile` to capture rather than edited into the LLD mid-implementation) and `/reconcile` is invoked automatically as a final step so docs and code land in sync. Checking off an LLD sub-requirement (`REQ-1.1`) also rolls up to check off its parent in the linked HLD (`REQ-1`) once every current row referencing that parent is complete — no separate HLD pass needed. Summarises what was changed and why before stopping, leaving commit and push to you.

### `/add-spike`

Flag an existing HLD or LLD requirement (or add a new one) as resting on an unvalidated technical assumption, so it can't be quietly implemented or marked done until a spike confirms it.

```text
/add-spike design/hld-user-auth-service.md REQ-4 not sure the token store can actually sustain the expected refresh rate
```

```text
/add-spike design/hld-user-auth-service.md add a requirement that revoked tokens propagate to all edge nodes within 5 seconds, but I'm not sure that's achievable with the current cache
```

Targets an existing `REQ-*` ID (with a reason) or, given a freeform description instead, adds a brand-new requirement already flagged. Inserts a `[PENDING SPIKE VALIDATION]` tag into the relevant design section (`Proposed Design` for an HLD, `API / Interface Design` or `Data Models` for an LLD) and annotates the requirement row `_(Needs Spike — reason, flagged <date>)_`. Requires the doc to already be in Living mode, stops and tells you to switch first rather than flipping the mode as a side effect. When run against an HLD, cascades the same `Needs Spike` annotation onto any existing LLD rows that reference the flagged requirement. A `Needs Spike` row is excluded from `/implement-lld`'s scope and `/reconcile`'s checkoff exactly like `Needs Review`, until `/spike` validates the assumption and clears it. Suggests running `/spike --hld <path>` or `/spike --lld <path>` next.

### `/spike`

Validate the single highest-risk low-level technical assumption in a design before locking it in, by writing and running a minimal isolated test script.

```text
/spike --lld design/lld-user-auth-service.md
```

```text
/spike --hld design/hld-user-auth-service.md
```

```text
/spike can we refresh a JWT while the original request is still in flight without a race condition
```

Scans the given doc for `[PENDING SPIKE VALIDATION]` tags when `--lld <path>` or `--hld <path>` is given — use `--hld` when a requirement was flagged (e.g. via `/add-spike`) before any LLD exists yet or takes the assumption directly as freeform text. Writes a minimal test script to `spikes/<slug>.<ext>`, runs it, and summarizes what was found. If a design doc was linked, resolves the corresponding tag to `[VALIDATED]` or `[REVISED: <what changed>]`, backlinked to the script, and clears any `Needs Spike` annotation that pointed at that tag. Never checks off `## Requirements` rows — that's `/reconcile`'s and `/implement-lld`'s job.

### `/reconcile`

Eliminate architectural drift by reading passing spike or feature code and reverse-updating an HLD/LLD doc to match reality.

```text
/reconcile design/lld-user-auth-service.md
```

Diffs the codebase since the doc's `Last Reconciled` sha, plus recent files under `spikes/`, and compares real exported signatures and types against the doc's API / Interface Design and Data Models sections. If `Last Reconciled` is unset, the diff base isn't automatically the default branch — it's whichever branch this one was actually forked from (found by scoring branches on commits-ahead-of-merge-base), so a branch cut from `release/1.0` diffs against `release/1.0`, not `main`. Only falls back to the default branch if you're currently on it yourself. If the code simply caught up to the design, the doc is quietly updated. If the code intentionally diverged from the design, the doc is updated **and** an Architecture Decision Record is written to `design/adr/` capturing why. Checks off any `## Requirements` row now satisfied by the code, skips rows marked `Needs Review` or `Needs Spike`, and stamps `Last Reconciled` with today's date and the current short SHA. When run against an LLD, also rolls up to check off a parent HLD requirement once every current LLD row referencing it is complete.

### `/jira-ticket`

Turn a rough description into a well-formed Jira/Linear-style ticket with acceptance criteria.

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

### `/jira-ticket-git`

Generate a Jira/Linear-style ticket from the current git changes or last commit. No input needed.

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

### `/changelog`

Generate a changelog from commits since the last git tag. No input needed.

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

### `/commit`

Generate a conventional commit message and apply it immediately. No input needed.

```text
/commit
```

> `fix: resolve null pointer in checkout when cart is empty`

If there are staged changes, only those are committed. If nothing is staged, all modified and untracked files are staged and committed automatically. If a `CHANGELOG.md` exists in the repo root, it is updated and included in the same commit automatically.

### `/create-branch`

Create a branch named to match the current uncommitted changes. No input needed.

```text
/create-branch
```

> Created and switched to branch `feature/rate-limit-login`

Branch type is inferred automatically: `feature/`, `fix/`, `chore/`, `docs/`, `refactor/`, or `ci/`.

### `/create-issue-branch-github`

Create a branch linked to a GitHub issue and check it out locally.

```text
/create-issue-branch-github 12
```

> Created and switched to branch `12-add-decision-command`
>
> Branch is linked to issue #12. When you open a PR from this branch, GitHub will automatically show it in the issue's Development sidebar.

Branch name is generated from the issue number and title automatically. Pass `--name <branch>` to override (e.g. `/create-issue-branch-github 12 --name feature/decision-command`).

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

### `/create-issue-github`

Create a GitHub issue from a text description.

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

### `/create-pr-github`

Create a GitHub PR from the current branch using a text description.

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

### `/create-pr-github-git`

Create a GitHub PR from the current branch, deriving title and description from git history. No input needed.

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

### `/create-mr-gitlab-git`

Create a GitLab MR from the current branch, deriving title and description from git history. No input needed.

```text
/create-mr-gitlab-git
```

> **Add rate limiting to login endpoint**
>
> Adds Redis-backed rate limiting to the login endpoint, capping authentication attempts at 5 per IP per minute. Requests over the limit receive a 429 response.
>
> <https://gitlab.com/your-org/your-repo/-/merge_requests/42>

Derives title and description from all commits on the branch relative to the branch it was created from, not the repo's default branch — so a feature branch off a release branch gets diffed against that release branch. If multiple branches tie for closest ancestor (e.g. several release branches diverged at the same point), you'll be asked which one to target. Pass `--target-branch <name>` to skip detection and target a specific branch directly. If the repo has a GitLab MR description template (`.gitlab/merge_request_templates/Default.md` or another file in that directory), the description follows its structure instead of the default freeform format. Creates a new MR if one doesn't exist, or updates the existing MR. Pushes the branch automatically if it hasn't been pushed yet. Pass extra `glab` flags as arguments (e.g. `/create-mr-gitlab-git --draft --target-branch staging`).

Requires the [GitLab CLI](https://gitlab.com/gitlab-org/cli) (`glab`) to be installed and authenticated.

### `/fix-issue-github`

Read a GitHub issue and apply code changes to resolve it.

```text
/fix-issue-github 42
```

Reads the issue title, body, and comments from GitHub, explores the relevant parts of the codebase, and applies the minimum changes needed to resolve it. Follows existing code conventions — no unrelated refactoring, extra comments, or unnecessary changes. Summarises what was changed and why before stopping, leaving commit and push to you.

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

### `/fix-issue-github-auto`

Fully automate resolving a GitHub issue: branch, fix, commit, PR, and resolve conflicts.

```text
/fix-issue-github-auto 42
```

Runs the full workflow in sequence: creates a branch linked to the issue, reads the issue and applies code changes, commits with a conventional commit message, opens a PR with `Closes #42` in the body, and checks for merge conflicts — rebasing and resolving them automatically if found. Requires no further input unless a conflict is too ambiguous to resolve safely.

Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

### `/resolve-conflicts`

Rebase the current branch onto the PR target branch and resolve conflicts. No input needed.

```text
/resolve-conflicts
```

Fetches the latest remote changes, rebases the current branch onto the PR's target branch, and resolves conflicts by reading context from both sides. If a conflict is too ambiguous to resolve safely, it aborts and explains what needs manual attention. Force-pushes the rebased branch on success.

### `/review`

Review code or a diff and give structured feedback with severity levels.

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

No input reviews uncommitted changes; pass a file path or paste code directly.

### `/sync`

Fetch and rebase the current branch onto the default branch. No input needed.

```text
/sync
```

> Branch is up to date with `origin/main`.

The default branch is detected automatically via `gh`. If that fails, it checks for `main` or `master` on the remote — if both exist, it asks which to use. If there are conflicts, it lists the affected files and stops — it does not attempt to resolve them automatically.

## Uninstall

```bash
claude plugin uninstall devflow@devflow
claude plugin marketplace remove devflow
```

## Adding Commands

Create a new directory under `skills/` and add a `SKILL.md` file. No reinstall needed — Claude picks up new skills automatically after a `/reload-plugins`.

Every `SKILL.md` needs YAML frontmatter followed by the prompt body:

```markdown
---
description: What this skill does and when to use it.
argument-hint: "[description]"
disable-model-invocation: true
---

Your skill instructions here. Use $ARGUMENTS as the placeholder for user input.
```

Set `disable-model-invocation: true` for skills with side effects (git operations, file writes, API calls).
