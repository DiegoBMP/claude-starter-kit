#!/usr/bin/env bash
# update.sh — Actualiza el kit a la última versión sin tocar CLAUDE.md
# Ejecutar desde la raíz del proyecto: bash .claude/scripts/update.sh
#
# Uso:
#   bash .claude/scripts/update.sh <url-del-tar.gz>

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=$(mktemp -d)
KIT_URL="${1:-}"

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

usage() {
  echo "🔄 Claude Starter Kit — Actualizador"
  echo ""
  echo "Uso:"
  echo "  bash .claude/scripts/update.sh <url-del-tar.gz>"
  echo ""
  echo "Ejemplo:"
  echo "  bash .claude/scripts/update.sh https://github.com/diegobmp/claude-starter-kit/archive/main.tar.gz"
  echo ""
  echo "Alternativa manual:"
  echo "  git clone <url-del-kit> /tmp/kit-temp"
  echo "  cp /tmp/kit-temp/commands/*.md .claude/commands/"
  echo "  cp /tmp/kit-temp/checklists/*.md  .claude/checklists/"
  echo "  cp /tmp/kit-temp/scripts/*.sh     .claude/scripts/"
  echo "  rm -rf /tmp/kit-temp"
}

if [ -z "$KIT_URL" ]; then
  usage
  exit 1
fi

# ── Descargar ────────────────────────────────────────────────────

echo ""
echo "🔄 Claude Starter Kit — Actualizador"
echo ""

echo "📥 Descargando $KIT_URL ..."
HTTP_CODE=""
if command -v curl &> /dev/null; then
  HTTP_CODE=$(curl -sL -o "$TEMP_DIR/kit.tar.gz" -w "%{http_code}" "$KIT_URL")
elif command -v wget &> /dev/null; then
  wget -q --server-response "$KIT_URL" -O "$TEMP_DIR/kit.tar.gz" 2>&1 | awk '/HTTP\// {print $2}' | tail -1 > "$TEMP_DIR/http_code.txt"
  HTTP_CODE=$(cat "$TEMP_DIR/http_code.txt" 2>/dev/null || echo "000")
else
  echo "❌ Necesitás curl o wget instalado."
  exit 1
fi

if [ "${HTTP_CODE:0:1}" != "2" ] && [ "${HTTP_CODE:0:1}" != "3" ]; then
  echo "❌ Error HTTP $HTTP_CODE al descargar. ¿La URL es correcta?"
  exit 1
fi

# Validar que sea un archivo comprimido real
if ! file "$TEMP_DIR/kit.tar.gz" 2>/dev/null | grep -qE 'gzip|tar'; then
  # file no siempre está disponible, fallback: chequear magic bytes gzip (1f 8b)
  if ! head -c2 "$TEMP_DIR/kit.tar.gz" | grep -q $'\x1f\x8b'; then
    echo "❌ El archivo descargado no es un .tar.gz válido."
    echo "   ¿La URL apunta a un release .tar.gz del repo?"
    exit 1
  fi
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

    # Auto-merge con Python si está disponible
    if command -v python3 &> /dev/null || command -v python &> /dev/null; then
      PYTHON=$(command -v python3 || command -v python)
      echo ""
      echo "   🔧 Haciendo merge automático (Python)..."
      cp "$KIT_DIR/settings.json" "$KIT_DIR/settings.json.bak"

      SRC_SETTINGS="$SRC_DIR/settings.json" \
      DST_SETTINGS="$KIT_DIR/settings.json" \
      "$PYTHON" -c "
import os, json
src_path = os.environ['SRC_SETTINGS']
dst_path = os.environ['DST_SETTINGS']

with open(src_path) as f: src = json.load(f)
with open(dst_path) as f: dst = json.load(f)

added = 0
for name, block in src.get('commands', {}).items():
    if name not in dst.get('commands', {}):
        dst['commands'][name] = block
        added += 1
        print(f'      + /{name}')

# Hooks también
if 'hooks' in src:
    if 'hooks' not in dst:
        dst['hooks'] = {}
    for hook_name, hook_cmds in src['hooks'].items():
        if hook_name not in dst['hooks']:
            dst['hooks'][hook_name] = hook_cmds
            print(f'      + hook: {hook_name}')

with open(dst_path, 'w') as f:
    json.dump(dst, f, indent=2, ensure_ascii=False)
    f.write('\n')

print(f'   ✅ {added} comandos agregados (backup en settings.json.bak)')
"
    else
      echo ""
      echo "   🔧 Agregalos manualmente copiando los bloques desde:"
      echo "      $SRC_DIR/settings.json"
    fi
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
