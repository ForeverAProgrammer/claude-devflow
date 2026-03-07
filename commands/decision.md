Format a freeform description into a structured Architecture Decision Record (ADR).

$ARGUMENTS is the description of the decision. It may be a rough sentence, bullet points, or a paragraph. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Output the ADR in this format:

## Decision: (short imperative title)

**Date:** <today's date in YYYY-MM-DD format>

**Status:** Proposed

### Context

What situation, problem, or constraint prompted this decision? 2-4 sentences explaining the background. Write as if the reader has no prior context.

### Options Considered

A short list of alternatives that were evaluated, including the option that was chosen. For each option, give 1-2 sentences on its key trade-off.

- **Option A** — description and key trade-off
- **Option B** — description and key trade-off

### Decision

What was chosen and why. 2-4 sentences. Be specific about the reasoning — not just what was picked, but what made it the right choice over the alternatives.

### Consequences

What are the trade-offs, follow-on effects, or things to watch for as a result of this decision? Include both positive outcomes and drawbacks or risks accepted.

**Positive:**

- ...

**Drawbacks / risks:**

- ...

Rules:
- Be specific — generic consequences like "improves maintainability" are not acceptable without explaining why
- If the description doesn't mention alternatives, infer the most likely ones from context
- If the description is ambiguous about what was decided, make a reasonable assumption and state it clearly in the Decision section
- Output should be ready to paste into a wiki, PR description, or `.md` file with no editing required

$ARGUMENTS
