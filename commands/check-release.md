# /check-release — Verificar release contra checklist de deploy

## Cuándo usarlo

Antes de hacer un deploy a producción, para verificar que todo está listo según la checklist de release.

## Flujo

1. Leer `.claude/checklists/release.md` — contiene los items a verificar.
2. Recopilar estado del proyecto:
   - `git branch --show-current` y `git log --oneline -5`
   - `git tag --sort=-v:refname | head -3` (últimos tags)
   - `git status --short`
   - Leer `package.json` (versión actual)
   - Leer `CHANGELOG.md` si existe
3. Recorrer **cada checkbox** de la checklist y evaluarlo:

### Reglas de evaluación por sección

**🔄 Preparación:**
- "Rama main actualizada y compila": verificar que estamos en main y el working tree está limpio.
- "Version bump (semver)": comparar versión en `package.json` con el último tag.
- "CHANGELOG / release notes actualizados": verificar si existe y menciona la versión actual.
- "Tags git": verificar si hay un tag para la versión actual.
- "Tests pasan en CI": no verificable automáticamente, marcar como ⚠️.
- "Auditoría de dependencias sin vulnerabilidades": sugerir ejecutarla.

**🗄️ Base de datos:**
- "Migraciones listas y probadas": buscar archivos de migración nuevos en el diff.
- "Migraciones forward y rollback verificados": no verificable automáticamente, ⚠️.
- "Backup de BD realizado": no verificable, ⚠️.

**⚙️ Configuración:**
- "Variables de entorno actualizadas": buscar cambios en `.env.example` o schema de env.
- "Secretos rotados si necesario": ⚠️.
- "URLs/endpoints de producción correctos": buscar URLs hardcodeadas en el diff.
- "CORS con orígenes de producción": verificar configuración CORS.

**🐳 Deploy:**
- "Docker image construida y etiquetada": buscar `Dockerfile`, verificar si se construyó.
- "Health check endpoint responde": no verificable, ⚠️.
- "Logs sin errores": no verificable, ⚠️.

**🧪 Smoke test post-deploy:**
- Todos los items son ⚠️ (requieren deploy activo para verificar).

**📊 Monitoreo:**
- ⚠️ items requieren acceso a dashboards.

**🔙 Rollback plan:**
- "Comando/script de rollback definido": buscar script de rollback en el proyecto.
- "Último tag estable identificado": mostrar los últimos 3 tags.

## Salida

```
## 🚀 /check-release — Resultado

### 🔄 Preparación
- [x] Rama main actualizada
- [ ] Version bump — ⚠️ package.json dice 1.2.0 pero el último tag es v1.1.0 (¿falta tag?)
- [x] CHANGELOG actualizado para v1.2.0
- [ ] Tags git — ❌ No hay tag v1.2.0. Ejecutá: git tag v1.2.0 && git push origin v1.2.0
- [ ] Tests en CI — ⚠️ Verificar en GitHub Actions
- [ ] Auditoría de dependencias — ⚠️ Ejecutar `npm audit` o equivalente

### 🗄️ Base de datos
- [x] Migraciones listas (3 nuevas detectadas)
- [ ] Forward/rollback verificados — ⚠️ Probar en staging
- [ ] Backup — ⚠️ Confirmar con DevOps

### ⚙️ Configuración
- [x] .env.example actualizado con nuevas variables
- [x] URLs de producción correctas
- [x] CORS configurado con orígenes explícitos

### 📊 Resumen
**✅ 15/31 pasan | ⚠️ 14 requieren verificación manual | ❌ 2 críticos**

### ❌ Críticos (bloquean deploy)
1. **Tag git ausente** — Crear tag v1.2.0 antes del deploy
2. **Versión sin tag** — El version bump no tiene tag correspondiente

### ⚠️ Verificación manual requerida
1. Tests en CI — revisar en GitHub Actions
2. Forward/rollback de migraciones — probar en staging
3. Backup de BD — confirmar con DevOps
...
```

## Reglas importantes

- Este comando **no ejecuta nada**, solo verifica. No hace deploy, no corre migraciones, no crea tags.
- Ítems marcados ⚠️ requieren acción manual. No intentar "adivinarlos".
- Si detectás un ❌ crítico, destacarlo claramente como bloqueante.
- Si el proyecto no tiene CI/Docker/BD, ignorar esas secciones (N/A).
