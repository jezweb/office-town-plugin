---
name: workflows
description: How to run, define, and report on Workflows — the standing jobs the cortex owns (trigger → agentic steps → moved outcome). Use when a workflow fires (a matching file lands in inbox/, a schedule, or a webhook job), when the owner says "put my X on a workflow" / "run my workflows", or to pause/change one.
---

# Workflows

A **Workflow** is a standing responsibility the cortex owns. The owner turns it on once;
it fires on a trigger, does the work end to end, and reports back in a line. It is *more*
than a recipe (a script you run) and *more* than a skill (something you can do): it has a
trigger that fires it, a goal you reason toward, and ownership of an outcome over time.

Each lives in the cortex at `workflows/<slug>/`:
- `workflow.md` — the definition: frontmatter (the contract) + a plain-language goal body.
- `log.md` — the receipt trail: one line appended per firing.
- `pending/` — drafts/proposals waiting for the owner's OK (trust: review).

## The contract every workflow meets
1. **Closes a loop** — each run produces a *moved* outcome (filed, drafted, surfaced,
   nudged), never just more knowledge stored.
2. **Net-negative human work** — success is time given back. If the owner has to redo or
   re-prompt it, it failed.
3. **Brief, and silent when nothing moved** — small output; no run, no noise.
4. **Trust-tiered** — never does something irreversible/outward without the owner's say.

## Running a workflow when it fires
1. **Read its `workflow.md`.** The body is the *goal*, not a step script — reason toward it.
2. **Do the work** using your role + skills + the MCP tools. For inbox triggers, convert
   files by `r2_path` (never base64; wait ~10s if not synced yet).
3. **Respect the trust tier** (frontmatter `trust:`):
   - `auto` — do it; it's reversible + internal (file, organise, link, recall).
   - `review` — do the work, but anything **outward or lossy** (send email, publish, merge,
     delete, move-a-lot) goes to `workflows/<slug>/pending/` as a draft, and you tell the
     owner it's ready. **Never send/publish/delete without an explicit OK.**
   - `ask` — confirm with the owner before acting.
4. **Report** — append ONE line to `workflows/<slug>/log.md`:
   `YYYY-MM-DD HH:MM — <what moved, where>`. If nothing needed moving, say almost nothing.
   Surface a one-line note to the owner only when the workflow's body says to (a duplicate,
   an amount over a threshold, something ambiguous) — otherwise stay quiet.

## "Run my workflows" / a session with new inbox files
List `workflows/*/workflow.md` (use the files tool on the `workflows/` prefix, or read the
defs). For each `status: active` workflow whose trigger matches what's new (e.g. a PDF
landed and `filing-cabinet` matches `*.pdf`), run it. Skip `status: paused` ones.

## Webhook-triggered runs
A webhook enqueues a *job* (the worker holds it; the daemon hands it to you with a
`payload`). Treat the job's `workflow_slug` as the workflow to run and the `payload` as its
input, then report the result back the same way (a log line + any pending draft).

## Defining a new one ("put my receipts on a workflow")
Draft a `workflows/<slug>/workflow.md`: frontmatter `name, slug, status: active, owner
(boss/worker/librarian/scout), trust (auto|review|ask), trigger ({on: inbox, match: "..."}
| {on: schedule, cron: "..."} | {on: webhook} | {on: demand}), report`, then a short
plain-language goal that says what to do, what to leave alone, and when to surface vs stay
silent. Confirm the shape with the owner, then write the file. To pause one, set
`status: paused`. Keep definitions short — a goal, not a procedure.
