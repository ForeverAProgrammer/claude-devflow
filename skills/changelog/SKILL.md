---
description: Generate or update a changelog file that accumulates history across all releases.
disable-model-invocation: true
---

Generate or update a changelog file that accumulates history across all releases.

Rules:
- Tagged release sections are permanent — never modify them.
- Only the `## Unreleased` section at the top is updated on each run.
- If `CHANGELOG.md` does not exist, create it from scratch using all tags.

Steps:
1. Run `git tag --sort=-version:refname` to list all tags.
2. Check if `CHANGELOG.md` exists.

**If `CHANGELOG.md` does not exist**, generate the full changelog from scratch. For each tag (newest first), run `git log <previous-tag>..<tag> --oneline` to get commits for that release (for the oldest tag, use the first commit as the base). Group and format commits under a `## <tag>` heading. After all tagged sections, add an `## Unreleased` section for commits since the most recent tag; omit it if there are none. Write the full result to `CHANGELOG.md`.

**If `CHANGELOG.md` exists**, only update the `## Unreleased` section. Run `git tag --sort=-version:refname | head -1` to find the most recent tag, then `git log <last-tag>..HEAD --oneline` to get commits since it. Replace the existing `## Unreleased` section with a freshly generated one, or prepend a new one if absent. Leave all other sections untouched.

**Formatting rules for each section:**
- Group commits by type: **Features** (`feat`), **Bug Fixes** (`fix`), **Performance** (`perf`), **Documentation** (`docs`), **Chores & Maintenance** (`chore`, `refactor`, `style`, `test`, `ci`). Omit empty groups.
- Write each entry as a plain-English bullet point — not the raw commit message. Include the short commit hash at the end in parentheses.
- For the `## Unreleased` heading, append the suggested next semver bump in parentheses if the last tag is semver: bump patch for fixes only, minor for any feat, major for any `BREAKING CHANGE`.

$ARGUMENTS
