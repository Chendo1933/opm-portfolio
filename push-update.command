#!/bin/bash

# ─────────────────────────────────────────
#  O.P.M. Dashboard — Push Update
#  Double-click to deploy latest changes to GitHub Pages
# ─────────────────────────────────────────

cd "/Users/colehenderson/O.P.M."

git add -A
git diff --staged --quiet || git commit -m "update dashboard - $(date '+%Y-%m-%d %H:%M')"
git pull --rebase
git push

echo ""
echo "✅  Done — changes live at https://chendo1933.github.io/opm-portfolio/"
echo "   (GitHub Pages may take ~60 seconds to reflect updates)"
echo ""
read -p "Press Enter to close…"
