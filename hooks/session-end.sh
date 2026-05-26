#!/usr/bin/env bash
# SessionEnd hook — Office Town
#
# When a session ends, ensure today's journal exists with at least a stub entry.
# The actual journal content is the agent's job during the session; this hook
# just guarantees the file is present so the next session sees continuity.
#
# Pure-additive: never overwrite, never error on missing town roots.

set -u
TOWN_ROOT="${OFFICE_TOWN_ROOT:-$HOME/Documents/$(basename "$PWD")}"

if [ ! -d "${TOWN_ROOT}/buildings" ]; then
  exit 0
fi

BUILDING="${OFFICE_TOWN_BUILDING:-office}"
BUILDING_PATH="${TOWN_ROOT}/buildings/${BUILDING}"
JOURNAL_DIR="${BUILDING_PATH}/journal"

[ ! -d "$JOURNAL_DIR" ] && mkdir -p "$JOURNAL_DIR"

today="$(date +%Y-%m-%d)"
journal="${JOURNAL_DIR}/${today}.md"

if [ ! -f "$journal" ]; then
  cat > "$journal" <<EOF
---
slug: ${today}
kind: journal
building: ${BUILDING}
created: ${today}
last_updated: ${today}
last_edited_by: office-town-session-end-hook
last_change_summary: stub created by SessionEnd hook
---

# ${today} — ${BUILDING}

(stub created by SessionEnd hook; the agent may not have logged anything substantive this session)
EOF
fi

exit 0
