# Office Town plugin

The Goose plugin for [Office Town](https://github.com/jezweb/office-town). Install once, get the 4 core roles (boss, librarian, worker, scout), default skills, recipes, hooks, and town-wide standing orders wired into Goose.

Plugin structure follows [Open Plugin Spec v1.0.0](https://github.com/vercel-labs/open-plugin-spec) — so other conformant hosts (Claude Code, etc.) can consume the same agents/skills/commands files, but v1.0 is built and tested for Goose.

## Get started

Need Goose installed first — https://block.github.io/goose/.

```bash
goose plugin install jezweb/office-town-plugin
```

Then either install the [Cloudflare backend](https://github.com/jezweb/office-town-cloud) yourself, or paste the agent-install prompts at [INSTALL.md](./INSTALL.md) to do the whole thing in one go.

## What's in this plugin

```
office-town-plugin/
├── .plugin/plugin.json     # Manifest (Open Plugin Spec v1.0.0)
├── agents/                 # The 4 core roles
│   ├── boss.md             # Routes work, holds the thread
│   ├── librarian.md        # Extracts + curates the wiki
│   ├── worker.md           # Deep work
│   └── scout.md            # Outward scanning
├── skills/                 # Per-role techniques
│   ├── curate/             # Graduate findings into wiki entries
│   ├── extract/            # Pull structured knowledge from unstructured sources
│   ├── build/              # The worker's working rhythm
│   ├── scan/               # The scout's scanning rhythm
│   └── dispatch/           # How boss routes work
├── commands/               # Slash-command recipes
│   ├── office-town-setup.yaml         # First-session onboarding
│   ├── weekly-sweep.yaml              # Scout's weekly scan
│   ├── knowledge-graduation.yaml      # Librarian's curation pass
│   ├── project-onboarding.yaml        # New project capture
│   └── triage-inbox.yaml              # Librarian inbox triage
├── hooks/
│   ├── hooks.json          # SessionStart + SessionEnd hooks
│   ├── session-start.sh    # Loads briefings, recent findings, today's journal
│   └── session-end.sh      # Ensures today's journal exists
├── rules/
│   └── town-standing-orders.md  # Universal behaviour for every role
└── tests/                  # Headless Goose tests — see tests/README.md
```

## Install

### Via Goose

```bash
goose plugin install jezweb/office-town
```

### Manual

```bash
git clone https://github.com/jezweb/office-town-plugin.git \
  ~/.config/goose/plugins/office-town
```

After install, restart Goose. The 4 roles become available via `@-mention`,
recipes show as slash commands, and the session-start hook fires on every
session you open in an Office Town deployment.

## Quick start

1. Install the plugin (above)
2. Clone the [office-town template](https://github.com/jezweb/office-town):
   ```bash
   git clone https://github.com/jezweb/office-town.git ~/Documents/my-town
   ```
3. Open Goose at `~/Documents/my-town/buildings/office`
4. Run setup: `/office-town-setup town_name:my-town`
5. The boss walks you through 7 conversational steps to capture business,
   voice, team, and initial contacts/orgs

After setup, start delegating:
```
@worker draft the Q3 proposal for Acme
@librarian extract everything we know about Acme from my inbox
@scout what's brewing in the WordPress hosting industry?
```

## What this is NOT

- Not a wiki backend — the wiki MCP lives in
  [`office-town-cloud`](https://github.com/jezweb/office-town-cloud) and is
  installed separately
- Not a Goose fork — it's a plugin that runs on stock Goose
- Not opinionated about your provider — you bring your own LLM
- Not multi-tenant — one town per machine; Cloudflare backend is per-user

## Compatibility

| Host | Status |
|---|---|
| Goose ≥ 1.35.0 | ✅ Primary target |
| Claude Code | 🟡 Cross-host portable per spec; not yet validated |
| Other Open Plugin Spec hosts | 🟡 Theoretically; please file an issue if you test |

## Development

The test pack (`tests/`) verifies role identity + delegation + briefing
loading against any Office Town deployment.

```bash
export TOWN_ROOT=~/Documents/my-town
export GOOSE_BIN=/path/to/goose
bash tests/runner.sh
```

A GitHub Actions workflow (`.github/workflows/test-pack.yml`) runs the
pack on every PR touching agents/skills/commands/hooks (disabled by default
until `RUN_TEST_PACK_IN_CI` repo variable is set to `true`).

## See also

- [Office Town template](https://github.com/jezweb/office-town) — the
  markdown methodology this plugin packages
- [Office Town Cloud](https://github.com/jezweb/office-town-cloud) — the
  Cloudflare Workers backend (wiki MCP, files, publish, kanban, cron)
- [Methodology](https://github.com/jezweb/office-town/blob/main/METHODOLOGY.md)
  — the why behind Town/Place/Role/Task vocabulary

## Licence

MIT. © 2026 Jezweb Pty Ltd.
