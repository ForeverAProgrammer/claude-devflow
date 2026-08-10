---
description: Read a Low Level Design document and apply the code changes it describes to the codebase.
argument-hint: "[path] [--req <ID>[,<ID>...]]"
disable-model-invocation: true
---

Read a Low Level Design document and apply the code changes it describes to the codebase.

$ARGUMENTS is the path to the LLD file (e.g. `design/lld-user-auth-service.md`), optionally followed by `--req <ID>[,<ID>...]` (e.g. `--req REQ-3.1` or `--req REQ-3.1,REQ-3.2`) to restrict implementation to specific requirement rows instead of everything outstanding. The path may be omitted if it's already clear from this conversation — see step 1.

Steps:

1. Determine the target LLD path:
   - If $ARGUMENTS contains a path, use it.
   - If not, look back through this conversation for an LLD path already established (created via `/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If only an HLD path was referenced with no LLD yet, tell the user and stop — don't guess an LLD that doesn't exist. If none is found, ask the user to provide a path and stop.
   - Check that the file at that path exists. If it does not, tell the user and stop.

2. Read the LLD file, including its frontmatter. Determine the mode:
   - Read `**Mode:**`. A missing field means `Strict` — fully backward compatible with LLDs written before this field existed.
   - If the LLD links to an HLD (via `**HLD:**` in the Overview), read that HLD's `**Mode:**` too. If it differs from the LLD's mode, warn the user about the mismatch but proceed using the LLD's mode — don't fail.

3. Determine which `## Requirements` rows are in scope for this run:
   - **If `--req <ID>[,<ID>...]` was passed**, scope to exactly those rows. If any named ID doesn't exist in the file, tell the user and stop. If any named ID is currently `- [x]` (already checked off), implement it anyway — an explicit `--req` is a deliberate re-implementation request.
   - **If `--req` was not passed**, scope to every row currently `- [ ]` (unchecked). Skip rows already `- [x]` — do not re-touch or re-verify code for requirements already marked complete.
   - **In both cases**, any row marked `_(Needs Review — ...)_` or `_(Needs Spike — ...)_` is always excluded from scope, even if named explicitly via `--req` — both are stop-and-surface-to-user conditions, never implemented or checked off automatically. `Needs Spike` specifically means the requirement rests on an assumption `/spike` hasn't validated yet — implementing it would build on an unproven foundation. Report each excluded row to the user instead, grouped by which annotation blocked it.

4. Extract the following sections to drive implementation, filtered to what supports the rows in scope from step 3:
   - **Scope** — the specific classes, modules, endpoints, or functions to create or modify
   - **API / Interface Design** — function signatures, endpoint contracts, or event schemas to implement
   - **Data Models** — data structures, fields, types, and constraints to define
   - **Component Interactions** — how this component calls and is called by others
   - **Error Handling** — error conditions to handle and how to surface them
   - **Edge Cases** — non-obvious inputs or states that require special handling

   Skip any section or subsection that contains a `_TODO:` stub — do not invent content for stubs. Record each skipped stub to report to the user at the end.

5. Explore the codebase to find the files relevant to the Scope:
   - Search for existing files, classes, or modules named in the Scope section.
   - Read those files to understand the current implementation and conventions before making any changes.

6. Apply the code changes needed to implement what the LLD describes, per the resolved mode:
   - **Strict mode** — implement exactly as specified. Do not deviate from the API / Interface Design, Data Models, or Component Interactions. Skip `_TODO:` stubs rather than inventing content for them.
   - **Living mode** — treat the LLD as a draft. Deviations are permitted where the code reveals a better approach, but do not silently edit the LLD's own sections mid-implementation to match — leave that for `/reconcile` to capture after the fact.

   In both modes:
   - Follow the existing patterns and conventions in the codebase.
   - Do not add parameters or alter signatures beyond what's specified (Strict), or beyond what a discovered-better-approach deviation requires (Living).
   - Define Data Models using the field names, types, and constraints from the LLD.
   - Implement Error Handling and Edge Cases as specified.
   - Do not refactor or change code unrelated to the LLD.
   - Do not add comments, docstrings, or logging unless the LLD specifically calls for them.
   - As each in-scope `## Requirements` row is implemented, check it off (`- [ ]` → `- [x]`) in the LLD file.

7. **Roll up completed parent requirements.** For each LLD row just checked off that references a parent HLD requirement (`REQ-N.x` referencing HLD `REQ-N`), and the LLD links to an HLD: check every *current* row in this LLD referencing that same `REQ-N` — ignore struck-through/superseded rows (only the latest successor counts), but treat any row still `- [ ]` — including any marked `Needs Review` or `Needs Spike` — as blocking. If none are blocking, check off `REQ-N` in the HLD file too. Never check off an HLD row this way if any referencing LLD row is unchecked, `Needs Review`, or `Needs Spike`.

8. **Living mode only:** once implementation and Requirements checkboxes are complete, invoke `/reconcile` against this same LLD (and its linked HLD, if any) so the docs and code land in sync before the user commits.

9. Summarise what was changed and why, referencing specific files and line numbers. List any stub sections that were skipped, any `Needs Review` or `Needs Spike` rows excluded from scope, any HLD rows checked off via rollup, and (Living mode) confirm `/reconcile` was run. Do not commit or push — leave that to the user.

$ARGUMENTS
