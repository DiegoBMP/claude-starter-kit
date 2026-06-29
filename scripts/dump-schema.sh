#!/usr/bin/env bash
# dump-schema.sh — Vuelca el esquema de BD a .claude/schema/
# El usuario configura el comando de dump para su motor.
# Ejecutar desde la raíz del proyecto: bash .claude/scripts/dump-schema.sh
#
# ⚠️  Este script solo vuelca ESTRUCTURA (DDL), nunca datos.
#     No incluye INSERTs, credenciales ni información sensible.
#     Si tu comando custom genera datos, usá flags como --schema-only.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
SCHEMA_DIR="$KIT_DIR/schema"
mkdir -p "$SCHEMA_DIR"

# ── Auto-detección ──────────────────────────────────────────────

detect_and_dump() {
  local ROOT
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

  # Prisma
  if [ -f "$ROOT/prisma/schema.prisma" ]; then
    echo "📦 Prisma detectado"
    cp "$ROOT/prisma/schema.prisma" "$SCHEMA_DIR/schema.prisma"
    echo "   → schema.prisma copiado"

    if command -v npx &> /dev/null; then
      npx prisma db pull --print 2>/dev/null > "$SCHEMA_DIR/schema.sql" || true
      echo "   → schema.sql generado (prisma db pull)"
    fi
    return 0
  fi

  # Drizzle
  if ls "$ROOT"/drizzle/*.sql 2>/dev/null || [ -d "$ROOT/drizzle" ]; then
    echo "📦 Drizzle detectado"
    if ls "$ROOT"/drizzle/*.sql 2>/dev/null; then
      cp "$ROOT"/drizzle/*.sql "$SCHEMA_DIR/"
      echo "   → migrations copiadas"
    fi
    cp "$ROOT"/drizzle/*.ts "$SCHEMA_DIR/" 2>/dev/null || true
    return 0
  fi

  # Knex / Knexfile
  if [ -f "$ROOT/knexfile.js" ] || [ -f "$ROOT/knexfile.ts" ] || [ -d "$ROOT/migrations" ]; then
    echo "📦 Knex detectado"
    if [ -d "$ROOT/migrations" ]; then
      cp -r "$ROOT/migrations" "$SCHEMA_DIR/migrations"
      echo "   → migrations/ copiadas"
    fi
    return 0
  fi

  # TypeORM
  if ls "$ROOT"/**/entity/*.ts 2>/dev/null || ls "$ROOT"/src/**/entities/*.ts 2>/dev/null; then
    echo "📦 TypeORM detectado"
    find "$ROOT" -name "*.entity.ts" -o -name "*.entity.js" 2>/dev/null | head -20 | while read -r f; do
      local rel="${f#$ROOT/}"
      mkdir -p "$SCHEMA_DIR/$(dirname "$rel")"
      cp "$f" "$SCHEMA_DIR/$rel"
    done
    echo "   → entities copiadas"
    return 0
  fi

  # Raw SQL
  if ls "$ROOT"/*.sql 2>/dev/null || ls "$ROOT"/sql/*.sql 2>/dev/null; then
    echo "📦 Archivos .sql detectados"
    find "$ROOT" -maxdepth 2 -name "*.sql" -not -path "*/node_modules/*" 2>/dev/null | while read -r f; do
      cp "$f" "$SCHEMA_DIR/"
    done
    echo "   → .sql copiados"
    return 0
  fi

  # pg_dump (si hay DATABASE_URL en el entorno)
  if command -v pg_dump &> /dev/null && [ -n "${DATABASE_URL:-}" ]; then
    echo "📦 pg_dump via DATABASE_URL"
    pg_dump --schema-only --no-owner "$DATABASE_URL" > "$SCHEMA_DIR/schema.sql" 2>/dev/null || true
    echo "   → schema.sql generado"
    return 0
  fi

  return 1
}

# ── Main ─────────────────────────────────────────────────────────

echo ""
echo "🔍 Buscando esquema de base de datos..."

if detect_and_dump; then
  echo ""
  echo "✅ Esquema volcado en $SCHEMA_DIR"
else
  echo "⚠️  No se detectó ningún motor de BD conocido."
  echo ""
  echo "   Agregá tu comando de dump en este script, sección 'Custom':"
  echo ""
  echo "   # PostgreSQL"
  echo "   pg_dump --schema-only mi_db > $SCHEMA_DIR/schema.sql"
  echo ""
  echo "   # MySQL"
  echo "   mysqldump --no-data mi_db > $SCHEMA_DIR/schema.sql"
  echo ""
  echo "   # SQLite"
  echo "   sqlite3 mi.db .schema > $SCHEMA_DIR/schema.sql"
fi
