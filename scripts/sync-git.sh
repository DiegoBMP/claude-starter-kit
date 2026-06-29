#!/usr/bin/env bash
# sync-git.sh — Actualiza state.md con el estado actual del repo
# Ejecutar desde la raíz del proyecto: bash .claude/scripts/sync-git.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
STATE_FILE="$KIT_DIR/state.md"

NOW=$(date "+%Y-%m-%d %H:%M")
BRANCH=$(git branch --show-current)
REPO=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "?")

cat > "$STATE_FILE" << EOF
# Estado del proyecto — $NOW

**Repo:** $REPO | **Rama:** $BRANCH

## Últimos commits

EOF

git log --format="- **%h** — %s (%an, %ar)" -5 >> "$STATE_FILE"

cat >> "$STATE_FILE" << EOF

## Archivos modificados (working tree)

EOF

if git status --short | grep -v '^?' > /dev/null 2>&1; then
  git status --short | grep -v '^?' | while read -r line; do
    echo "- \`$line\`" >> "$STATE_FILE"
  done
else
  echo "_(nada modificado)_" >> "$STATE_FILE"
fi

cat >> "$STATE_FILE" << EOF

## Archivos nuevos (sin trackear)

EOF

if git status --short | grep '^?' > /dev/null 2>&1; then
  git status --short | grep '^?' | while read -r line; do
    echo "- \`$line\`" >> "$STATE_FILE"
  done
else
  echo "_(nada nuevo)_" >> "$STATE_FILE"
fi

echo "✅ state.md actualizado ($STATE_FILE)"
