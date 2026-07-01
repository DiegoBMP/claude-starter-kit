# /improve-focus — Mejoras enfocadas en un módulo o vista

## Cuándo usarlo

Cuando querés mejorar una parte concreta del proyecto: un servicio lento, una vista con demasiada lógica, un flujo enredado. A diferencia de `/improve` (que mira todo el proyecto), este traza el subgrafo del módulo y propone mejoras quirúrgicas.

## Flujo

### 1. Definir el scope

Preguntar al usuario:

> ¿Qué módulo, vista o servicio querés mejorar?
>
> Ejemplos: "el servicio de facturación", "la vista de dashboard", "el flujo de recuperar contraseña"

### 2. Mapear el subgrafo (codebase-memory intensivo)

- `search_graph` — encontrar la función, clase o ruta raíz
- `trace_path` con `mode=calls` y `mode=data_flow` — dependencias, 3 niveles
- `get_code_snippet` — leer código fuente de cada nodo
- `query_graph` — buscar señales de complejidad: `transitive_loop_depth`, `linear_scan_in_loop`, `alloc_in_loop`, `param_count`

### 3. Analizar por dimensión

#### 🧹 Simplificación
- ¿El módulo hace más de una cosa? ¿Se puede split?
- ¿Hay funciones > 30 líneas que deberían ser 3 de 10?
- ¿Condiciones anidadas que serían más claras con early return?
- ¿Código repetido dentro del mismo módulo?

#### ⚡ Performance
- ¿N+1 queries? El grafo muestra `linear_scan_in_loop` y `alloc_in_loop`
- ¿Cálculos repetidos en renders o loops?
- ¿Faltan índices en columnas que este módulo consulta?
- ¿Queries sin límite de filas?

#### 🔗 Acoplamiento
- ¿El módulo depende de demasiados archivos externos?
- ¿Importa cosas que podría resolver internamente?
- ¿Otros módulos dependen de detalles internos de este?
- ¿Se puede aislar con una interfaz más limpia?

#### 🛡️ Robustez
- ¿Qué pasa si falla cada dependencia externa? (API, BD, archivo)
- ¿Faltan timeouts, retries, circuit breakers?
- ¿El estado del módulo puede quedar inconsistente?
- ¿Validación de entrada en todas las fronteras del módulo?

#### 🧪 Testeabilidad
- ¿El módulo es fácil de testear aislado?
- ¿Depende de `new Date()`, `Math.random()`, global state?
- ¿Faltan tests para los caminos de error?

### 4. Generar reporte

```
## 💡 Mejoras para <módulo>

### 🗺️ Mapa del módulo
Entrada: <ruta/función raíz>
Dependencias directas: <N archivos>
Señales de complejidad: <transitive_loop_depth, linear_scan_in_loop, etc.>

### 🧹 Simplificación (N)
- [ ] **<título>** — <archivo>:<línea>
  - Actual: <qué hace ahora>
  - Propuesta: <qué debería hacer>
  - Impacto: 🔴 | 🟡 | 🟢  •  Esfuerzo: 🔴 | 🟡 | 🟢

### ⚡ Performance (N)
...

### 🔗 Acoplamiento (N)
...

### 🛡️ Robustez (N)
...

### 🧪 Testeabilidad (N)
...

### 🗳️ Top 3 por impacto/esfuerzo
1. <mejora>
2. <mejora>
3. <mejora>

¿Querés que implemente alguna?
```

## Persistencia

Guardar el reporte en `.claude/reports/improve-focus-<slug>-<fecha>.md`.

## Reglas

- **Solo el scope y sus dependencias directas (profundidad 3).**
- **Cada propuesta debe tener archivo:línea concreto.**
- **Usar el grafo para detectar señales de complejidad reales, no opiniones.**
- **No proponer reescribir todo.** Mejoras quirúrgicas, no rewrites.
