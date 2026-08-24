#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ -f "PERSONAL.md" ]; then
  echo "PERSONAL.md already exists — nothing to do. Edit it directly if you want to change your details."
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

if [ -f ".gitignore" ] && grep -qxF "PERSONAL.md" .gitignore; then
  grep -vxF -e '# Personal context — never committed in this template repo' -e 'PERSONAL.md' .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore
  echo
  echo "Done — wrote PERSONAL.md, and un-ignored it in .gitignore (this is your vault now, not the public template — go ahead and commit it: git add PERSONAL.md .gitignore && git commit -m \"Track PERSONAL.md\")."
else
  echo
  echo "Done — wrote PERSONAL.md."
fi

echo "Edit it any time; CLAUDE.md and GEMINI.md both auto-import it via @PERSONAL.md."
