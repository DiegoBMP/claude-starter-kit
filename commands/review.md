# /review — Code Review completo

## Cuándo usarlo

Antes de un PR, después de implementar una feature, o cuando se necesite una revisión sistemática del código.

## Flujo

1. **Codebase Memory** — entender el contexto del código modificado: arquitectura, dependencias, flujo de datos.
2. **Git diff** — revisar los cambios contra el estado base.
3. **Revisión sistemática** sobre cada archivo modificado:

### Dimensiones

#### 🐛 Bugs & Correctitud
- ¿Hay off-by-one, null pointer, race condition?
- ¿Manejo de errores cubre todos los caminos? (success, error, empty, loading)
- ¿Casos borde cubiertos? (strings vacías, valores límite, IDs inexistentes)
- ¿Validación de entrada con Zod cubre todos los campos?

#### ⚡ Performance
- ¿N+1 queries en loops? (Drizzle: usar `with` o eager loading)
- ¿Faltan índices en columnas usadas en WHERE/ORDER BY/JOIN?
- ¿Render innecesario en React? (memo, useMemo, useCallback solo cuando hay medición)
- ¿Payloads grandes sin paginación?

#### 🏗️ Arquitectura
- ¿Respeta la separación routes → controllers → services → repositories?
- ¿Lógica de negocio en el lugar correcto? (no en controllers, no en DTOs)
- ¿Acoplamiento innecesario entre módulos?
- ¿DTOs usados correctamente en todas las fronteras?

#### 🛡️ Seguridad
- ¿SQL injection posible? (confirmar que no hay raw SQL concatenado)
- ¿JWT validado en cada endpoint protegido?
- ¿CORS configurado correctamente?
- ¿Los errores no filtran información interna (stack traces, SQL, paths)?
- ¿Rate limiting aplicado en endpoints sensibles?

#### 📖 Legibilidad & Mantenibilidad
- ¿Nombres de variables/funciones descriptivos?
- ¿Complejidad ciclomática alta? (funciones > 30 líneas o > 3 niveles de indentación)
- ¿Código duplicado que debería estar en shared?
- ¿Tests ausentes para lógica no trivial?

#### 🔗 Dependencias
- ¿Librerías vulnerables? (npm audit)
- ¿Dependencias no usadas?

## Salida

Generar reporte en este formato:

```
## 📋 Review: <archivo/funcionalidad>

### 🐛 Bugs (N°)
- [ ] <descripción> — <archivo>:<línea>

### ⚡ Performance (N°)
...

### 🏗️ Arquitectura (N°)
...

### 🛡️ Seguridad (N°)
...

### 📖 Legibilidad (N°)
...

### ✅ Veredicto
**🟢 Aprobado** | **🟡 Aprobado con observaciones** | **🔴 Requiere cambios**
```

## Post-review

Después de generar el reporte, preguntar al usuario:

> ¿Quieres que aplique los fixes de alguna categoría?
>
> - `/fix-security` → arregla issues de seguridad (CORS, helmet, auth, rate limiting)
> - `/fix-bugs` → arregla bugs (transacciones, N+1, validaciones)
> - `/fix-both` → arregla todo lo anterior
> - `no` → solo dejar el reporte

Si el usuario elige una opción, ejecutar el comando correspondiente para aplicar los cambios automáticamente.
