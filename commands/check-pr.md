# /check-pr — Verificar diff contra checklist de PR

## Cuándo usarlo

Antes de hacer commit o push, para verificar que los cambios pasan la checklist de PR automáticamente.

## Flujo

1. Leer `.claude/checklists/pr.md` — contiene los items a verificar.
2. Obtener el diff a revisar:
   - Si hay cambios en staging (`git diff --staged`), usar esos.
   - Si no, usar `git diff` (unstaged).
3. Recorrer **cada checkbox** de la checklist y evaluarlo contra el diff:

### Reglas de evaluación por sección

**🔍 Before submitting:**
- "Código compila": revisar si hay errores de tipo obvios en el diff (imports rotos, tipos que no matchean).
- "Tests pasan": si el diff toca tests, verificar que no hay tests rotos o `test.skip`.
- "Sin console.log / debugger / TODO sin issue": buscar en el diff.
- "Sin secretos hardcodeados": buscar patrones como `password=`, `apiKey=`, `secret=`, `token=` en el diff.
- "Conventional commit": revisar el mensaje del último commit.

**🏗️ Arquitectura:**
- "Respeta separación routes → controllers → services → repositories": si el diff toca controllers, verificar que no accedan a BD directamente.
- "DTOs usados en fronteras": verificar que las respuestas de API usen DTOs, no entidades.
- "Sin acceso a BD desde controllers": buscar imports de BD en archivos controller.
- "Sin lógica de negocio en capa de presentación": revisar componentes sin reglas de negocio inline.

**🛡️ Seguridad:**
- "Toda entrada validada": buscar si hay nuevos endpoints sin schema de validación en runtime.
- "Sin SQL concatenado": buscar patrones de string interpolation en queries.
- "Auth validada en endpoints protegidos": verificar nuevos endpoints con middleware de auth.
- "Permisos verificados": buscar si nuevos endpoints tienen check de rol/permiso.
- "Errores no filtran stack traces": verificar que los catch no devuelvan `err.stack`.
- "CORS configurado": si hay cambios en CORS, verificar orígenes explícitos.

**🔒 Privacidad:**
- "No se registran datos personales en logs": buscar `console.log` o `logger.*` con campos sensibles (email, nombre, dni, teléfono, dirección).
- "No se exponen datos sensibles en respuestas": verificar DTOs de respuesta que no incluyan password, token, etc.
- "Datos mínimos en payloads": revisar si hay selects `*` innecesarios.

**📦 Dependencias:**
- "Sin dependencias nuevas sin revisar": detectar cambios en `package.json`.
- "Sin dependencias con vulnerabilidades": si hay cambios en `package.json`, sugerir correr auditoría.

**🧪 Tests:**
- "Cobertura para el nuevo código": verificar si hay nuevo código sin tests correspondientes.
- "Casos borde cubiertos": revisar si los tests solo cubren happy path.
- "Tests existentes no rotos": detectar tests modificados que puedan haberse debilitado.

**📚 Documentación:**
- "README actualizado si cambió configuración": detectar cambios en config que no tengan su reflejo en docs.
- "Tipos actualizados en shared/": si el diff toca tipos, verificar consistencia.

## Salida

```
## ✅ /check-pr — Resultado

### 🔍 Before submitting
- [x] Código compila sin errores
- [ ] Tests pasan — ⚠️ No se puede verificar automáticamente, ejecutalos manualmente
- [x] Sin console.log / debugger / TODO sin issue
- [x] Sin secretos hardcodeados
- [ ] Conventional commit — ⚠️ El último commit no sigue el formato

### 🏗️ Arquitectura
- [x] Respeta separación de capas
- [x] DTOs usados en fronteras
- ...

### 📊 Resumen
**✅ 18/22 pasan | ⚠️ 4 requieren atención | ❌ 0 críticos**

### ⚠️ Items que requieren atención
1. **Tests pasan** — Ejecutá los tests y confirmá manualmente
2. **Conventional commit** — El commit "fix cosas" no sigue el formato `tipo(scope): desc`
3. ...

¿Querés que intente arreglar los ⚠️ automáticamente?
```

## Reglas importantes

- **No inventar.** Si un item no se puede verificar desde el diff, marcarlo como ⚠️ "requiere verificación manual".
- **No alarmar sin evidencia.** Si no ves el problema en el diff, no lo reportes.
- **Ser específico.** Cada hallazgo debe señalar el archivo y línea concreto.
- **Solo revisar lo modificado.** No auditar todo el proyecto, solo el diff.
