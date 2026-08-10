---
description: Generate a High Level Design (HLD) document from a freeform description and write it to a markdown file in the design/ directory. Use when the user wants to design a feature, system, or component at a high level.
argument-hint: "[description] [--mode living|strict] [--amend <path> <change description>]"
---

Generate a High Level Design (HLD) document from a freeform description and write it to a markdown file.

$ARGUMENTS may include:

- A freeform description of the feature, system, or component.
- `--mode living|strict` — sets the doc's `Mode`. Defaults to `strict` if omitted (no behavior change from before this flag existed).
- `--amend [path] <change description>` — targeted edit to an existing doc's `## Requirements` section only. `<path>` may be omitted if it's already clear from this conversation — see the Amend Mode steps below, which are skipped entirely when this flag isn't present.

If $ARGUMENTS is empty, ask the user to provide a description and stop.

### Normal generation

1. Derive a filename slug from $ARGUMENTS: lowercase the description, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with `hld-` (e.g. `/hld user auth service` → `hld-user-auth-service.md`).

1. Check whether `design/<slug>.md` already exists.

   - **If it exists**, this run is an edit, not a fresh overwrite:
     - Preserve existing `REQ-*` rows and their checked/unchecked state exactly.
     - Preserve the existing `Mode`, `Last Reconciled`, and `Last Amended` values unless `--mode` was explicitly passed on this run.
     - Only add new requirements (next sequential `REQ-N`) or update non-Requirements sections as directed by the new input — do not regenerate sections that aren't affected by it.
   - **If it does not exist**, generate fresh per the Output structure below.

1. Generate or update the HLD document with the following sections. Populate every section from the description. If a section cannot be inferred, include it as a stub with a short prompt in italics (e.g. `_TODO: describe the external systems this component interacts with._`).

   Output structure:

   - `# HLD: <title derived from the description>`
   - `**Date:** <today's date in YYYY-MM-DD format>`
   - `**Status:** Draft`
   - `**Author:** <!-- your name -->`
   - `**Mode:** Living | Strict` — from `--mode`, or `Strict` if not passed.
   - `**Last Reconciled:** <date> @ <short-sha>` — leave blank until the first `/reconcile` run.
   - `**Last Amended:** <date>` — leave blank until the first `--amend` run.
   - `## Overview` — 2-4 sentences describing what this system or feature does and why it exists. Write as if the reader has no prior context.
   - `## Goals` — what this design must achieve, as bullet points.
   - `## Non-Goals` — what is explicitly out of scope. At least one item.
   - `## System Context` — where this component fits in the broader system. What calls it? What does it call? List known external dependencies.
   - `## Proposed Design` — the core design in plain English. Include key decisions and reasoning, how the main flow works end to end, and any important constraints or assumptions. In Living mode, tag genuinely uncertain low-level detail inline with `[PENDING SPIKE VALIDATION]` instead of inventing content — high-level system boundaries, goals, and data contracts must still be fully populated.
   - `## Components` — a two-column markdown table with Component and Responsibility columns.
   - `## Data Flow` — the flow of data through the system as a numbered list.
   - `## Alternatives Considered` — each alternative as a bullet with 1-2 sentences on the trade-off that led to it being rejected.
   - `## Requirements` — one row per requirement:
     `- [ ] **REQ-1** — <requirement statement> _(optional: Blocked/In Progress/Needs Review/Needs Spike — reason)_`
     IDs are assigned sequentially and are permanent — never renumber or reuse an ID, even after a row is struck through. New requirements always get the next unused sequential ID.
   - `## Open Questions` — unchecked checkboxes for questions that need answers before implementation begins.

1. Create a `design/` directory in the current working directory if it does not already exist. Write the document to `design/<slug>.md`.

1. Tell the user the file path (`design/<slug>.md`) and confirm it was written. List any sections that were left as stubs. If `## Open Questions` has any unchecked items, mention that `/resolve-open-questions design/<slug>.md` can walk through them.

### Amend mode (`--amend [path] <change description>`)

1. Determine `<path>`:
   - If a path is present after `--amend`, use it.
   - If not, look back through this conversation for an HLD path already established (created via `/hld`, or referenced by an earlier `/lld --amend`, `/add-spike`, `/resolve-open-questions`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If none is found, ask the user to provide a path and stop.
   - Check that the file at `<path>` exists. If it does not, tell the user and stop.
1. Read the file. This is a targeted edit to the `## Requirements` section only — do not touch any other section of the HLD itself.
1. Apply the change described using these lifecycle rules. Never delete or silently rewrite a row:
   - **Changed requirement** — strike the old row, append a new row with a successor ID (e.g. old `REQ-3` → new `REQ-3.1`):

     ```text
     ~~- [ ] REQ-3 — old requirement text~~ _(superseded by REQ-3.1, <date>)_
     - [ ] **REQ-3.1** — new requirement text
     ```

   - **New requirement** — append with the next sequential ID.
   - **Descoped requirement** — strike the row and keep it, noting why:

     ```text
     ~~- [ ] REQ-2 — old requirement text~~ _(Descoped <date>: reason)_
     ```

1. Scan for any LLDs that reference this HLD (via a `**HLD:**` link in their Overview, or `REQ-N.x` sub-IDs matching this doc's `REQ-N` IDs). Cascade into each one found, still touching only its `## Requirements` section:
   - **Changed or descoped requirement** — for each existing LLD row referencing the affected `REQ-N`, mark it `_(Needs Review — parent REQ changed <date>)_` rather than assuming it's still valid. Never touch the row's existing design content — only the annotation.
   - **New requirement** — no existing LLD row references it yet, so there's nothing to flag. Instead, append a new stub row to the LLD with the next sequential sub-ID, marked `_(Needs Review — new parent REQ-N, flowed from HLD amend <date>; needs LLD design)_`. This row stays out of `/implement-lld`'s scope until a human resolves it — normally by running `/lld` (not `/lld --amend`, since that's also Requirements-only) against the LLD to fill in the actual API/Data Model design for it, which clears the annotation.
1. Stamp `**Last Amended:** <date>` in the frontmatter of every doc touched (the HLD, and any LLDs cascaded into).
1. Report a summary: HLD rows changed/added/descoped, and for each LLD touched, which rows were flagged `Needs Review` (parent-changed) versus newly stubbed in (needs-design) — these need different follow-up, so don't merge them in the report.

Rules:

- Be specific — do not write generic filler. Every sentence must be grounded in the description provided.
- The output must be ready to share or commit with no editing required, except for the stub sections.
- Do not add sections not listed above.

$ARGUMENTS
