---
description: Generate a Low Level Design (LLD) document from a freeform description and write it to a markdown file in the design/ directory. Use when the user wants to document the low-level implementation details of a component.
argument-hint: "[description or --hld <path>] [--mode living|strict] [--amend <path> <change description>]"
---

Generate a Low Level Design (LLD) document from a freeform description and write it to a markdown file.

$ARGUMENTS may include:

- A freeform description of the feature, component, or system, or
- `--hld <path>` followed by an optional extra description (e.g. `/lld --hld design/hld-user-auth.md focus on the token refresh flow`). When `--hld` is provided, read the file at `<path>` and use its content as the primary source of context. The extra description, if present, narrows the scope.
- `--mode living|strict` — sets the doc's `Mode`. If `--hld` was provided and `--mode` was not, inherit the HLD's `Mode` field. Otherwise defaults to `strict`.
- `--amend [path] <change description>` — targeted edit to an existing doc's `## Requirements` section only. `<path>` may be omitted if it's already clear from this conversation — see the Amend Mode steps below, which are skipped entirely when this flag isn't present.

If $ARGUMENTS is empty, ask the user to provide a description or an HLD path and stop.

### Normal generation

1. Parse $ARGUMENTS. If `--hld <path>` is present, read the file at `<path>`. Use the HLD content (plus any extra description) as the source for all sections below. If the path does not exist, tell the user and stop. If no `--hld` flag is present, use $ARGUMENTS as the description directly.

1. Derive a filename slug from the description or HLD title: lowercase, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with `lld-` (e.g. `/lld user auth service` → `lld-user-auth-service.md`).

1. Check whether `design/<slug>.md` already exists.

   - **If it exists**, this run is an edit, not a fresh overwrite:
     - Preserve existing `REQ-*` rows and their checked/unchecked state exactly.
     - Preserve the existing `Mode`, `Last Reconciled`, and `Last Amended` values unless `--mode` was explicitly passed on this run.
     - Only add new requirements (next sequential ID, e.g. `REQ-1.1` if the parent HLD requirement is `REQ-1`) or update non-Requirements sections as directed by the new input — do not regenerate sections that aren't affected by it.
     - If this run supplies the actual design (API / Interface Design, Data Models, etc.) for a row currently marked `_(Needs Review — ...)_`, clear that annotation once the design is filled in — the row reverts to a plain `- [ ] **REQ-N**` line, unblocking it for `/implement-lld`. Only clear the annotation on rows this run actually addresses; leave every other `Needs Review` row untouched.
   - **If it does not exist**, generate fresh per the Output structure below.

1. Generate or update the LLD document with the following sections. Populate every section from the available context. If a section cannot be inferred, include it as a stub with a short prompt in italics (e.g. `_TODO: list the error codes this endpoint returns._`). If an HLD was provided, add a link to it in the Overview section.

   Output structure:

   - `# LLD: <title derived from the description or HLD>`
   - `**Date:** <today's date in YYYY-MM-DD format>`
   - `**Status:** Draft`
   - `**Author:** <!-- your name -->`
   - `**Mode:** Living | Strict` — from `--mode`, inherited from the linked HLD, or `Strict` if neither applies.
   - `**Last Reconciled:** <date> @ <short-sha>` — leave blank until the first `/reconcile` run.
   - `**Last Amended:** <date>` — leave blank until the first `--amend` run.
   - `## Overview` — 2-3 sentences describing what this component does at the implementation level. If an HLD was provided, include a line: `**HLD:** [<hld title>](<relative path to hld file>)`.
   - `## Scope` — what is covered in this document. List the specific classes, modules, endpoints, or functions in scope.
   - `## API / Interface Design` — the public interface: function signatures, REST endpoints, event schemas, or method contracts. Use code blocks where appropriate. In Living mode, tag genuinely uncertain low-level detail inline with `[PENDING SPIKE VALIDATION]` instead of inventing content.
   - `## Data Models` — the data structures in use: fields, types, constraints, and relationships. Use tables or code blocks. In Living mode, tag genuinely uncertain fields/types with `[PENDING SPIKE VALIDATION]` rather than guessing.
   - `## Component Interactions` — how this component calls and is called by others. Include sequence steps or a numbered interaction flow.
   - `## Error Handling` — what can go wrong, how errors are detected, and how they are surfaced to callers or users.
   - `## Edge Cases` — non-obvious inputs or states that require special handling.
   - `## Testing Considerations` — what unit, integration, or contract tests are needed. List the key scenarios to cover.
   - `## Requirements` — one row per requirement:
     `- [ ] **REQ-N** — <requirement statement> _(optional: Blocked/In Progress/Needs Review/Needs Spike — reason)_`
     If an HLD was provided, reference its requirement where applicable using a dotted sub-ID (`REQ-1.1`, `REQ-1.2` for HLD `REQ-1`). IDs are assigned sequentially per document and are permanent — never renumber or reuse an ID, even after a row is struck through.
   - `## Open Questions` — unchecked checkboxes for implementation decisions that need to be resolved before coding begins.

1. Create a `design/` directory in the current working directory if it does not already exist. Write the document to `design/<slug>.md`.

1. Tell the user the file path (`design/<slug>.md`) and confirm it was written. List any sections that were left as stubs. If `## Open Questions` has any unchecked items, mention that `/resolve-open-questions design/<slug>.md` can walk through them.

### Amend mode (`--amend [path] <change description>`)

1. Determine `<path>`:
   - If a path is present after `--amend`, use it.
   - If not, look back through this conversation for an LLD path already established (created via `/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If only an HLD path was referenced with no LLD yet, tell the user and stop — don't guess an LLD that doesn't exist. If none is found, ask the user to provide a path and stop.
   - Check that the file at `<path>` exists. If it does not, tell the user and stop.
1. Read the file. This is a targeted edit to the `## Requirements` section only — do not touch any other section.
1. Apply the change described using these lifecycle rules. Never delete or silently rewrite a row:
   - **Changed requirement** — strike the old row, append a new row with a successor ID:

     ```text
     ~~- [ ] REQ-1.1 — old requirement text~~ _(superseded by REQ-1.2, <date>)_
     - [ ] **REQ-1.2** — new requirement text
     ```

   - **New requirement** — append with the next sequential ID.
   - **Descoped requirement** — strike the row and keep it, noting why:

     ```text
     ~~- [ ] REQ-2 — old requirement text~~ _(Descoped <date>: reason)_
     ```

1. Stamp `**Last Amended:** <date>` in the frontmatter.
1. Report a summary: rows changed/added/descoped.

Rules:

- Be specific — do not write generic filler. Every sentence must be grounded in the description or HLD content provided.
- The output must be ready to share or commit with no editing required, except for the stub sections.
- Do not add sections not listed above.

$ARGUMENTS
