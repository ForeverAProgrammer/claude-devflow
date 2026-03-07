---
description: Generate a standup update from yesterday's git commits. No input needed.
---

Generate a standup update from yesterday's git commits. Rules:
- 3 sections: "Yesterday", "Today", "Blockers" (omit Blockers if none)
- Each section is 1-3 bullet points max
- Plain English — no ticket numbers, branch names, or code references
- Focus on outcomes and progress, not process ("shipped the login fix" not "worked on auth module")
- Keep the whole thing under 10 lines
- Translate raw commit messages into human-readable accomplishments

First, run this command to get yesterday's commits:

```bash
git log --since="yesterday" --until="now" --oneline --author="$(git config user.email)"
```

Then use those commits to generate the standup.
