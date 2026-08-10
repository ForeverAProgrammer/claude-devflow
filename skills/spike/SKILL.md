---
description: Validate the single highest-risk low-level technical assumption in a design by writing and running a minimal isolated test script, then resolving the corresponding [PENDING SPIKE VALIDATION] tag in the LLD/HLD. Use before locking in low-level design when a key assumption is unproven.
argument-hint: "[description or --hld|--lld <path>]"
disable-model-invocation: true
---

Validate the single highest-risk low-level technical assumption before locking in low-level design.

$ARGUMENTS may be:

- A freeform description of the assumption to validate, or
- `--lld <path>` to scan a referenced LLD's `[PENDING SPIKE VALIDATION]` tags and pick the highest-risk one automatically, or
- `--hld <path>` to do the same directly against an HLD — use this when the risky assumption was flagged (e.g. via `/add-spike`) before any LLD exists yet, or
- Nothing at all — infer the doc from this conversation (see step 1) if one is clearly in context.

If $ARGUMENTS is empty and no HLD/LLD path can be inferred from this conversation, ask the user to provide a description or a design doc path and stop.

Steps:

1. Identify the single highest-risk or lowest-level unvalidated assumption to test:
   - If a freeform description was given, use it directly.
   - If `--lld <path>` or `--hld <path>` was given, read the file at `<path>` (stop and tell the user if it does not exist) and scan it for `[PENDING SPIKE VALIDATION]` tags.
   - If $ARGUMENTS is empty (no description, no `--hld`/`--lld` flag), look back through this conversation for HLD/LLD paths already established (created via `/hld`/`/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one design doc with an outstanding `[PENDING SPIKE VALIDATION]` tag is found, confirm it with the user before proceeding. If more than one is found (e.g. both a linked HLD and LLD each have a pending tag), list them and ask which to use. If none is found, ask the user for a description or path and stop.
   - Once a doc is being scanned (via `--lld`/`--hld` or inferred), if it contains multiple `[PENDING SPIKE VALIDATION]` tags, pick the one that gates the most other work or carries the most technical risk, and tell the user which one you picked and why.

1. Derive a slug from the assumption (lowercase, hyphenated, ~5 words).

1. Create a `spikes/` directory in the current working directory if it does not already exist. Write a minimal, isolated test script to `spikes/<slug>.<ext>`, choosing `<ext>` to match the language conventions already used in this codebase. The script should test only the one assumption identified in step 1 — no surrounding feature code, no unrelated setup.

1. Execute the script and capture stdout, stderr, and exit code.

1. Summarize the findings for the user: what was tested, what happened, and any constraints or behavior discovered that the design needs to account for.

1. If a design doc was targeted — via `--lld <path>`, `--hld <path>`, or inferred from this conversation — resolve the corresponding `[PENDING SPIKE VALIDATION]` tag in that file (and its linked doc — LLD → linked HLD via its `**HLD:**` link, or HLD → any linked LLD — if the same tag text also appears there):
   - Replace it with `[VALIDATED]` if the assumption held, or `[REVISED: <what changed>]` if reality differs from what was assumed.
   - Backlink it to the script, e.g.:

     ```text
     [VALIDATED] _(validated by spikes/token-refresh-race.js)_
     ```

   - If a `## Requirements` row (in this doc or a cascaded one) is annotated `_(Needs Spike — ...)_` specifically because of the tag just resolved, clear that annotation — the row becomes a plain row again, still unchecked, ready for `/implement-lld` unless something else blocks it. Do not touch or check off the row's checkbox itself, and do not touch any row whose `Needs Spike` reason points to a different, still-unresolved tag — resolving checkboxes is `/reconcile`'s and `/implement-lld`'s job, not this skill's.

1. Report the script path, execution result, and (if applicable) which tag was resolved and how.

Rules:

- Test exactly one assumption per run — do not bundle multiple unknowns into a single spike.
- The script must be runnable as-is; do not leave placeholder credentials or unresolved TODOs in it.
- Do not touch any file outside `spikes/` and the single `[PENDING SPIKE VALIDATION]` tag being resolved.

$ARGUMENTS
