---
description: Turn the current git changes into a well-formed Jira/Linear-style ticket with acceptance criteria.
---

Turn the current git changes into a well-formed Jira/Linear-style ticket with acceptance criteria.

Determine the base branch using the first method that succeeds:
- Run `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null` to get the default branch.
- Run `git remote show origin 2>/dev/null | grep 'HEAD branch'` to detect it from the remote config.
- Check which of `main`, `master`, or `develop` exist on the remote with `git branch -r`.
- If none work, ask the user to specify the base branch and stop until they do.

Run `git log --oneline <base>..HEAD` to list commits on this branch. Run `git diff <base>...HEAD` to see all changes introduced by the branch. If there are no commits ahead of the base branch, tell the user there is nothing to generate a ticket from and stop.

Using the diff and commit context, output the ticket in this format:

**Title**
A short, imperative-tense summary of what the change does (under 72 characters). Suitable for a ticket title or story card.

**Type**
Infer one of: Story, Bug, Task, Spike. Use Story for user-facing features, Bug for defects, Task for internal/non-feature work, Spike for research or investigation.

**Description**
2-4 sentences explaining what needs to be done and why, written as if the work has not yet been done. Describe the intent and value, not the implementation. If the diff reveals implementation details, use them only to infer the purpose.

**Acceptance Criteria**
A checklist of specific, testable conditions that must be true for the ticket to be considered done. Derive these from what the diff actually changes — each criterion should correspond to observable behaviour.

- [ ] ...
- [ ] ...

**Out of Scope** (optional)
List anything that might seem related but is explicitly not included. Omit this section if nothing needs clarifying.

Rules:
- Be specific — vague criteria like "it works correctly" are not acceptable
- Do not pad with obvious criteria like "code is reviewed" or "tests pass" unless testing behaviour is genuinely part of the scope
- If the diff is ambiguous about intent, make a reasonable assumption and note it in the Description
- Keep the total output focused and scannable — this is a ticket, not a design doc

$ARGUMENTS
