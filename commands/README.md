# Comandos disponibles

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
| `/commit` | Genera mensaje de commit Conventional Commits |
| `/changelog` | Genera CHANGELOG.md desde commits desde el último tag |
| `/check-pr` | ✅ Verifica el diff contra la checklist de PR automáticamente |
| `/check-release` | 🚀 Verifica el proyecto contra la checklist de release |
| `/review-focus` | 🔍 Review profundo de un módulo, vista o flujo específico |
| `/qa-focus` | 🧪 QA enfocado en un feature o flujo concreto |
| `/security-focus` | 🛡️ Auditoría de seguridad de un endpoint o área específica |

# ¿Cuándo usar cada comando?

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
| Terminaste cambios y quieres commit | `/commit` |
| Vas a hacer un release, generar changelog | `/changelog` |
| Antes de commitear, verificar checklist | `/check-pr` |
| Antes de deployar a producción | `/check-release` |
| Revisar una vista o servicio en detalle | `/review-focus` |
| Probar un feature o flujo específico | `/qa-focus` |
| Auditar seguridad de un endpoint concreto | `/security-focus` |
