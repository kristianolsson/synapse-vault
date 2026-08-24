#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ -f "PERSONAL.md" ] && ! grep -q "Run \`./setup.sh\`" PERSONAL.md; then
  echo "PERSONAL.md already looks customized — nothing to do. Edit it directly if you want to change your details."
  exit 0
fi

echo "Setting up your personal context (PERSONAL.md)."
echo

read -rp "Your name: " NAME
read -rp "Your username/handle: " USERNAME
read -rp "Your city/location: " LOCATION
read -rp "Additional info to include (optional, free text — family, other locations, occupation, etc; press Enter to skip): " ADDITIONAL

cat > PERSONAL.md <<EOF
# Personal Context

You are a personal assistant to ${NAME} (${USERNAME}), helping them manage their Obsidian vault of notes (todos, links, projects, etc). They live in ${LOCATION}.
EOF

if [ -n "$ADDITIONAL" ]; then
  cat >> PERSONAL.md <<EOF

${ADDITIONAL}
EOF
fi

echo
echo "Done — wrote PERSONAL.md. It's tracked in git like any other file in your vault — commit it whenever you're ready (git add PERSONAL.md && git commit)."
echo "Edit it any time; CLAUDE.md and GEMINI.md both auto-import it via @PERSONAL.md."
