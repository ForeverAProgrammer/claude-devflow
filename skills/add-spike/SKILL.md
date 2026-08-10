---
description: Flag an existing HLD or LLD requirement (or add a new one) as needing spike validation before it can be trusted or implemented — inserts a [PENDING SPIKE VALIDATION] tag into the relevant design section and marks the requirement row Needs Spike, cascading the flag to linked docs. Use when a requirement looks simple but actually rests on an unproven technical assumption.
argument-hint: "[path to HLD or LLD] <REQ-ID or description of the risky requirement>"
---

Flag a requirement as resting on an unvalidated technical assumption, so it can't be quietly implemented or marked done until a spike confirms it.

$ARGUMENTS is the path to an HLD or LLD file, followed by either an existing `REQ-*` ID (optionally with a reason) or a freeform description of a new requirement to add already flagged. The path may be omitted if it's already clear from this conversation — see step 1. The REQ-ID or description is always required; if $ARGUMENTS has neither a path nor that, ask the user to provide it and stop.

Steps:

1. Determine `<path>`:
   - If a path is present in $ARGUMENTS, use it.
   - If not, look back through this conversation for an HLD or LLD path already established (created via `/hld`/`/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If none is found, ask the user to provide a path and stop.
   - Check that the file at `<path>` exists. If it does not, tell the user and stop.

1. Determine the target requirement:
   - If the remaining text starts with an existing `REQ-*` ID found in the doc's `## Requirements` section, that row is the target; anything after the ID is the reason/description of what's uncertain about it.
   - Otherwise, treat the remaining text as a freeform description of a **new** requirement to add — flagged from the moment it's created. Assign it the next sequential ID (`REQ-N` for an HLD; `REQ-N.x` referencing a parent HLD requirement if this is an LLD and one is implied).

1. Check the doc's `**Mode:**`. `[PENDING SPIKE VALIDATION]` tags are a Living-mode concept:
   - **If `Strict`**, stop and tell the user the doc needs to be switched to Living mode first (e.g. re-run `/hld --mode living <path> ...` or `/lld --mode living <path> ...`) — don't silently flip the mode as a side effect of this skill.
   - **If `Living`**, proceed.

1. Insert a `[PENDING SPIKE VALIDATION]: <specific technical assumption>` tag inline in the section it actually concerns — `## Proposed Design` for an HLD; `## API / Interface Design` or `## Data Models` for an LLD, whichever the risky assumption is actually about. State the assumption specifically, grounded in the requirement text and any reason given — never generic filler like "needs testing."

1. Annotate the Requirements row (existing or newly added) — never rewrite or remove the requirement's original statement, only add or update the parenthetical:

   ```text
   - [ ] **REQ-4** — Server sustains 10,000 concurrent WebSocket connections without dropping messages. _(Needs Spike — concurrency ceiling unvalidated, flagged <date>)_
   ```

   **If the row is currently `- [x]` (already checked off),** uncheck it back to `- [ ]` as part of this same edit — a row can't simultaneously be "done" and "resting on an unvalidated assumption." This is the expected case when a previously-shipped requirement turns out to rest on something nobody actually verified; the checkbox coming back to `- [ ]` is what keeps `/implement-lld` and `/reconcile` from silently treating it as still settled.

   If the row already carries a different annotation (`Needs Review`, `Blocked`, etc.), don't silently overwrite it — tell the user both apply and ask which should take precedence in the parenthetical, or whether both should be noted.

1. **If the target doc is an HLD**, cascade downward: scan for any linked LLDs (via a `**HLD:**` link in their Overview, or `REQ-N.x` sub-IDs matching this doc's `REQ-N`). For each existing LLD row referencing the flagged `REQ-N`, mark it `_(Needs Spike — parent REQ-N flagged for spike <date>)_` too — touch only the annotation, never the row's design content, but apply the same uncheck-if-checked rule to these cascaded rows as well.

   **If the target doc is an LLD**, there's nothing to cascade further down to. No upward cascade to the HLD happens either — the parent HLD row is left as-is, but it structurally can't roll up to checked while this sub-requirement stays unchecked (see `/implement-lld` and `/reconcile`'s rollup rule).

1. Stamp `**Last Amended:** <date>` on every doc touched.

1. Report: which row was flagged (or newly added), where the `[PENDING SPIKE VALIDATION]` tag was inserted, any cascaded LLD rows, and the suggested next step — run `/spike --hld <path>` or `/spike --lld <path>` to actually validate the assumption.

Rules:

- Be specific about the technical assumption in the inserted tag — never generic filler.
- Never remove or reword the requirement's original ask — only mark it provisional.
- Touch only the one Requirements row (or new row) and the single inserted `[PENDING SPIKE VALIDATION]` tag — this is a targeted flag, not a redesign.
- A row marked `Needs Spike` is excluded from `/implement-lld`'s scope and from `/reconcile`'s checkoff, exactly like `Needs Review` — it stays that way until `/spike` resolves the tag and a human clears the annotation.

$ARGUMENTS
