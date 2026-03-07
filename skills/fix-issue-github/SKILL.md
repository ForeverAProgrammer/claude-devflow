---
description: Read a GitHub issue and apply code changes to resolve it.
argument-hint: "[issue-number]"
disable-model-invocation: true
---

Read a GitHub issue and apply code changes to resolve it.

$ARGUMENTS is the issue number. If $ARGUMENTS is empty, ask the user to provide an issue number and stop.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Run `gh issue view $ARGUMENTS --json title,body,comments,labels` to fetch the issue details. If the issue doesn't exist or is already closed, tell the user and stop.
3. Analyse the issue:
   - Read the title and body to understand what is being requested or what is broken.
   - Read any comments for clarifications, additional context, or decisions already made.
   - Identify whether this is a bug fix, feature addition, or documentation change.
4. Explore the codebase to find the relevant files:
   - Search for symbols, filenames, or patterns mentioned in the issue.
   - Read the relevant files to understand the current implementation before making any changes.
5. Apply the minimum code changes needed to resolve the issue:
   - Fix bugs by correcting the root cause, not just the symptom.
   - Add features by following the existing patterns and conventions in the codebase.
   - Do not refactor or change code unrelated to the issue.
   - Do not add comments, docstrings, or logging unless the issue specifically asks for it.
6. After making changes, summarise what was changed and why, referencing specific files and line numbers. Ask the user to review the changes before committing.
7. Do not commit or push — leave that to the user.

$ARGUMENTS
