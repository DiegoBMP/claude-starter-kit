# /qa — Pruebas estilo QA

## Cuándo usarlo

Después de implementar cambios, antes de un PR, cuando se necesita verificar que una funcionalidad funciona correctamente de extremo a extremo.

## ⚠️ Protección de datos

- **NUNCA borrar, modificar ni truncar datos de la BD de desarrollo o producción.** Los tests deben usar una BD aislada con su propio `DATABASE_URL`. Las pruebas unitarias y de integración corren exclusivamente contra esa BD de test, que se limpia y se vuelve a poblar con seed mínimo en cada ejecución. La BD de desarrollo jamás se toca.
- **Si un test requiere datos específicos**, se crean en el `beforeAll` del test y se limpian solos al finalizar la suite.
- **NUNCA usar `DELETE FROM`, `TRUNCATE` o `DROP` sin confirmar primero qué BD está activa.** Revisar `DATABASE_URL` antes de cualquier operación destructiva.
- **E2E**: si se ejecutan contra desarrollo local, usar solo lectura o crear entidades de prueba que no interfieran con datos reales.

## Flujo

1. **Codebase Memory** — identificar qué módulos/funcionalidades cambiaron y sus flujos asociados.
2. **Git diff** — revisar los cambios concretos.
3. **Generar y ejecutar plan de QA:**

### 🔍 Análisis de impacto
- [ ] ¿Qué funcionalidades están involucradas directa e indirectamente?
- [ ] ¿Hay cambios en BD? (migraciones, esquemas)
- [ ] ¿Hay cambios en API? (nuevos endpoints, cambios en contratos)
- [ ] ¿Hay cambios en UI? (nuevos componentes, flujos modificados)
- [ ] ¿Hay cambios en shared? (schemas, tipos)

### 🧪 Plan de pruebas sugerido

#### Unitarias (server)
Para cada función con lógica no trivial:
- [ ] Caso feliz
- [ ] Caso error (entrada inválida, ID no existe, permisos insuficientes)
- [ ] Casos borde (valores límite, arrays vacíos, null/undefined)
- [ ] Schema validation (entradas malformadas)

#### Integración (server)
- [ ] Flujo completo request → controller → service → repository → DB → response
- [ ] Errores de BD se traducen correctamente
- [ ] Transacciones se revierten en caso de error

#### UI (client)
- [ ] Componente renderiza con datos
- [ ] Componente renderiza vacío/loading/error
- [ ] Estados de carga y error visibles
- [ ] Navegación funciona (router del framework)
- [ ] Formularios: validación en cliente + servidor
- [ ] Responsive (mobile first)

#### E2E con Playwright MCP (ejecución automática)
Si hay cambios en UI o flujos críticos, usar las herramientas `mcp__playwright__browser_*` para ejecutar tests E2E en vivo sin instalar dependencias:

**Setup:** `browser_navigate` a la URL base del proyecto (localhost o deploy preview).
**Interacción:** `browser_click`, `browser_type`, `browser_select_option`, `browser_fill_form`.
**Verificación:** `browser_snapshot` para confirmar elementos renderizados, `browser_take_screenshot` para evidencia visual.
**Assertions:** `browser_evaluate` para correr JS inline y validar estado (texto, clases CSS, atributos data-testid).

Checklist de flujos a cubrir:
- [ ] Navegación y rutas (`browser_click` en links, verificar URL con `browser_evaluate`)
- [ ] Flujo completo (crear → listar → editar → eliminar)
- [ ] Estados vacíos (navegar a lista sin datos)
- [ ] Manejo de errores (navegar a ruta inexistente → 404, forzar 500)
- [ ] Autenticación (login, logout, sesión expirada)
- [ ] Formularios: validación cliente + servidor (`browser_type` + submit + verificar errores)
- [ ] Screenshots al final de cada flujo (guardar en `.playwright-mcp/`)

Si el Playwright MCP no está disponible (tools `mcp__playwright__*` ausentes), caer en el plan tradicional: generar specs de Playwright test framework (`.spec.ts`) para que el usuario las ejecute con `npx playwright test`.

### 📁 Carpeta de salida Playwright

Todas las capturas, snapshots y logs de la sesión Playwright se guardan en una carpeta dedicada:

```
.playwright-mcp/
└── qa-<slug>-<NN>/
    ├── reporte.md          ← resumen de las pruebas ejecutadas
    ├── screenshot-01.png   ← capturas tomadas durante la sesión
    ├── screenshot-02.png
    ├── snapshot-01.yml     ← snapshots de accesibilidad
    └── console.log         ← logs de consola del navegador
```

**Convención de nombres:**
- `<slug>`: descripción corta del feature en kebab-case. Ej: `login`, `crear-orden`, `export-csv`.
- `<NN>`: número secuencial de dos dígitos (01, 02, 03…). Se incrementa automáticamente si la carpeta ya existe.

**Al iniciar la sesión Playwright:**
1. Determinar el slug a partir del feature bajo prueba.
2. Buscar carpetas existentes con `ls .playwright-mcp/qa-<slug>-*` y calcular el siguiente `NN`.
3. Crear la carpeta: `mkdir -p .playwright-mcp/qa-<slug>-<NN>`.
4. Toda captura (`browser_take_screenshot` con `filename`) y snapshot (`browser_snapshot` con `filename`) debe usar rutas relativas dentro de esa carpeta.
5. Al terminar, escribir `reporte.md` con el resumen de la ejecución (ver formato abajo).

**Formato de `reporte.md`:**
```markdown
# 🧪 QA: <feature> — <fecha>

## Flujo probado
1. <paso 1> → 🟢 | 🔴
2. <paso 2> → 🟢 | 🔴
3. ...

## Capturas
| # | Archivo | Paso |
|---|---------|------|
| 1 | screenshot-01.png | <descripción> |
| 2 | screenshot-02.png | <descripción> |

## Resultado
| Métrica | Valor |
|---------|-------|
| Pasos ejecutados | N |
| Pasos OK | N |
| Fallos | N |

## Veredicto
**🟢 Listo** | **🟡 Observaciones** | **🔴 Bloqueado**
```

### Reporte

```
## 🧪 QA Report

### Funcionalidades evaluadas
- <feature> → 🟢 | 🟡 | 🔴

### Pruebas realizadas
| Tipo | Cantidad | Pasaron |
|------|----------|---------|
| Unitarias | X | X |
| Integración | X | X |
| UI | X | X |
| E2E (Playwright) | X | X |

### 🐛 Bugs encontrados
- [ ] <descripción> — severidad: 🔴 crítica | 🟡 alta | 🔵 media | ⚪ baja

### 📁 Artefactos E2E
`.playwright-mcp/qa-<slug>-<NN>/`

### ✅ Veredicto
**🟢 Listo para PR** | **🟡 Con observaciones** | **🔴 No listo**
```
