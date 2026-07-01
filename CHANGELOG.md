# Changelog

## v1.0.1 (2026-07-01)

### ✨ Nuevas funcionalidades
- /qa y /qa-focus ejecutan E2E con Playwright MCP en vez de solo checklist (d39bc4d)

### 🐛 Bugs corregidos
- FLOW.md: orden corregido /check-pr → /commit, no al revés
- update.sh no se pisa a sí mismo durante la ejecución (50dcaa4)

## v1.0.0 (2026-07-01)

### ✨ Nuevas funcionalidades
- /improve e /improve-focus: proponen mejoras (simplificación, performance, patrones, robustez) sin aplicarlas (73bd153)
- Comandos -focus: /review-focus, /qa-focus, /security-focus con codebase-memory para revisión por módulo (2f18173)
- /index: indexar proyecto con codebase-memory en un paso (2f18173)
- Sync-git automático al iniciar sesión (hook SessionStart) + guía de contribución CONTRIBUTING.md (1ee8a2d)
- /changelog: genera CHANGELOG.md desde conventional commits (7465d32)
- /check-pr y /check-release: verifican diff/proyecto contra checklists (7465d32)
- FLOW.md: flujo completo desarrollo → deploy + skills recomendadas (7465d32)
- Scripts sync-git.sh y dump-schema.sh: estado del repo y esquema de BD para dar contexto a Claude (596fc5e)
- Kit inicial: 9 commands (review, security, privacy, qa, debug, refactor, fix-security, fix-bugs, fix-both), 4 checklists (pr, release, security, api), setup.sh interactivo (89bd1d2)

### 🔧 Refactorización
- Generalizar kit: quitar herramientas específicas (Zod, Drizzle, JWT, React, pnpm, Playwright) por términos genéricos (48c6489)

### 🐛 Bugs corregidos
- update.sh: no se pisa a sí mismo durante la ejecución (race condition)
- update.sh: validar HTTP status code + magic bytes gzip al descargar
- update.sh: paths por os.environ en vez de interpolación (sin inyección)
- update.sh: extraer usage() al inicio
- README: rm -rf .git antes de cp -r evita nested git repo
- CONTRIBUTING.md: fix markdown roto en template
- dump-schema.sh: local innecesario en subshell (080aa46)

### 📚 Documentación
- README: tabla de contenidos, URLs reales del repo, instalación para proyectos nuevos y existentes
- README: cómo funciona codebase-memory (no es automático), tabla de MCPs por stack + skills
- README: actualización automática (update.sh) y bootstrap curl
- Persistencia en /changelog, /check-pr, /check-release, /improve, /review-focus, /qa-focus, /security-focus, /improve-focus
- setup.sh: CLAUDE.md generado ahora instruye leer reports/
- Bootstrap para primera actualización sin update.sh (07d7dd9)

### 📦 Mantenimiento
- scripts/update.sh: descarga y aplica última versión del kit
- scripts/demo.sh: smoke test (sintaxis bash, JSON, commands ↔ .md)
- scripts/sync-local.sh: una línea para dogfooding
- settings.json: 20 comandos registrados + hook SessionStart
- .gitignore: .claude/, state.md, schema/, reports/
- URLs reales del repo (e6e98b1)
