---
description: Walk through an HLD or LLD's Open Questions, asking the user for real answers, then update the doc — checking off each resolved question, updating the design section it affects, and adding or amending Requirements where the answer creates a new obligation. Use when a design doc has unresolved Open Questions blocking implementation.
argument-hint: "[path to HLD or LLD]"
---

Resolve a design doc's Open Questions by asking the user directly, then fold their answers back into the doc.

$ARGUMENTS is the path to an HLD or LLD file. The path may be omitted if it's already clear from this conversation — see step 1.

Steps:

1. Determine the target path:
   - If $ARGUMENTS contains a path, use it.
   - If not, look back through this conversation for an HLD or LLD path already established (created via `/hld`/`/lld`, or referenced by an earlier `/spike`, `/add-spike`, `/resolve-open-questions`, `/implement-lld`, or `/reconcile` call in this session). If exactly one is found, confirm it with the user before proceeding rather than silently assuming. If more than one is found, list them and ask which to use. If none is found, ask the user to provide a path and stop.
   - Check that the file at that path exists. If it does not, tell the user and stop.

1. Read the file's `## Open Questions` section and collect every unchecked (`- [ ]`) question. If none remain, tell the user there's nothing to resolve and stop.

1. For each unresolved question, ask the user directly — never answer it yourself or assume a default. Formulate 2-4 concrete answer options grounded in the rest of the doc's actual content (never generic placeholders), with a recommended option first when there's a clear default; the user can always answer outside the given options. Batch up to a handful of questions per round if there are several, running additional rounds for any that remain. Wait for real answers before touching the doc.

1. For each question the user just answered, apply whichever of the following actually apply:

   - **Always:** in `## Open Questions`, check the box and append a short resolution note — never delete or reword the original question text:

     ```text
     - [x] Should the counter be visible to bots? _(Resolved 2026-08-09: No — bots are excluded, see REQ-3)_
     ```

   - **If the answer changes what must be built or verified:** reflect it in `## Requirements` using the same lifecycle rules as `--amend` (never delete or silently overwrite a row; a new obligation gets the next sequential ID; a change to an existing requirement gets struck through with a successor row). If the answer itself is uncertain or surfaces an unvalidated technical risk (hedged language, "I think," "not sure," explicit doubt), don't write a falsely confident requirement — mark the resulting or updated row `_(Needs Spike — reason, flagged <date>)_` and insert a `[PENDING SPIKE VALIDATION]` tag in the relevant design section instead, the same convention `/add-spike` uses.
   - **If the answer only clarifies scope or a design detail without creating a new obligation:** update the relevant prose section directly (`## Proposed Design`, `## Data Models`, etc.) to reflect the decision — don't force it into a Requirements row it doesn't actually warrant.

1. **If this doc is an HLD** and a Requirements change from the previous step affects a requirement referenced by linked LLDs, cascade exactly as `/hld --amend` does: existing LLD rows referencing the changed `REQ-N` get `_(Needs Review — parent REQ changed <date>)_`; a brand-new requirement gets a stubbed `_(Needs Review — new parent REQ-N, flowed from Open Questions resolution <date>; needs LLD design)_` row appended to each linked LLD.

1. Stamp `**Last Amended:** <date>` on every doc touched (the doc resolved, and any LLDs cascaded into).

1. Report a summary: each question and how it was resolved, which Requirements rows were added or changed (call out any flagged `Needs Spike` rather than written as settled), which design sections were updated, and any LLD cascade.

Rules:

- Never answer an Open Question on the user's behalf or assume a default — always ask and wait for a real answer before updating anything.
- Never delete the original question text — resolution is additive (checkbox + note), matching how Requirements rows preserve history via strikethrough rather than deletion.
- Ground every proposed answer option in the doc's actual content — no generic filler options.
- Apply the same Requirements lifecycle and cascade rules used by `--amend` when a resolution changes or adds a requirement.

$ARGUMENTS
