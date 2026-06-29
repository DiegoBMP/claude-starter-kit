# Claude Starter Kit

Kit de configuración profesional para Claude Code con commands de review, seguridad, privacidad, QA, debug y refactor.

## Instalación en un proyecto nuevo

```bash
# 1. Copiar la carpeta al proyecto
cp -r .claude-starter-kit/ ruta/de/tu/proyecto/.claude/

# 2. Pararte en la raíz del proyecto y ejecutar el setup
cd ruta/de/tu/proyecto
bash .claude/setup.sh

# 3. Responder las preguntas y listo
```

## Contenido

```
.claude/
├── CLAUDE.md         ← Reglas del proyecto (editar después del setup)
├── settings.json     ← Comandos registrados: /review, /security, /privacy, /qa, /debug, /refactor
├── setup.sh          ← Script de configuración interactiva
├── scripts/
│   ├── sync-git.sh     ← Actualiza state.md con últimos commits y archivos modificados
│   └── dump-schema.sh  ← Vuelca esquema de BD a schema/ (Prisma, Drizzle, Knex, SQL...)
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
│   └── commit.md       ← Genera mensaje de commit Conventional Commits
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

## Scripts de automatización

Antes de cada sesión con Claude Code, ejecutá desde la raíz del proyecto:

```bash
# Actualizar estado del repo (commits recientes, archivos modificados)
bash .claude/scripts/sync-git.sh

# Volcar esquema de BD para que Claude conozca las tablas y columnas
bash .claude/scripts/dump-schema.sh
```

`sync-git.sh` escribe `.claude/state.md` — Claude lo lee al iniciar y sabe exactamente en qué estabas trabajando.

`dump-schema.sh` auto-detecta Prisma, Drizzle, Knex, TypeORM o archivos `.sql` y los copia a `.claude/schema/`.

## Requisitos

- Claude Code instalado
- Los MCPs que uses (codebase-memory, context7, playwright, etc.)
