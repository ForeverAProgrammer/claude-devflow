---
description: Create a GitHub issue from a description provided by the user.
argument-hint: "[description]"
disable-model-invocation: true
---

Create a GitHub issue from a description provided by the user.

$ARGUMENTS is the issue description — a sentence, bullet points, or a paragraph explaining the problem or feature request. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Steps:
1. Check that `gh` is installed and authenticated by running `gh auth status`. If not, tell the user and stop.
2. Derive an issue title (imperative tense, under 72 chars) and a polished body from $ARGUMENTS:
   - What the problem or request is (2-4 sentences, plain English)
   - Why it matters or what the expected behaviour should be
   - Steps to reproduce if it sounds like a bug
   - No filler like "This issue..." or vague words without specifics
3. Infer a label from the description if one of these clearly applies: `bug`, `enhancement`, `documentation`. Omit if unclear.
4. Run `gh issue create --title "<title>" --body "<body>"`, appending `--label <label>` if one was inferred. Append any user-provided flags from $ARGUMENTS.
5. Print the issue URL.
