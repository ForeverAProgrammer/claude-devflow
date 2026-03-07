Read a Low Level Design document and apply the code changes it describes to the codebase.

$ARGUMENTS is the path to the LLD file (e.g. `design/lld-user-auth-service.md`). If $ARGUMENTS is empty, ask the user to provide a path and stop.

Steps:

1. Check that the file at $ARGUMENTS exists. If it does not, tell the user and stop.

2. Read the LLD file. Extract the following sections to drive implementation:
   - **Scope** — the specific classes, modules, endpoints, or functions to create or modify
   - **API / Interface Design** — function signatures, endpoint contracts, or event schemas to implement
   - **Data Models** — data structures, fields, types, and constraints to define
   - **Component Interactions** — how this component calls and is called by others
   - **Error Handling** — error conditions to handle and how to surface them
   - **Edge Cases** — non-obvious inputs or states that require special handling

   Skip any section or subsection that contains a `_TODO:` stub — do not invent content for stubs. Record each skipped stub to report to the user at the end.

3. Explore the codebase to find the files relevant to the Scope:
   - Search for existing files, classes, or modules named in the Scope section.
   - Read those files to understand the current implementation and conventions before making any changes.

4. Apply the minimum code changes needed to implement what the LLD describes:
   - Follow the existing patterns and conventions in the codebase.
   - Implement the API / Interface Design exactly as specified — do not add parameters or alter signatures.
   - Define Data Models as described — use the field names, types, and constraints from the LLD.
   - Wire Component Interactions as described — do not add extra calls or dependencies.
   - Implement Error Handling and Edge Cases as specified.
   - Do not refactor or change code unrelated to the LLD.
   - Do not add comments, docstrings, or logging unless the LLD specifically calls for them.

5. Summarise what was changed and why, referencing specific files and line numbers. List any stub sections that were skipped. Do not commit or push — leave that to the user.

$ARGUMENTS
