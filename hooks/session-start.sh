#!/usr/bin/env bash
# SessionStart hook — Office Town
#
# Surfaces cortex state at the start of every session so whichever role wakes
# here can greet the owner appropriately — orienting a brand-new user, or
# picking up where a returning one left off.
#
# Works against the cloud cortex layout (the folder officetowd syncs):
#   <cortex>/AGENTS.md
#   <cortex>/inbox/
#   <cortex>/wiki/{orgs,contacts,projects,owner,...}/
#
# Detection order for the cortex root:
#   1. $OFFICE_TOWN_ROOT if set
#   2. the cwd, or the nearest ancestor, that contains AGENTS.md + wiki/
#
# Failure here must never block the session — missing files are tolerated.

set -u

# --- Locate the cortex root -------------------------------------------------
find_root() {
  if [ -n "${OFFICE_TOWN_ROOT:-}" ] && [ -d "${OFFICE_TOWN_ROOT}/wiki" ]; then
    printf '%s' "$OFFICE_TOWN_ROOT"
    return 0
  fi
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "${dir}/AGENTS.md" ] && [ -d "${dir}/wiki" ]; then
      printf '%s' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

ROOT="$(find_root)" || exit 0   # not in an Office Town cortex — run normally
WIKI="${ROOT}/wiki"
INBOX="${ROOT}/inbox"
today="$(date +%Y-%m-%d)"

# --- Helpers ----------------------------------------------------------------
# Count real content files in a dir, excluding the structural _intro.md and
# the onboarding prompts that ship with every cortex.
count_real() {
  local dir="$1"; shift
  [ -d "$dir" ] || { echo 0; return; }
  local n=0 f base
  while IFS= read -r f; do
    base="${f##*/}"
    case "$base" in
      _intro.md|prompt-quick.md|prompt-thorough.md) continue ;;
    esac
    n=$((n + 1))
  done < <(find "$dir" -type f -name '*.md' 2>/dev/null; find "$dir" -type f ! -name '*.md' 2>/dev/null)
  echo "$n"
}

owner_files="$(count_real "${WIKI}/owner")"
inbox_files="$(count_real "${INBOX}")"
active_workflows=$(grep -rl '^status: active' "${ROOT}/workflows"/*/trigger.yaml 2>/dev/null | wc -l | tr -d ' ')
# Drafts awaiting the owner's OK live in workflows/<slug>/pending/ (synced locally).
pending_drafts=$(find "${ROOT}/workflows"/*/pending -type f 2>/dev/null | wc -l | tr -d ' ')

# "Populated" = the owner has put real material in beyond the shipped seeds.
# Seeds live under known slugs (acme-corp, sarah-smith, the doctrine concepts);
# anything else in orgs/contacts/projects is the owner's own.
real_orgs=$(find "${WIKI}/orgs" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -v '/acme-corp$' | wc -l | tr -d ' ')
real_contacts=$(find "${WIKI}/contacts" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -v '/sarah-smith$' | wc -l | tr -d ' ')
real_projects=$(find "${WIKI}/projects" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -v '/acme-renewal-2024$' | wc -l | tr -d ' ')
real_entities=$(( real_orgs + real_contacts + real_projects ))

# Most recent wiki change (excludes _intro scaffolding).
recent_file="$(find "$WIKI" -type f -name '*.md' ! -name '_intro.md' -print0 2>/dev/null \
  | xargs -0 ls -t 2>/dev/null | head -1)"

# --- Emit context -----------------------------------------------------------
echo "=== Office Town cortex ==="
echo "Cortex: $ROOT"
echo

# Highest priority: anything waiting for the owner's approval. Surface the visual
# panel proactively — this is the "you wouldn't have to ask" behaviour.
if [ "${pending_drafts:-0}" -gt 0 ]; then
  echo "NEEDS YOU: ${pending_drafts} draft(s) awaiting approval in workflows/*/pending/."
  echo "Before anything else, open the approvals panel — call cortex_ui(view: 'workflows')"
  echo "— and tell the owner what's ready. Never send/publish/delete a draft without their OK."
  echo
fi

if [ "$owner_files" -eq 0 ] && [ "$real_entities" -eq 0 ]; then
  # FRESH cortex — only the shipped seeds. This is a first-contact session.
  echo "STATE: fresh — only the shipped example seeds are here, no owner profile yet."
  echo "This is almost certainly a new owner. Follow the first-contact protocol in"
  echo "AGENTS.md: orient them in a few sentences, then offer concrete first moves"
  echo "(empty their filing cabinet into inbox/, capture a client/project, or a quick"
  echo "tour) and let them pick. Don't lecture. Don't list every feature."
  if [ "$inbox_files" -gt 0 ]; then
    echo
    echo "NOTE: $inbox_files file(s) already waiting in inbox/ — they may have dropped"
    echo "something to process. Offer to go through it."
  fi
else
  # POPULATED — returning owner. Greet where they left off, don't re-introduce.
  echo "STATE: populated — this owner has real content. Don't re-introduce Office Town."
  echo "Greet them where they left off and ask what's next."
  [ "$owner_files" -gt 0 ] && echo "  • Owner profile present in wiki/owner/ — read it; write + speak in their voice."
  [ "$real_entities" -gt 0 ] && echo "  • $real_entities owner entit(ies) across orgs/contacts/projects."
  [ "$inbox_files" -gt 0 ] && echo "  • $inbox_files unprocessed file(s) in inbox/ — offer to work through them."
  if [ -n "$recent_file" ]; then
    echo "  • Most recently touched: ${recent_file#$ROOT/}"
  fi
fi

# Workflows the cortex owns — standing jobs that fire on triggers. The `workflows`
# skill explains how to run/define them.
if [ "${active_workflows:-0}" -gt 0 ]; then
  echo
  echo "WORKFLOWS: $active_workflows active (workflows/) — standing jobs the cortex owns."
  if [ "$inbox_files" -gt 0 ]; then
    echo "  $inbox_files inbox file(s) may match one (e.g. filing-cabinet for docs,"
    echo "  meeting-to-actions for recordings). Offer to run the matching workflow(s)."
  fi
fi

# Today's journal, if the owner keeps one at the cortex root.
if [ -f "${ROOT}/journal/${today}.md" ]; then
  echo
  echo "Today's journal: journal/${today}.md"
fi

exit 0
