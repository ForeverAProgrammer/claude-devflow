---
description: Generate a standup update based on the notes below. Use when the user has rough notes about what they worked on and needs a formatted standup.
argument-hint: "[notes]"
---

Generate a standup update based on the notes or git log below. Rules:
- 3 sections: "Yesterday", "Today", "Blockers" (omit Blockers if none)
- Each section is 1-3 bullet points max
- Plain English — no ticket numbers, branch names, or code references unless the user included them
- Focus on outcomes and progress, not process ("shipped the login fix" not "worked on auth module")
- Keep the whole thing under 10 lines
- If the input looks like raw git commits, translate them into human-readable accomplishments

Notes:

$ARGUMENTS
