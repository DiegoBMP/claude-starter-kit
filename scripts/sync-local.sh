#!/usr/bin/env bash
# sync-local.sh — Sincroniza archivos de la raíz a .claude/ para dogfooding
# Solo útil mientras desarrollamos el starter kit.
# Ejecutar desde la raíz del repo: bash scripts/sync-local.sh

set -e

cp settings.json .claude/
cp commands/*.md .claude/commands/
cp checklists/*.md .claude/checklists/
cp scripts/*.sh .claude/scripts/

echo "✅ .claude/ sincronizado"
