# /improve — Proponer mejoras al código

## Cuándo usarlo

Cuando querés identificar oportunidades de mejora en el código que no son bugs: simplificación, performance, patrones más limpios, deuda técnica.

A diferencia de `/review` (busca bugs y problemas) y `/refactor` (ejecuta un refactor planeado), `/improve` **propone** mejoras concretas sin aplicarlas. Sos vos quien decide cuáles implementar.

## Flujo

### 1. Definir el scope

Preguntar al usuario:

> ¿Qué querés mejorar?
>
> - Un módulo/vista: "el servicio de órdenes"
> - Un archivo: "auth.service.ts"
> - Todo el proyecto: "el repo entero"

### 2. Analizar el código

Usar codebase-memory para entender el contexto. Si el scope es un módulo, usar `trace_path` para mapear dependencias. Si es el proyecto entero, usar `get_architecture` y `search_graph` con patrones de complejidad.

### 3. Buscar oportunidades por dimensión

#### 🧹 Simplificación
- ¿Funciones que hacen más de una cosa? (Split)
- ¿Código duplicado entre archivos? (DRY)
- ¿Condicionales anidados que podrían ser early returns?
- ¿Clases con un solo método que deberían ser funciones?
- ¿Abstracciones innecesarias? (interfaces con una sola implementación)

#### ⚡ Performance
- ¿N+1 queries detectables en el grafo?
- ¿Cálculos repetidos que deberían cachearse?
- ¿Archivos grandes que deberían tener lazy loading?
- ¿Queries sin índices en columnas de filtro/orden?

#### 🏗️ Patrones
- ¿Oportunidades para aplicar patrones?: Strategy en vez de if/else gigante, Repository donde se accede a BD directo, Observer para desacoplar eventos
- ¿Tipos débiles? (`any`, `as`, `string` en vez de union type)

#### 🛡️ Robustez
- ¿Faltan timeouts en llamadas externas?
- ¿Retry policies en operaciones que pueden fallar?
- ¿Circuit breakers para dependencias externas?
- ¿Validación de esquemas en runtime en fronteras?

#### 📦 Mantenibilidad
- ¿Archivos > 300 líneas que deberían dividirse?
- ¿Funciones > 50 líneas?
- ¿Tests ausentes para lógica crítica?
- ¿Comentarios que explican "qué" en vez de "por qué"?

### 4. Generar reporte

```
## 💡 Mejoras propuestas para <scope>

### 🧹 Simplificación (N)
- [ ] **<título>** — <archivo>:<línea>
  - Actual: <qué hace ahora>
  - Propuesta: <qué debería hacer>
  - Impacto: 🔴 alto | 🟡 medio | 🟢 bajo
  - Esfuerzo: 🔴 alto | 🟡 medio | 🟢 bajo

### ⚡ Performance (N)
...

### 🏗️ Patrones (N)
...

### 🛡️ Robustez (N)
...

### 📦 Mantenibilidad (N)
...

### 🗳️ Voto recomendado
**Top 3 por relación impacto/esfuerzo:**
1. <mejora> — impacto alto, esfuerzo bajo
2. <mejora> — impacto alto, esfuerzo medio
3. <mejora> — impacto medio, esfuerzo bajo

¿Querés que implemente alguna?
```

## Persistencia

Guardar el reporte en `.claude/reports/improve-<slug>-<fecha>.md`.

## Reglas

- **No proponer por proponer.** Cada sugerencia debe tener un "por qué" concreto y un "qué ganás".
- **Respetar el scope.** Si el usuario dijo "solo el servicio X", no sugerir cambios en otros módulos.
- **Priorizar por impacto/esfuerzo.** Las mejoras de alto impacto y bajo esfuerzo van primero.
- **No aplicar nada sin confirmación.** Este comando solo propone.
