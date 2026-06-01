---
name: extract
description: Pull structured knowledge from unstructured sources (emails, web pages, transcripts, files, conversations) into wiki-ready shape. Use when the librarian is asked to "extract what we know about X" or to file something from external systems.
---

# Extract

External systems hold information in their shapes — email threads, Google Docs, scraped pages, Jim2 records. The wiki holds it in a portable, agent-readable shape. Extraction is the conversion.

## When this skill fires

- "@librarian extract everything we know about Acme Corp from the inbox"
- "@librarian file the meeting notes I just dropped into the building"
- Scout flags a long article; librarian extracts the relevant kernel
- A new contact / org / project lands and needs a wiki home

## The shape

1. **Read the source completely.** No skimming. Don't infer; extract what's actually there.
2. **Classify the entity.** Contact? Org? Project? Decision? Knowledge concept?
3. **Pick the right collection.** Check `wiki.list_collections` if unsure.
4. **Apply the universal sextet** + the collection's required fields (e.g. `email`, `phone` for contacts; `entity_type` for orgs).
5. **Write the body in plain language** — what would another agent need to know to act?
6. **Cite the source** — `_source: <URL or file path>` in frontmatter; quote facts inline.
7. **Cross-link** — if extracting about Acme, link to existing entries for Acme's contacts/projects/etc.
8. **Write via `wiki.create`** (or `wiki.update` if entry exists).

## Reasoning rules

- Person volunteering ≠ person being assigned
- Direction of an email thread = who initiated, not who sent the latest message
- Facts in signatures (titles, phone numbers) earn their place; speculative claims need a "?"
- Add fields naturally — don't force empty slots, don't omit found ones
