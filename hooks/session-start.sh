#!/usr/bin/env bash
# SessionStart hook — Office Town
#
# Surface today's context for whichever role wakes in this session:
#   1. The current building's AGENTS.md (Goose loads it automatically — we just confirm presence)
#   2. Recent findings/ entries (last 5 per building)
#   3. Today's journal entry for this building
#   4. Open tasks in tasks/
#
# The hook prints structured output that Goose injects into the session as
# SessionStart context. Failure here must not block the session — we tolerate
# missing files and missing town roots.

set -u
TOWN_ROOT="${OFFICE_TOWN_ROOT:-$HOME/Documents/$(basename "$PWD")}"

if [ ! -d "${TOWN_ROOT}/buildings" ]; then
  # Not in an Office Town deployment. Silent exit — let the agent run normally.
  exit 0
fi

# Determine which building we're in. Default to office.
BUILDING="${OFFICE_TOWN_BUILDING:-office}"
BUILDING_PATH="${TOWN_ROOT}/buildings/${BUILDING}"

if [ ! -d "$BUILDING_PATH" ]; then
  exit 0
fi

today="$(date +%Y-%m-%d)"

echo "=== Office Town session context ==="
echo "Town: $TOWN_ROOT"
echo "Building: $BUILDING"
echo

# Recent findings (last 5)
if [ -d "${BUILDING_PATH}/findings" ]; then
  echo "Recent findings:"
  ls -t "${BUILDING_PATH}/findings"/*.md 2>/dev/null | head -5 | while read -r f; do
    echo "  - ${f##*/}"
  done
  echo
fi

# Today's journal
journal="${BUILDING_PATH}/journal/${today}.md"
if [ -f "$journal" ]; then
  echo "Today's journal exists at: $journal"
  echo
fi

# Open tasks
if [ -d "${BUILDING_PATH}/tasks" ]; then
  open_count="$(ls "${BUILDING_PATH}/tasks"/*.md 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${open_count:-0}" -gt 0 ]; then
    echo "Open tasks: ${open_count}"
    echo
  fi
fi

exit 0
