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
├── commands/
│   ├── review.md       ← Code review completo
│   ├── security.md     ← Escaneo OWASP Top 10 + API Top 10
│   ├── privacy.md      ← Ley 21.719 + GDPR
│   ├── qa.md           ← Pruebas estilo QA (unitarias, integración, Playwright)
│   ├── debug.md        ← Depuración guiada
│   ├── refactor.md     ← Refactorización sin romper nada
│   ├── fix-security.md ← 🔧 Aplica fixes de seguridad automáticos
│   ├── fix-bugs.md     ← 🔧 Aplica fixes de bugs automáticos
│   └── fix-both.md     ← 🔧 Aplica seguridad + bugs de una
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
| `/qa` | Plan de pruebas estilo QA + Playwright |
| `/debug` | Debug guiado paso a paso |
| `/refactor` | Refactorización con red de seguridad |
| `/fix-security` | 🔧 Aplica fixes de seguridad: CORS, helmet, rate limiting |
| `/fix-bugs` | 🔧 Aplica fixes de bugs: transacciones, state machine, N+1 |
| `/fix-both` | 🔧 Aplica seguridad + bugs en un solo comando |

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

## Requisitos

- Claude Code instalado
- Node.js (para proyectos JS/TS)
- Los MCPs que uses (codebase-memory, context7, playwright, etc.)
