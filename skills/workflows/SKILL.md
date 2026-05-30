---
name: workflows
description: How to run, define, and report on Workflows — the standing jobs the cortex owns. A Workflow is a Goose recipe (the goal) + a trigger.yaml (when it fires + trust). Use when a workflow fires (a matching file lands in inbox/, a schedule, or a webhook job), when the owner says "put my X on a workflow" / "run my workflows", or to pause/change one.
---

# Workflows

A **Workflow** is a standing responsibility the cortex owns. The owner turns it on once; it
fires on a trigger, does the work end to end, and reports back in a line. It is more than a
recipe-you-run and more than a skill-you-have: it has a trigger that fires it, a goal you
reason toward, and ownership of an outcome over time.

**A Workflow is a Goose recipe plus a thin trigger.** Each lives at `workflows/<slug>/`:
- `recipe.yaml` — a standard **Goose recipe**. Its `instructions:` are the goal in plain
  language. It declares no `extensions`, so it inherits the session's configured office-town
  MCPs. Runnable on its own: `goose run --recipe workflows/<slug>/recipe.yaml`.
- `trigger.yaml` — Office Town's layer: `on:` (`inbox` | `schedule` | `webhook` | `demand`),
  `match:`/`cron:`, `trust:` (`auto`|`review`|`ask`), `owner:`, `status:` (`active`|`paused`).
- `log.md` — one-line receipts. `pending/` — drafts awaiting the owner's OK.

## The contract every workflow meets
1. **Closes a loop** — each run produces a *moved* outcome (filed, drafted, surfaced, nudged).
2. **Net-negative human work** — success is time given back, not a to-do for the owner.
3. **Brief, silent when nothing moved** — no run, no noise.
4. **Trust-tiered** — never does something irreversible/outward without the owner's say.

## Running a workflow when it fires
1. **Read its goal** — `recipe.yaml`'s `instructions:` (read it with the files tool, or just
   run the recipe). The cortex is in the cloud — use your office-town MCP tools, not local shell.
2. **Do the work** toward that goal. For inbox triggers, convert files by `r2_path` (never
   base64; wait ~10s if not synced).
3. **Respect `trust:`** (from `trigger.yaml`):
   - `auto` — do it (reversible/internal: file, organise, recall).
   - `review` — do the work, but anything **outward or lossy** (send email, publish, merge,
     delete) goes to `workflows/<slug>/pending/` as a draft; tell the owner it's ready. **Never
     send/publish/delete without an explicit OK.**
   - `ask` — confirm first.
4. **Report** — append ONE line to `workflows/<slug>/log.md`:
   `YYYY-MM-DD HH:MM — <what moved, where>`. Stay silent to the owner unless the goal says to
   surface something (a duplicate, a threshold, an ambiguity).

## "Run my workflows" / new inbox files
List `workflows/*/trigger.yaml` (or the files prefix). For each `status: active` workflow whose
`on: inbox` `match:` fits what's new (a PDF → filing-cabinet, a recording → meeting-to-actions),
run it. Skip `status: paused`.

## Webhook / scheduled runs
- **Schedule** triggers can be registered with Goose's native scheduler (it runs recipes on cron).
- **Webhook** triggers enqueue a *job*; the daemon runs the recipe (`goose run --recipe`) with the
  `payload`. If you're handed a job payload, treat it as the workflow's input.

## Defining a new one ("put my receipts on a workflow")
Write two files in `workflows/<slug>/`:
- `recipe.yaml` — a Goose recipe: `version: "1.0.0"`, `title`, `description`, and `instructions: |`
  with the goal in plain language (what to do, what to leave alone, when to surface vs stay
  silent). Do NOT add an `extensions:` block — inherit the configured MCPs. Add `parameters:`
  only if it takes input (e.g. a webhook `payload`). Validate with `goose recipe validate`.
- `trigger.yaml` — `on`, `match`/`cron`, `trust`, `owner`, `status`, `report`.
Confirm the shape with the owner, then write the files. Pause one by setting `status: paused` in
its `trigger.yaml`. Keep the goal short — a goal, not a procedure.

## The visual panel (Goose Desktop)

The office-town-workflows MCP exposes ONE UI tool, `cortex_ui`, with a `view` parameter:
`cortex_ui(view: 'workflows')` (roster + a "Needs you" tray of pending approvals),
`cortex_ui(view: 'cortex', collection?, slug?)` (visual wiki browser),
`cortex_ui(view: 'entity', collection, slug, actions?)` (an editable panel for one entity),
`cortex_ui(view: 'tasks')` (a live kanban board), and `cortex_ui(view: 'kit')` (controls demo).

**When you show an entity, suggest its next moves.** Calling `cortex_ui(view: 'entity', …)`
opens an editable panel (the owner can click any field and overtype). Pass an `actions` array —
look at THIS entity (a person, company, project, property, whatever it is) and the owner's world,
and propose up to ~6 genuinely useful next moves as `{label, prompt}`: `label` is a short button
caption ("Draft a welcome email", "Set a 3-month reminder", "Create a follow-up task"); `prompt`
is the exact instruction sent back to you when the owner taps it. These aren't a fixed menu —
reason about what would actually help for this specific entity. **Respect trust in the prompt you
write:** for internal/reversible moves (create a task, set a reminder, file a note) write a prompt
that just does it; for outward/irreversible ones (send an email, publish) write a prompt that
DRAFTS to the workflow's `pending/` for the owner's OK. That's how the panel becomes "here's what
I'd do next — tap to approve," and the safe moves can eventually run on their own.

**Surface the panel proactively — don't make the owner ask.** When a session starts, or the owner
returns after time away, check whether any workflow has drafts in its `pending/` folder. If so,
call `cortex_ui(view: 'workflows')` to display the approvals tray right away ("a couple of things
are ready for your OK") rather than describing them in prose. A visual panel beats a wall of text
whenever the owner is choosing, approving, or browsing. Approve/Run/Decline buttons in the panel
send you a plain instruction — when one arrives, do what it asks.

## Building an app for the owner (`create_app`)

When the owner asks for a custom tool, tracker, board, calculator, or widget — build it. Call
`create_app({ name, description, html, width?, height? })`: you author a **self-contained HTML
document** and it installs to their Goose Apps page within ~1 min (the daemon writes it), opening
in its own window. Rules for the HTML:
- **Persistence via `window.ot`** — `await window.ot.load()` returns the saved JSON (`{}` first
  time); `await window.ot.save(data)` persists any JSON. Use these for ALL state. Never localStorage,
  never an external server.
- **Fully self-contained** — inline `<style>` + `<script>`. NO external CDN/script/font URLs; the
  sandbox blocks them.
- **Match the look** — warm Office Town palette (cream `#f7f3e8` / terracotta `#c25e4f`), or a dark
  espresso variant; system-ui font.
After creating, tell the owner it'll appear in the Apps tab shortly and to Launch it. Each app gets
its own private data store — it can't touch the cortex or other apps.
