# /qa-focus — QA enfocado en un feature o flujo

## Cuándo usarlo

Cuando necesitás planear y ejecutar pruebas para un feature, vista o flujo concreto. A diferencia de `/qa` (que cubre todo el proyecto), este se concentra en lo que vos definís.

## Flujo

### 1. Definir el scope

Preguntar al usuario:

> ¿Qué feature, vista o flujo querés probar?
>
> Ejemplos: "el flujo de crear una orden", "la vista de dashboard", "el endpoint de exportación CSV"

### 2. Mapear el feature (codebase-memory intensivo)

- `search_graph` — encontrar el punto de entrada (ruta, componente, botón)
- `trace_path` con `mode=data_flow` — seguir el dato desde el input hasta el output
- Identificar todos los puntos de fallo: validación, transformación, persistencia, render

### 3. Generar plan de pruebas

#### 🧪 Unitarias
Para cada función de lógica en el camino del dato:
- [ ] Happy path
- [ ] Input inválido (nulo, vacío, malformado, límite)
- [ ] Error simulado (BD caída, timeout, API externa falla)

#### 🔗 Integración
- [ ] Request → controller → service → repository → response
- [ ] Transacción: rollback en cada punto de fallo
- [ ] Auth: sin token, token expirado, rol incorrecto

#### 🖥️ UI (si aplica)
- [ ] Render con datos, vacío, loading, error
- [ ] Interacción: click, submit, navegación
- [ ] Validación: campos requeridos, formatos, límites
- [ ] Responsive: mobile, tablet, desktop

#### 🔄 Flujo completo E2E con Playwright MCP
Usar las herramientas `mcp__playwright__browser_*` para ejecutar el flujo en vivo:

**Setup:** `browser_navigate` a la URL base del proyecto.
**Interacción:** `browser_click`, `browser_type`, `browser_select_option`, `browser_fill_form`.
**Verificación:** `browser_snapshot` para confirmar elementos, `browser_take_screenshot` para evidencia.
**Assertions:** `browser_evaluate` para validar estado (texto, clases CSS, data-testid, URL actual).
**Consola/red:** `browser_console_messages` y `browser_network_requests` para detectar errores JS y llamadas fallidas.

Flujos a cubrir:
- [ ] Camino feliz de punta a punta (navegar, interactuar, verificar resultado)
- [ ] Camino triste: error en cada paso del flujo (forzar validación, timeout, 500)
- [ ] Recuperación: reintentar, volver atrás, cancelar
- [ ] Screenshot por cada paso clave (guardar en `.playwright-mcp/`)

Si el Playwright MCP no está disponible, caer en specs tradicionales de Playwright test framework (`.spec.ts`).

### 4. Generar reporte

```
## 🧪 QA Focus: <feature>

### 🗺️ Flujo del feature
1. <paso 1> → <archivo>
2. <paso 2> → <archivo>
3. ...

Puntos de fallo identificados: <N>

### Plan de pruebas
| Tipo | Cantidad | Archivos clave |
|------|----------|---------------|
| Unitarias | N | ... |
| Integración | N | ... |
| UI | N | ... |
| E2E | N | ... |

### 🧪 Casos de prueba generados

#### <Caso 1>: Happy path
- **Dado** <precondición>
- **Cuando** <acción>
- **Entonces** <resultado esperado>

#### <Caso 2>: Error en <paso>
...

### 🐛 Riesgos identificados
- [ ] <riesgo> — probabilidad: alta | media | baja

### ✅ Veredicto
**🟢 Listo para PR** | **🟡 Con observaciones** | **🔴 Requiere más cobertura**
```

## Persistencia

Al terminar, guardar el plan en `.claude/reports/qa-focus-<slug>-<fecha>.md`.

## Reglas

- **Generar casos de prueba ejecutables**, no descripciones vagas.
- **Cubrir todos los puntos de fallo** identificados en el mapeo.
- **Si el feature toca BD, verificar transacciones y rollback.**
- **Si el feature tiene UI, incluir estados de loading, empty y error.**
