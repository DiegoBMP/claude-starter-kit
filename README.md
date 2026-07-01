# Claude Starter Kit

Kit de configuración profesional para Claude Code con commands de review, seguridad, privacidad, QA, debug y refactor.

## Instalación

### En un proyecto nuevo

```bash
# 1. Clonar el starter kit
git clone https://github.com/diegobmp/claude-starter-kit.git claude-starter-kit

# 2. Copiar a tu proyecto como .claude/
rm -rf claude-starter-kit/.git       # evita nested repo
cp -r claude-starter-kit/ mi-proyecto/.claude/

# 3. Ejecutar el setup interactivo
cd mi-proyecto
bash .claude/setup.sh
```

### En un proyecto ya iniciado

Si ya tenés un proyecto con su propio `CLAUDE.md` y configuración, no querés pisar lo que ya existe. Lo recomendado es copiar solo las partes que necesitás:

```bash
# 1. Clonar el starter kit
git clone https://github.com/diegobmp/claude-starter-kit.git claude-starter-kit

# 2. Copiar commands, checklists y scripts (no pisan nada tuyo)
cp claude-starter-kit/commands/*.md mi-proyecto/.claude/commands/
cp claude-starter-kit/checklists/*.md mi-proyecto/.claude/checklists/
cp claude-starter-kit/scripts/*.sh mi-proyecto/.claude/scripts/

# 3. Fusionar settings.json sin perder tus comandos
#    Manual: copiá los bloques de comandos nuevos del settings.json del kit
#    a tu .claude/settings.json existente

# 4. CLAUDE.md — solo agregá las secciones que te sirvan
#    (seguridad, privacidad, MCPs) al final de tu CLAUDE.md actual

# 5. Limpiar
rm -rf claude-starter-kit
```

**Qué conviene copiar según el tamaño del proyecto:**

| Si tu proyecto... | Copiá |
|-------------------|-------|
| No tiene `CLAUDE.md` | Todo, ejecutar `setup.sh` |
| Tiene `CLAUDE.md` básico | Commands + checklists + scripts, fusionar settings |
| Ya tiene commands propios | Solo checklists + scripts |
| Está muy maduro | Solo `scripts/sync-git.sh` y `checklists/security.md` |

## Actualizar un proyecto que ya tiene el kit

### Automático (recomendado)

Desde la raíz de tu proyecto:

```bash
bash .claude/scripts/update.sh https://github.com/diegobmp/claude-starter-kit/archive/main.tar.gz
```

El script descarga la última versión, copia commands/checklists/scripts actualizados, detecta comandos nuevos que faltan en tu `settings.json` y **no toca tu `CLAUDE.md`**.

### Manual (si no hay conexión o el script no aplica)

```bash
git clone https://github.com/diegobmp/claude-starter-kit.git claude-starter-kit-temp
cp claude-starter-kit-temp/commands/*.md   .claude/commands/
cp claude-starter-kit-temp/checklists/*.md .claude/checklists/
cp claude-starter-kit-temp/scripts/*.sh    .claude/scripts/
# Fusionar settings.json manualmente
rm -rf claude-starter-kit-temp
```

| Archivo | ¿Sobrescribir? | Por qué |
|---------|---------------|---------|
| `commands/*.md` | ✅ Sí | Son genéricos, no los personalizaste |
| `checklists/*.md` | ✅ Sí | Ídem |
| `scripts/*.sh` | ✅ Sí | Ídem |
| `settings.json` | 🔀 Fusionar | Solo agregar bloques de comandos nuevos |
| `CLAUDE.md` | ❌ No | Tiene reglas específicas de tu proyecto |
| `state.md` | ❌ No | Es generado automático, propio del proyecto |

## Contenido

```
.claude/
├── CLAUDE.md         ← Reglas del proyecto (editar después del setup)
├── settings.json     ← Comandos registrados: /review, /security, /privacy, /qa, /debug, /refactor
├── setup.sh          ← Script de configuración interactiva
├── scripts/
│   ├── sync-git.sh     ← Actualiza state.md con últimos commits y archivos modificados
│   ├── dump-schema.sh  ← Vuelca esquema de BD a schema/ (Prisma, Drizzle, Knex, SQL...)
│   └── update.sh       ← Descarga y aplica la última versión del kit
├── commands/
│   ├── review.md       ← Code review completo
│   ├── security.md     ← Escaneo OWASP Top 10 + API Top 10
│   ├── privacy.md      ← Ley 21.719 + GDPR
│   ├── qa.md           ← Pruebas estilo QA (unitarias, integración, E2E)
│   ├── debug.md        ← Depuración guiada
│   ├── refactor.md     ← Refactorización sin romper nada
│   ├── fix-security.md ← 🔧 Aplica fixes de seguridad automáticos
│   ├── fix-bugs.md     ← 🔧 Aplica fixes de bugs automáticos
│   ├── fix-both.md     ← 🔧 Aplica seguridad + bugs de una
│   ├── check-pr.md     ← ✅ Verifica diff contra checklist de PR
│   ├── check-release.md← 🚀 Verifica proyecto contra checklist de release
│   ├── commit.md       ← Genera mensaje de commit Conventional Commits
│   ├── review-focus.md ← 🔍 Review profundo de un módulo/vista específico
│   ├── qa-focus.md     ← 🧪 QA enfocado en un feature o flujo concreto
│   └── security-focus.md← 🛡️ Auditoría de seguridad de un área específica
└── checklists/
    ├── pr.md         ← Checklist antes del merge
    ├── release.md    ← Checklist antes del deploy
    ├── security.md   ← Checklist OWASP detallado
    └── api.md        ← Checklist de diseño de APIs
```

## Comandos disponibles

