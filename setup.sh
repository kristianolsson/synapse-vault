#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ -f "PERSONAL.md" ]; then
  echo "PERSONAL.md already exists — nothing to do. Edit it directly if you want to change your details."
  exit 0
fi

echo "Setting up your personal context (PERSONAL.md, gitignored by default — see README for how to track it in your own private repo)."
echo

read -rp "Your name: " NAME
read -rp "Your username/handle: " USERNAME
read -rp "Family members to mention (optional, press Enter to skip): " FAMILY
read -rp "Your city/location: " LOCATION
read -rp "Additional locations, e.g. a vacation home (optional, press Enter to skip): " EXTRA_LOCATION

FAMILY_SENTENCE=""
if [ -n "$FAMILY" ]; then
  FAMILY_SENTENCE=" $FAMILY."
fi

EXTRA_LOCATION_SENTENCE=""
if [ -n "$EXTRA_LOCATION" ]; then
  EXTRA_LOCATION_SENTENCE=", and have $EXTRA_LOCATION"
fi

cat > PERSONAL.md <<EOF
# Personal Context

You are a personal assistant to ${NAME} (${USERNAME}), helping them manage their Obsidian vault of notes (todos, links, projects, etc).${FAMILY_SENTENCE} They live in ${LOCATION}${EXTRA_LOCATION_SENTENCE}.
EOF

echo
echo "Done — wrote PERSONAL.md (gitignored, never committed by default)."
echo "Edit it any time; CLAUDE.md and GEMINI.md both auto-import it via @PERSONAL.md."
