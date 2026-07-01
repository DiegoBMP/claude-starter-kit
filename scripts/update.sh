#!/usr/bin/env bash
# update.sh — Actualiza el kit a la última versión sin tocar CLAUDE.md
# Ejecutar desde la raíz del proyecto: bash .claude/scripts/update.sh
#
# Uso:
#   bash .claude/scripts/update.sh
#   bash .claude/scripts/update.sh https://github.com/usuario/claude-starter-kit/archive/main.tar.gz

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=$(mktemp -d)
KIT_URL="${1:-}"

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

echo ""
echo "🔄 Claude Starter Kit — Actualizador"
echo ""

# ── Descargar ────────────────────────────────────────────────────

if [ -z "$KIT_URL" ]; then
  echo "⚠️  No se especificó URL de descarga."
  echo ""
  echo "   Opciones:"
  echo "   1. Pasar la URL como argumento:"
  echo "      bash .claude/scripts/update.sh https://github.com/diegobmp/claude-starter-kit/archive/main.tar.gz"
  echo ""
  echo "   2. Clonar manualmente y copiar:"
  echo "      git clone <url-del-kit> /tmp/kit-temp"
  echo "      cp /tmp/kit-temp/commands/*.md .claude/commands/"
  echo "      cp /tmp/kit-temp/checklists/*.md  .claude/checklists/"
  echo "      cp /tmp/kit-temp/scripts/*.sh     .claude/scripts/"
  echo "      rm -rf /tmp/kit-temp"
  echo ""
  exit 1
fi

echo "📥 Descargando $KIT_URL ..."
if command -v curl &> /dev/null; then
  curl -sL "$KIT_URL" -o "$TEMP_DIR/kit.tar.gz"
elif command -v wget &> /dev/null; then
  wget -q "$KIT_URL" -O "$TEMP_DIR/kit.tar.gz"
else
  echo "❌ Necesitás curl o wget instalado."
  exit 1
fi

echo "📦 Extrayendo..."
tar xzf "$TEMP_DIR/kit.tar.gz" -C "$TEMP_DIR"
SRC_DIR=$(find "$TEMP_DIR" -maxdepth 2 -name "commands" -type d | head -1 | xargs dirname)

if [ -z "$SRC_DIR" ] || [ ! -d "$SRC_DIR/commands" ]; then
  echo "❌ No se encontró la estructura del kit en el archivo descargado."
  echo "   ¿La URL es correcta? Debería apuntar a un .tar.gz del repo."
  exit 1
fi

# ── Copiar archivos ──────────────────────────────────────────────

echo ""
echo "📋 Copiando archivos..."

# Commands — no pisan si hay comandos locales con el mismo nombre
NEW_COMMANDS=0
for f in "$SRC_DIR/commands/"*.md; do
  name=$(basename "$f")
  if [ "$name" = "README.md" ]; then
    cp "$f" "$KIT_DIR/commands/README.md"
  elif [ ! -f "$KIT_DIR/commands/$name" ]; then
    cp "$f" "$KIT_DIR/commands/"
    echo "   + commands/$name (nuevo)"
    NEW_COMMANDS=$((NEW_COMMANDS + 1))
  else
    cp "$f" "$KIT_DIR/commands/$name"
    echo "   ↻ commands/$name (actualizado)"
  fi
done

# Checklists
for f in "$SRC_DIR/checklists/"*.md; do
  cp "$f" "$KIT_DIR/checklists/"
done
echo "   ✓ checklists/ actualizados"

# Scripts
for f in "$SRC_DIR/scripts/"*.sh; do
  name=$(basename "$f")
  if [ "$name" = "update.sh" ]; then
    cp "$f" "$KIT_DIR/scripts/update.sh"
    echo "   ↻ scripts/update.sh (auto-actualizado)"
  else
    cp "$f" "$KIT_DIR/scripts/$name"
  fi
done
echo "   ✓ scripts/ actualizados"

# ── Settings ──────────────────────────────────────────────────────

echo ""
echo "⚙️  Verificando settings.json..."

if [ -f "$SRC_DIR/settings.json" ] && [ -f "$KIT_DIR/settings.json" ]; then
  # Extraer nombres de comandos nuevos (simple, sin jq)
  grep '"command"' "$SRC_DIR/settings.json" | sed 's/.*"command": *"\(.*\)".*/\1/' | sort > "$TEMP_DIR/new_commands.txt"
  grep '"command"' "$KIT_DIR/settings.json" | sed 's/.*"command": *"\(.*\)".*/\1/' | sort > "$TEMP_DIR/old_commands.txt"

  MISSING=$(comm -23 "$TEMP_DIR/new_commands.txt" "$TEMP_DIR/old_commands.txt")

  if [ -n "$MISSING" ]; then
    echo ""
    echo "   ⚠️  Comandos nuevos que no tenés en tu settings.json:"
    echo ""
    while IFS= read -r cmd; do
      echo "      /$cmd"
    done <<< "$MISSING"
    echo ""
    echo "   🔧 Agregalos manualmente copiando los bloques desde:"
    echo "      $SRC_DIR/settings.json"
    echo ""
  else
    echo "   ✓ settings.json ya tiene todos los comandos"
  fi
fi

# ── CLAUDE.md ─────────────────────────────────────────────────────

echo "   ⚠️  CLAUDE.md NO fue modificado (tiene reglas de tu proyecto)"

# ── Setup ─────────────────────────────────────────────────────────

if [ -f "$SRC_DIR/setup.sh" ]; then
  cp "$SRC_DIR/setup.sh" "$KIT_DIR/setup.sh"
  echo "   ✓ setup.sh actualizado"
fi

echo ""
echo "✅ Kit actualizado."
echo ""
echo "   Comandos nuevos: $NEW_COMMANDS"
echo "   CLAUDE.md: sin cambios"
echo ""