| Comando | Descripción |
|---------|-------------|
| `/review` | Code review completo: bugs, performance, arquitectura, seguridad |
| `/security` | Escaneo de seguridad OWASP |
| `/privacy` | Revisión Ley 21.719 + GDPR |
| `/qa` | Plan de pruebas estilo QA + E2E |
| `/debug` | Debug guiado paso a paso |
| `/refactor` | Refactorización con red de seguridad |
| `/fix-security` | 🔧 Aplica fixes de seguridad: CORS, helmet, rate limiting |
| `/fix-bugs` | 🔧 Aplica fixes de bugs: transacciones, state machine, N+1 |
| `/fix-both` | 🔧 Aplica seguridad + bugs en un solo comando |
| `/check-pr` | ✅ Verifica el diff contra la checklist de PR automáticamente |
| `/check-release` | 🚀 Verifica el proyecto contra la checklist de release antes de deploy |
| `/commit` | Genera mensaje de commit Conventional Commits |
| `/changelog` | Genera CHANGELOG.md desde commits desde el último tag |
| `/review-focus` | 🔍 Review profundo de un módulo, vista o flujo específico |
| `/qa-focus` | 🧪 QA enfocado en un feature o flujo concreto |
| `/security-focus` | 🛡️ Auditoría de seguridad de un endpoint o área específica |

## ¿Cuándo usar cada comando?

| Cuándo | Qué ejecutas |
|--------|-------------|
| Terminaste una feature | `/review` |
| Vas a hacer un PR | `/review` + `/security` |
| Tocaste datos personales | `/privacy` |
| Quieres asegurarte antes de mergear | `/qa` |
| Encontraste un bug | `/debug` |
| Vas a refactorizar | `/refactor` |
| Antes de deploy | `/security` + `/qa` |
| Dudas de seguridad en un endpoint nuevo | `/security` |
| Revisión rápida antes de commit | `/review` |
| El review encontró issues de seguridad | `/fix-security` |
| El review encontró bugs | `/fix-bugs` |
| Quieres arreglarlo todo de una | `/fix-both` |
| Antes de commitear, verificar checklist | `/check-pr` |
| Antes de deployar a producción | `/check-release` |
| Generar changelog para release | `/changelog` |
| Revisar un módulo o vista en detalle | `/review-focus` |
| Probar un feature o flujo concreto | `/qa-focus` |
| Auditar seguridad de un endpoint específico | `/security-focus` |

## Scripts de automatización

`sync-git.sh` se ejecuta **automáticamente** al iniciar Claude Code (vía hook `SessionStart` en `settings.json`). Escribe `.claude/state.md` con los últimos commits y archivos modificados.

`dump-schema.sh` se ejecuta manualmente cuando cambia el esquema de BD:

```bash
bash .claude/scripts/dump-schema.sh
```

Auto-detecta Prisma, Drizzle, Knex, TypeORM o archivos `.sql` y los copia a `.claude/schema/`.

## MCPs recomendados por stack

| MCP | ¿Para qué? | Cuándo instalarlo |
|-----|-----------|-------------------|
| **codebase-memory** | Trazar código: call graph, arquitectura, dependencias | Siempre |
| **context7** | Buscar docs de librerías sin salir del editor | Siempre |
| **GitHub** | PRs, issues, CI/CD desde Claude Code | Siempre |
| **Playwright** | Tests E2E en navegador real | Proyectos con UI (React, Vue, Svelte...) |
| **Postgres** | Consultas directas a BD, explorar tablas | Proyectos con PostgreSQL |
| **Brave Search** | Búsqueda web sin salir del editor | Cuando necesitás info actualizada |
| **Docker** | Gestionar contenedores desde Claude Code | Proyectos con Docker |
| **Firebase** | Firestore, Auth, Functions | Proyectos con Firebase |
| **Supabase** | BD, Auth, Edge Functions | Proyectos con Supabase |
| **Cloudflare** | Workers, KV, R2, D1 | Proyectos en Cloudflare |
| **Vercel** | Deploy, preview URLs, logs | Proyectos hosteados en Vercel |

### Cómo funciona codebase-memory

A pesar del nombre "memory", **no guarda conversaciones ni recuerda decisiones**. Es un grafo de tu código:

1. **Indexar** — La primera vez en un proyecto, pedile a Claude: _"indexá este repositorio con codebase-memory"_. Escanea cada archivo con LSP, construye un grafo (funciones → llamadas → rutas → flujo de datos). El índice persiste en disco. No es automático.
2. **Consultar** — En cualquier sesión Claude usa `search_graph`, `trace_path`, `get_code_snippet` para navegar tu código sin leer archivos a ciegas.
3. **Actualizar** — Cuando el código cambia, `detect_changes` encuentra qué re-indexar. No hace falta indexar todo de nuevo.

Los comandos `-focus` (`/review-focus`, `/qa-focus`, `/security-focus`) lo usan intensivo para trazar el subgrafo del módulo que estás revisando.

## Skills recomendadas

Estas skills complementan los commands del kit. Instalarlas con `/install-skill <nombre>`:

| Skill | Complementa a | Por qué |
|-------|--------------|---------|
| **superpowers:brainstorming** | Antes de empezar una feature | Diseñar antes de codear |
| **superpowers:systematic-debugging** | `/debug` | Depuración con método, no a ciegas |
| **superpowers:test-driven-development** | `/qa` | Escribe tests antes del código |
| **superpowers:verification-before-completion** | `/check-pr` | Verificar antes de decir "listo" |
| **superpowers:finishing-a-development-branch** | `/check-release` | Decide cómo integrar la rama terminada |
| **code-review** | `/review` | Review del diff con niveles de profundidad |

## Requisitos

- Claude Code instalado
