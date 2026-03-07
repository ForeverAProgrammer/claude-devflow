Review code and provide structured feedback.

Determine what to review:
- If $ARGUMENTS is a file path, read that file.
- If $ARGUMENTS is a diff or code snippet, review it directly.
- If $ARGUMENTS is empty, run `git diff HEAD` to get current uncommitted changes. If there are no uncommitted changes, run `git diff HEAD~1` to review the last commit.

Review the code and output the following sections. Omit any section that has nothing to report.

**## Summary**
One sentence describing what the code does.

**## Issues**
Bugs, security vulnerabilities, and correctness problems. Each item must:
- Be prefixed with a severity: `[Critical]`, `[Bug]`, or `[Security]`
- Reference the specific line or function where possible
- Explain why it's a problem and what the fix should be
- Be formatted as a checkbox: `- [ ] [Severity] Description`

**## Suggestions**
Non-blocking improvements to readability, maintainability, or performance. Keep this list short — only include suggestions that would meaningfully improve the code. Skip anything a linter or formatter would catch automatically.

**## Looks good**
Briefly note anything done particularly well — good test coverage, clean error handling, clear naming, etc. Keep to 1-3 bullets max.

Rules:
- Be direct and specific — no filler phrases like "you might want to consider"
- Do not suggest changes just to show thoroughness — if the code is fine, say so
- Do not comment on style that a linter handles (indentation, semicolons, etc.)
- If there are no issues, say so clearly rather than manufacturing feedback

$ARGUMENTS
