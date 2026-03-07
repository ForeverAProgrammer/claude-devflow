Generate a Low Level Design (LLD) document from a freeform description and write it to a markdown file.

$ARGUMENTS is the description of the feature, component, or system. If $ARGUMENTS is empty, ask the user to provide a description and stop.

Steps:

1. Derive a filename slug from $ARGUMENTS: lowercase the description, replace spaces and special characters with hyphens, truncate to ~5 words, and prefix with `lld-` (e.g. `/lld user auth service` → `lld-user-auth-service.md`).

1. Generate the LLD document with the following sections. Populate every section from the description. If a section cannot be inferred, include it as a stub with a short prompt in italics (e.g. `_TODO: list the error codes this endpoint returns._`).

   Output structure:

   - `# LLD: <title derived from the description>`
   - `**Date:** <today's date in YYYY-MM-DD format>`
   - `**Status:** Draft`
   - `**Author:** <!-- your name -->`
   - `## Overview` — 2-3 sentences describing what this component does at the implementation level. Reference the HLD if one exists.
   - `## Scope` — what is covered in this document. List the specific classes, modules, endpoints, or functions in scope.
   - `## API / Interface Design` — the public interface: function signatures, REST endpoints, event schemas, or method contracts. Use code blocks where appropriate.
   - `## Data Models` — the data structures in use: fields, types, constraints, and relationships. Use tables or code blocks.
   - `## Component Interactions` — how this component calls and is called by others. Include sequence steps or a numbered interaction flow.
   - `## Error Handling` — what can go wrong, how errors are detected, and how they are surfaced to callers or users.
   - `## Edge Cases` — non-obvious inputs or states that require special handling.
   - `## Testing Considerations` — what unit, integration, or contract tests are needed. List the key scenarios to cover.
   - `## Open Questions` — unchecked checkboxes for implementation decisions that need to be resolved before coding begins.

1. Write the document to `<slug>.md` in the current working directory.

1. Tell the user the filename and confirm it was written. List any sections that were left as stubs.

Rules:

- Be specific — do not write generic filler. Every sentence must be grounded in the description provided.
- The output must be ready to share or commit with no editing required, except for the stub sections.
- Do not add sections not listed above.

$ARGUMENTS
