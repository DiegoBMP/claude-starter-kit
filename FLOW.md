# Flujo recomendado

```
                      Desarrollo
                          │
                          ▼
                   ┌─────────────┐
                   │  /review    │ ← Code review del cambio
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ /security   │ ← Escaneo OWASP (si hay endpoints/auth)
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ /check-pr   │ ← Verificar diff contra checklist de PR
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ /commit     │ ← Generar mensaje de commit
                   └──────┬──────┘
                          │
                          ▼
                        git push
                        crear PR
                        merge a main
                          │
                          ▼
                   ┌─────────────┐
                   │    /qa      │ ← Tests, E2E, verificar que todo funciona
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │/check-release│ ← Checklist pre-deploy: tags, migraciones, CHANGELOG
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ /changelog  │ ← Generar CHANGELOG.md desde los commits
                   └──────┬──────┘
                          │
                          ▼
                        Deploy
```

## Cuándo usar cada comando

### Modo general (todo el proyecto)

| Cuándo | Qué ejecutás |
|--------|-------------|
| Terminaste una feature | `/review` |
| Vas a hacer un PR | `/review` + `/security` |
| Tocaste datos personales | `/privacy` |
| Querés asegurarte antes de mergear | `/qa` |
| Encontraste un bug | `/debug` |
| Vas a refactorizar | `/refactor` |
| Antes de commitear | `/check-pr` |
| Generar mensaje de commit | `/commit` |
| Antes de deploy | `/security` + `/qa` |
| Checklist pre-deploy | `/check-release` |
| Generar changelog para release | `/changelog` |
| El review encontró issues de seguridad | `/fix-security` |
| El review encontró bugs | `/fix-bugs` |
| Querés arreglarlo todo de una | `/fix-both` |

### Modo foco (un módulo, vista o flujo)

Usá los comandos `-focus` cuando trabajás en algo concreto y querés profundidad, no amplitud. Claude usa codebase-memory para trazar el subgrafo del módulo antes de revisar.

| Cuándo | Qué ejecutás |
|--------|-------------|
| Revisar una vista o servicio en detalle | `/review-focus` |
| Probar un feature o flujo específico | `/qa-focus` |
| Auditar la seguridad de un endpoint o área | `/security-focus` |

## Flujo con foco (una vista o módulo)

```
                   "Necesito revisar la vista X"
                          │
                          ▼
                   ┌─────────────┐
                   │/review-focus│ ← Traza el módulo, revisa en profundidad
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │/security-focus│ ← Si el módulo tiene endpoints/API
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ /qa-focus   │ ← Plan de pruebas del flujo concreto
                   └──────┬──────┘
                          │
                          ▼
                        /commit
```

## Comandos de emergencia

| Si algo sale mal... | Usás |
|---------------------|------|
| Encontraste un bug en producción | `/debug` |
| El review tiró issues de seguridad | `/fix-security` |
| El review tiró bugs | `/fix-bugs` |
| El review tiró de todo | `/fix-both` |

## Antes de cada sesión

`sync-git.sh` se ejecuta **automáticamente** al iniciar Claude Code (hook `SessionStart` en `settings.json`).

# Solo cuando cambió el esquema de BD:

```bash
bash .claude/scripts/dump-schema.sh
```

## Skills recomendadas

Estas skills de Claude Code complementan los commands del kit:

| Skill | Complementa a | Por qué |
|-------|--------------|---------|
| **superpowers:brainstorming** | Antes de empezar una feature | Diseñar antes de codear |
| **superpowers:systematic-debugging** | `/debug` | Depuración con método, no a ciegas |
| **superpowers:test-driven-development** | `/qa` | Escribe tests antes del código |
| **superpowers:verification-before-completion** | `/check-pr` | Verificar antes de decir "listo" |
| **superpowers:finishing-a-development-branch** | `/check-release` | Decide cómo integrar la rama terminada |
| **code-review** | `/review` | Review del diff con niveles de profundidad |
