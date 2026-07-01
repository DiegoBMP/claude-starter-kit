# /fix-test — Genera tests faltantes automáticamente

## Cuándo usarlo

Después de un `/review` que detectó módulos sin cobertura, al terminar una feature, o cuando quieras subir la cobertura de tests del proyecto.

## Qué detecta y arregla

### 1. Módulos sin archivo de test

Buscar archivos de código fuente (`*.service.ts`, `*.router.ts`, `*.utils.ts`, `*.tsx`) que no tengan su correspondiente `*.test.ts` o `*.spec.ts` y generarlo.

### 2. Funciones exportadas sin test

Para módulos que YA tienen archivo de test, buscar funciones/clases exportadas que no tengan ningún test que las cubra.

### 3. Ramas sin cobertura

Para funciones con tests existentes, identificar branches (`if`, `else`, `catch`, `switch/case`) sin cobertura y agregar casos de test.

### 4. Tests de componente frontend

Para componentes React (`*.tsx`), detectar los que no tengan test de renderizado, interacción o estados (loading, empty, error, edge cases).

### 5. Tests de integración de flujos críticos

Identificar flujos multi-paso (crear → actualizar → eliminar, importar, exportar) sin tests end-to-end o de integración.

## Flujo

1. **Detectar**: escanear el proyecto para encontrar módulos sin tests o con tests incompletos.
2. **Priorizar**: ordenar por criticidad — servicios/core primero, utilidades/UI después.
3. **Leer patrón**: revisar los tests existentes del proyecto para replicar estilo, framework, fixtures y convenciones.
4. **Generar**: crear los tests faltantes uno por uno, cubriendo:
   - Caso feliz (happy path)
   - Casos de error (validation, not found, unauthorized)
   - Edge cases (null, undefined, vacío, límites)
5. **Ejecutar**: correr los tests generados para verificar que pasan.
6. **Reportar**: resumen de lo creado.

## Reglas

- No borrar tests existentes. Solo agregar.
- Seguir el mismo framework de testing que ya usa el proyecto (vitest, jest, etc.).
- Replicar el estilo, fixtures y helpers de los tests existentes.
- Si un módulo no exporta nada testeable (solo re-exporta), marcarlo como `[skip]` y explicar por qué.
- Si no hay tests en el proyecto, crear el primero con el setup mínimo (vitest recomendado).
- No generar tests vacíos ni placeholders. Cada test debe tener assertions reales.

## Salida

```
## 🧪 Fix Test aplicados

### 📊 Cobertura detectada
| Módulo | Antes | Después |
|--------|-------|---------|
| productos.service.importarProductos | ❌ 0% | ✅ testeado |
| ImportarModal.tsx | ❌ 0% | ✅ testeado |
| ventas.service.anularVenta | 🟡 parcial | ✅ testeado |
| OrdenesPage.tsx | ❌ 0% | ✅ testeado |

### ✅ Tests creados
- [x] **productos.service.test.ts** — `importarProductos`: happy path, CSV inválido, archivo vacío, encoding erróneo
- [x] **ImportarModal.test.tsx** — renderizado, submit, error de red, cancelación
- [x] **ventas.service.test.ts** — `anularVenta`: anulación exitosa, venta no encontrada, venta ya anulada
- [x] **OrdenesPage.test.tsx** — columnas del kanban, drag & drop, estados vacíos

### 📦 Archivos modificados
- src/services/__tests__/productos.service.test.ts (nuevo)
- src/components/__tests__/ImportarModal.test.tsx (nuevo)
- src/services/__tests__/ventas.service.test.ts (modificado)
- src/pages/__tests__/OrdenesPage.test.tsx (nuevo)

### 📈 Resultado
**Tests creados: 4 archivos, 18 casos**
**Tests pasan: ✅ 18/18**
```
