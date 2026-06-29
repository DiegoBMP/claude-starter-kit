# /refactor — Refactorización guiada

## Cuándo usarlo

Cuando hay que mejorar código existente sin cambiar su comportamiento: reducir deuda técnica, aplicar patrones, mejorar legibilidad, optimizar rendimiento.

## Flujo

1. **Codebase Memory** — entender la arquitectura actual del código a refactorizar.
   - Trazar dependencias (qué módulos usan esto y de qué depende)
   - Identificar patrones existentes para mantener consistencia
   - Mapear tests existentes

2. **Especificar qué se quiere lograr.**
   - ¿Solo legibilidad?
   - ¿Aplicar un patrón específico? (Repository, Service, DTO)
   - ¿Reducir duplicación?
   - ¿Mejorar performance?
   - ¿Migrar a versión nueva de librería?

3. **Reglas durante la refactorización:**

### 🛡️ No romper nada
- No cambiar comportamiento ni contratos de API.
- No cambiar tipos compartidos sin actualizar todos los consumidores.
- No cambiar nombres de endpoints, estructura de respuestas, o esquemas de BD.
- Los tests existentes deben seguir pasando **sin modificaciones** (a menos que el refactor los mejore).

### 📦 Agrupar cambios
- Un refactor lógico por commit.
- Si se detectan bugs durante el refactor, registrarlos como issue separado, no mezclarlos.

### 🧪 Tests como seguridad
- Si no hay tests, considerar agregarlos antes de refactorizar (golden master / snapshot).
- Si hay tests, ejecutarlos después de cada cambio significativo.

### 📐 Patrones consistentes
- Mantener el estilo del archivo que se modifica.
- Si se refactoriza un módulo completo, alinearlo con el patrón dominante del proyecto:
  - Server: routes → controllers → services → repositories
  - Client: componentes por carpeta (componente, hook, test, styles)
  - Shared: schemas Zod con tipos inferidos

## Salida

```
## 🔧 Refactor Plan

### Objetivo
<qué se va a lograr>

### Archivos afectados
- <archivo> → <cambio>

### Riesgos identificados
- [ ] <riesgo> — mitigación: <cómo>

### Tests de respaldo
- [ ] Tests existentes: <N>
- [ ] Tests nuevos necesarios: <N>

### Commits propuestos
1. `refactor: <mensaje>`
2. `refactor: <mensaje>`

### ✅ Verificación final
- [ ] Compila sin errores
- [ ] Tests pasan
- [ ] No hay cambios de comportamiento
```
