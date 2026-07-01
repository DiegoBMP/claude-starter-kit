#!/usr/bin/env bash
# demo.sh — Smoke test de los scripts del starter kit
# Ejecutar desde la raíz del repo: bash scripts/demo.sh

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "🧪 Smoke test — Claude Starter Kit"
echo ""

err=0

# sync-local.sh
echo -n "sync-local.sh ... "
bash "$ROOT/scripts/sync-local.sh" > /dev/null 2>&1 && echo "✅" || { echo "❌"; err=1; }

# settings.json es JSON válido
echo -n "settings.json  ... "
if python -c "import json; json.load(open('$ROOT/settings.json'))" 2>/dev/null; then
  echo "✅"
elif python3 -c "import json; json.load(open('$ROOT/settings.json'))" 2>/dev/null; then
  echo "✅"
elif node -e "JSON.parse(require('fs').readFileSync('$ROOT/settings.json','utf8'))" 2>/dev/null; then
  echo "✅ (node)"
else
  echo "⚠️  sin Python/Node — no verificado"
fi

# Cada command tiene su archivo .md
echo -n "commands ↔ .md ... "
grep '"command":' "$ROOT/settings.json" | grep -v '"command": "bash' | \
  sed 's/.*"command": *"\(.*\)".*/\1/' | while read -r cmd; do
    test -f "$ROOT/commands/$cmd.md" || exit 1
  done && echo "✅" || { echo "❌"; err=1; }

# sync-git.sh y dump-schema.sh: sintaxis bash válida
echo -n "sync-git.sh     ... "
bash -n "$ROOT/scripts/sync-git.sh" && echo "✅" || { echo "❌"; err=1; }
echo -n "dump-schema.sh  ... "
bash -n "$ROOT/scripts/dump-schema.sh" && echo "✅" || { echo "❌"; err=1; }
echo -n "update.sh       ... "
bash -n "$ROOT/scripts/update.sh" && echo "✅" || { echo "❌"; err=1; }

echo ""
if [ "$err" -eq 0 ]; then echo "🟢 Todo OK"; else echo "🔴 Hay fallos"; fi
echo ""
