---
name: scan
description: How the scout scans environment, industry, tools, world. Surfaces patterns that inward-focused roles wouldn't notice. Use when boss asks "what's brewing?" or scout fires on its own initiative.
---

# Scan

The scout looks outward while the rest of the town looks inward. This skill is the scout's scanning rhythm.

## When this skill fires

- "@scout what's new in [domain]?"
- "@scout monitor [topic] over the next week and surface anything worth knowing"
- Scout fires on its own schedule (weekly, daily) via cron
- Boss notices the town hasn't lifted its head from work in a while

## The shape

1. **Pick the angle.** Industry trends? Competitor moves? New tools? Customer signals? Don't try to scan everything.
2. **Cast wide, sample fast.** RSS, search APIs, social posts, blog comments, GitHub repos, model registries, vendor changelogs — go broad before going deep.
3. **Triage.** Most of what comes back is noise. Filter ruthlessly: novel, actionable, relevant?
4. **Investigate the survivors.** Read full articles, watch videos, check repos. Don't extract from headlines.
5. **Surface with context.** A finding entry should explain *why this matters to us* — not just *this exists*.
6. **Promote earned findings.** If a pattern shows up 3+ times across sources, suggest the librarian curate it.

## Discipline

- Curious by default, disciplined about what gets promoted
- A finding without "why this matters to us" is a bookmark, not intelligence
- Pattern-spotting is the value-add; copy-paste summarising is not

## Sources to know

- Models / capability shifts: `models.flared.au`, Anthropic/OpenAI/Google announcements
- Cloudflare ecosystem: developers.cloudflare.com/changelog
- Agent ecosystem: Goose changelog, Claude Code releases, OpenAI Agents SDK
- SME / AI adoption: HN, indie newsletters, Twitter/X technical accounts
