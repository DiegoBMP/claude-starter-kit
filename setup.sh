#!/usr/bin/env bash
# setup.sh — Configuración interactiva del Starter Kit para Claude Code
# Ejecutar desde la raíz del proyecto donde se copió .claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_FILE="$SCRIPT_DIR/CLAUDE.md"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   Claude Starter Kit — Configuración        ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# --- Nombre del proyecto ---
read -r -p "📌 Nombre del proyecto (ej: Servifrenos): " PROJECT_NAME
while [ -z "$PROJECT_NAME" ]; do
  read -r -p "   El nombre no puede estar vacío: " PROJECT_NAME
done

# --- Stack ---
read -r -p "⚙️  Runtime (Node.js | Python | Go | Otro) [Node.js]: " RUNTIME
RUNTIME=${RUNTIME:-Node.js}

read -r -p "📛 Lenguaje (TypeScript | JavaScript | Python | Go) [TypeScript]: " LANG
LANG=${LANG:-TypeScript}

read -r -p "🗄️  Base de datos (PostgreSQL | MySQL | SQLite | MongoDB | Ninguna): " DB
while [ -z "$DB" ]; do
  read -r -p "   Base de datos requerida: " DB
done

read -r -p "🔧 Backend framework (Express | Fastify | NestJS | Django | Gin | Ninguno): " BACKEND
BACKEND=${BACKEND:-Express}

read -r -p "🎨 Frontend framework (React | Vue | Angular | Svelte | Ninguno): " FRONTEND
FRONTEND=${FRONTEND:-React}

read -r -p "🧪 Testing framework (Vitest | Jest | PyTest | Go Test | Ninguno): " TEST_FW
TEST_FW=${TEST_FW:-Vitest}

read -r -p "📦 Package manager (pnpm | npm | yarn | pip | go mod) [pnpm]: " PKG
PKG=${PKG:-pnpm}

# --- Confirmar ---
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   Resumen                                    ║"
echo "╚══════════════════════════════════════════════╝"
echo "  Proyecto:     $PROJECT_NAME"
echo "  Runtime:      $RUNTIME"
echo "  Lenguaje:     $LANG"
echo "  BD:           $DB"
echo "  Backend:      $BACKEND"
echo "  Frontend:     $FRONTEND"
echo "  Testing:      $TEST_FW"
echo "  Package mgr:  $PKG"
echo ""

read -r -p  "¿Es correcto? (S/n): " CONFIRM
if [[ "$CONFIRM" =~ ^[Nn] ]]; then
  echo "❌ Abortado. Vuelve a ejecutar setup.sh"
  exit 1
fi

# --- Generar CLAUDE.md ---
echo ""
echo "📝 Escribiendo CLAUDE.md..."

cat > "$CLAUDE_FILE" << CLAUDEEOF
# $PROJECT_NAME — Reglas del proyecto

## Stack

- **Runtime:** $RUNTIME
- **Lenguaje:** $LANG
- **BD:** $DB
- **Backend:** $BACKEND
- **Frontend:** $FRONTEND
- **Testing:** $TEST_FW
- **Paquetería:** $PKG

## Reglas de código

- **Tipado estricto** (si aplica). Sin \`any\`. Sin casteos forzados.
- **DTOs obligatorios.** Toda comunicación externa usa DTOs. Nunca devolver entidades directamente.
- **Validación de entrada.** Toda entrada de usuario se valida. No confiar en tipos estáticos como única defensa.
- **Separación de capas.** Controllers → Services → Repositories. Los controllers no acceden a la BD.
- **Sin SQL concatenado.** Siempre consultas parametrizadas.
- **UUID.** Preferir UUID sobre autoincrementales en IDs públicos.
- **Fechas en UTC.** Siempre almacenar y transmitir en UTC.

## Seguridad

- **Nunca hardcodear secretos.** Todo en variables de entorno o gestor de secretos.
- **Nunca registrar datos personales en logs.**
- **Hash de contraseñas:** Algoritmo fuerte (bcrypt, Argon2id). Nunca MD5, SHA1.
- **Tokens de acceso:** Expiración corta + refresh rotativo. Claims mínimos.
- **CORS:** Orígenes explícitos. Sin wildcard en producción.
- **HTTPS obligatorio en producción.**
- **OWASP Top 10 + API Top 10 como guía de revisión.**

## Privacidad (Ley 21.719 / GDPR)

- **Minimización de datos.** Solo recopilar lo necesario.
- **Consentimiento explícito** para datos sensibles.
- **Derecho al olvido.** Borrado lógico y físico cuando corresponda.
- **Portabilidad.** El usuario puede exportar sus datos.
- **Auditoría.** Registrar accesos a datos personales.
- **Retención.** Política definida. No acumular indefinidamente.

## Git & Commits

- **Conventional Commits:** \`feat:\`, \`fix:\`, \`refactor:\`, \`chore:\`, \`docs:\`, \`test:\`, \`security:\`, \`privacy:\`.
- **Commits atómicos.** Un cambio lógico por commit.

## Calidad

Antes de dar una tarea por terminada:

1. Verificar que compila.
2. Tests pasan.
3. Revisión de seguridad rápida (usar /security).
4. Revisión de privacidad si hay datos personales (usar /privacy).
5. No hay \`console.log\` olvidados ni \`TODO\` sin issue asociado.

## MCPs (si aplican)

- **Al usar un MCP, anunciarlo brevemente:** "Usando <MCP> para <qué>".
- **Context7:** Consultar antes de usar APIs/librerías que no conozcas bien.
- **Codebase Memory:** Usar para entender arquitectura antes de refactorizar.
- **E2E:** Ejecutar tests end-to-end tras cambios en UI o flujos críticos.
- **GitHub:** PRs, issues, gestión del repositorio.
CLAUDEEOF

echo "✅ CLAUDE.md generado para \"$PROJECT_NAME\""
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ✅ Instalación completa                    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "  CLAUDE.md  → $CLAUDE_FILE"
echo "  Commands   → $(ls \"$SCRIPT_DIR/commands/\" | wc -l) disponibles"
echo "  Checklists → $(ls \"$SCRIPT_DIR/checklists/\" | wc -l) disponibles"
echo ""
echo "  En tu próxima conversación con Claude Code:"
echo "    /review     Code review completo"
echo "    /security   Escaneo de seguridad"
echo "    /privacy    Revisión Ley 21.719 + GDPR"
echo "    /qa         Pruebas estilo QA"
echo "    /debug      Depuración guiada"
echo "    /refactor   Refactorización"
echo ""
