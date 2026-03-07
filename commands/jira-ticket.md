Turn a description into a well-formed Jira/Linear-style ticket with acceptance criteria.

$ARGUMENTS is the description. It may be a rough sentence, bullet points, or a paragraph. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Output the ticket in this format:

**Title**
A short, imperative-tense summary (under 72 characters). Suitable for a ticket title or story card.

**Type**
Infer one of: Story, Bug, Task, Spike. Use Story for user-facing features, Bug for defects, Task for internal/non-feature work, Spike for research or investigation.

**Description**
2-4 sentences explaining what needs to be done and why. Write from the perspective of what the system or user needs — not how it will be implemented. Avoid implementation details unless they are constraints.

**Acceptance Criteria**
A checklist of specific, testable conditions that must be true for the ticket to be considered done. Each criterion should be independently verifiable. Write in "Given/When/Then" style or plain imperative — whichever fits naturally.

- [ ] ...
- [ ] ...

**Out of Scope** (optional)
List anything that might seem related but is explicitly not included in this ticket. Omit this section if nothing needs clarifying.

Rules:
- Be specific — vague criteria like "it works correctly" are not acceptable
- Do not pad with obvious criteria like "code is reviewed" or "tests pass" unless testing behaviour is genuinely part of the scope
- If the description is ambiguous, make a reasonable assumption and note it in the Description
- Keep the total output focused and scannable — this is a ticket, not a design doc
