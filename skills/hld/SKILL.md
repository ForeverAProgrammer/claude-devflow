---
description: Generate a High Level Design (HLD) document from a freeform description and write it to a markdown file in the design/ directory. Use when the user wants to design a feature, system, or component at a high level.
argument-hint: "[description]"
---

Generate a High Level Design (HLD) document from a freeform description and write it to a markdown file.

$ARGUMENTS is the description of the feature, system, or component. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Steps:

1. Derive a filename slug from $ARGUMENTS: lowercase the description, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with `hld-` (e.g. `/hld user auth service` → `hld-user-auth-service.md`).

1. Generate the HLD document with the following sections. Populate every section from the description. If a section cannot be inferred, include it as a stub with a short prompt in italics (e.g. `_TODO: describe the external systems this component interacts with._`).

   Output structure:

   - `# HLD: <title derived from the description>`
   - `**Date:** <today's date in YYYY-MM-DD format>`
   - `**Status:** Draft`
   - `**Author:** <!-- your name -->`
   - `## Overview` — 2-4 sentences describing what this system or feature does and why it exists. Write as if the reader has no prior context.
   - `## Goals` — what this design must achieve, as bullet points.
   - `## Non-Goals` — what is explicitly out of scope. At least one item.
   - `## System Context` — where this component fits in the broader system. What calls it? What does it call? List known external dependencies.
   - `## Proposed Design` — the core design in plain English. Include key decisions and reasoning, how the main flow works end to end, and any important constraints or assumptions.
   - `## Components` — a two-column markdown table with Component and Responsibility columns.
   - `## Data Flow` — the flow of data through the system as a numbered list.
   - `## Alternatives Considered` — each alternative as a bullet with 1-2 sentences on the trade-off that led to it being rejected.
   - `## Open Questions` — unchecked checkboxes for questions that need answers before implementation begins.

1. Create a `design/` directory in the current working directory if it does not already exist. Write the document to `design/<slug>.md`.

1. Tell the user the file path (`design/<slug>.md`) and confirm it was written. List any sections that were left as stubs.

Rules:

- Be specific — do not write generic filler. Every sentence must be grounded in the description provided.
- The output must be ready to share or commit with no editing required, except for the stub sections.
- Do not add sections not listed above.

$ARGUMENTS
