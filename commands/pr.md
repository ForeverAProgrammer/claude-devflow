Generate a pull request title and description based on the summary or diff below.

Format:
**Title:** One line, imperative tense, under 72 characters (e.g. "Add rate limiting to login endpoint")

**Description:**
- What changed (2-4 sentences, plain English)
- Why it was needed (1-2 sentences)
- Any notable implementation details reviewers should know (bullet points, optional)
- Testing checklist: render as a markdown task list using `- [ ] step` format (optional)

Rules:
- No filler phrases like "This PR..." or "In this change..."
- Be specific — avoid vague words like "improve", "fix", "update" without saying what
- If given a raw diff, infer intent from the code changes

Summary or diff:
$ARGUMENTS
