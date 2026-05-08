#!/usr/bin/env bash
# ============================================================================
# publish-all.sh
#
# Re-renders + re-publishes every hello_*_v2.qmd to its Netlify site.
# `_publish.yml` remembers which site belongs to which deck — so you don't
# have to re-pick anything.
#
# Usage:
#   bash publish-all.sh                 # publish ALL v2 decks
#   bash publish-all.sh hello_lasso_v2  # publish ONE deck (no .qmd needed)
# ============================================================================

set -e

# If a deck name is passed as an argument, only publish that one.
if [ "$#" -gt 0 ]; then
    DECKS=("$1.qmd")
else
    DECKS=(hello_*_v2.qmd)
fi

echo "🎨 Publishing ${#DECKS[@]} deck(s) to Netlify..."
echo ""

for f in "${DECKS[@]}"; do
    echo "────────────────────────────────────────────────────"
    echo "📦  $f"
    echo "────────────────────────────────────────────────────"
    quarto publish netlify "$f" --no-prompt
    echo ""
done

echo "✨  Done. URLs are listed in _publish.yml"
