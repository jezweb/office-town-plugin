---
name: curate
description: Graduate findings into wiki entries. Read findings/ in any building, judge which patterns are sturdy enough to promote, write entries via the wiki MCP. Use when the librarian is doing curation passes or when boss flags accumulated learnings for promotion.
---

# Curate

Findings are raw observations; wiki entries are knowledge other roles can rely on. Curation is the graduation step.

## When this skill fires

- Librarian doing a periodic curation pass (weekly or on demand)
- Boss asks "what should we promote?"
- A finding has been referenced N times by other roles — it's earned its place

## The graduation criteria

A finding becomes a wiki entry when:

- It's been seen more than once (a pattern, not a one-off)
- It's actionable or load-bearing — future roles need it to act correctly
- Removing it would leave a future agent unable to do the right thing
- It's portable — not just "Jez said X on Tuesday" but a durable rule or fact

Findings that don't graduate go in the journal and decay naturally.

## The shape

1. Scan recent `findings/` across all buildings
2. Group related findings; surface candidates with a one-line summary each
3. For each promoted finding:
   - Pick the right collection (`knowledge/`, `decisions/`, `business/`, etc.)
   - Use the universal sextet frontmatter (slug, kind, created, last_updated, last_edited_by, last_change_summary)
   - Write the entry via `wiki.create` (or update via `wiki.update` if related entry exists)
   - Link back to the finding(s) that earned it
   - Leave a note in the finding marking it graduated
