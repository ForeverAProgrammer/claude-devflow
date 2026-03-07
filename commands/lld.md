Generate a Low Level Design (LLD) document from a freeform description and write it to a markdown file.

$ARGUMENTS may be:

- A freeform description of the feature, component, or system, or
- `--hld <path>` followed by an optional extra description (e.g. `/lld --hld design/hld-user-auth.md focus on the token refresh flow`). When `--hld` is provided, read the file at `<path>` and use its content as the primary source of context. The extra description, if present, narrows the scope.

If $ARGUMENTS is empty, ask the user to provide a description or an HLD path and stop.

Steps:

1. Parse $ARGUMENTS. If `--hld <path>` is present, read the file at `<path>`. Use the HLD content (plus any extra description) as the source for all sections below. If the path does not exist, tell the user and stop. If no `--hld` flag is present, use $ARGUMENTS as the description directly.

1. Derive a filename slug from the description or HLD title: lowercase, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with `lld-` (e.g. `/lld user auth service` → `lld-user-auth-service.md`).

1. Generate the LLD document with the following sections. Populate every section from the available context. If a section cannot be inferred, include it as a stub with a short prompt in italics (e.g. `_TODO: list the error codes this endpoint returns._`). If an HLD was provided, add a link to it in the Overview section.

   Output structure:

   - `# LLD: <title derived from the description or HLD>`
   - `**Date:** <today's date in YYYY-MM-DD format>`
   - `**Status:** Draft`
   - `**Author:** <!-- your name -->`
   - `## Overview` — 2-3 sentences describing what this component does at the implementation level. If an HLD was provided, include a line: `**HLD:** [<hld title>](<relative path to hld file>)`.
   - `## Scope` — what is covered in this document. List the specific classes, modules, endpoints, or functions in scope.
   - `## API / Interface Design` — the public interface: function signatures, REST endpoints, event schemas, or method contracts. Use code blocks where appropriate.
   - `## Data Models` — the data structures in use: fields, types, constraints, and relationships. Use tables or code blocks.
   - `## Component Interactions` — how this component calls and is called by others. Include sequence steps or a numbered interaction flow.
   - `## Error Handling` — what can go wrong, how errors are detected, and how they are surfaced to callers or users.
   - `## Edge Cases` — non-obvious inputs or states that require special handling.
   - `## Testing Considerations` — what unit, integration, or contract tests are needed. List the key scenarios to cover.
   - `## Open Questions` — unchecked checkboxes for implementation decisions that need to be resolved before coding begins.

1. Create a `design/` directory in the current working directory if it does not already exist. Write the document to `design/<slug>.md`.

1. Tell the user the file path (`design/<slug>.md`) and confirm it was written. List any sections that were left as stubs.

Rules:

- Be specific — do not write generic filler. Every sentence must be grounded in the description or HLD content provided.
- The output must be ready to share or commit with no editing required, except for the stub sections.
- Do not add sections not listed above.

$ARGUMENTS
