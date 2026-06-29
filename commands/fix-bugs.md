# /fix-bugs — Arregla bugs y problemas de correctitud automáticamente

## Cuándo usarlo

Después de un `/review` que encontró bugs, o cuando quieras sanear problemas comunes de calidad.

## Qué arregla

### 1. Transacciones en operaciones multi-paso

Envolver en `db.transaction()` las operaciones que combinan validación, inserts y side effects:

- `ventasService.crear()` — validar stock, insertar venta, insertar detalles, descontar stock, insertar movimiento
- `ordenesService.completar()` — insertar venta, insertar detalles, descontar stock, insertar movimientos
- Cualquier otro método que tenga efectos múltiples sin transacción

Patrón:

```ts
await db.transaction(async (tx) => {
  // todo adentro usa tx en vez de db
});
```

### 2. Reemplazar `as any` con tipos explícitos

Buscar `as any` en services y routers y reemplazar con tipos concretos.

### 3. State machine para estados de orden

Agregar validación de transiciones de estado válidas en `ordenesService.actualizar()`:

```ts
const TRANSICIONES_VALIDAS: Record<string, string[]> = {
  pendiente: ['en_progreso', 'cancelada'],
  en_progreso: ['completada', 'cancelada'],
  completada: [],
  cancelada: [],
};

if (!TRANSICIONES_VALIDAS[orden.estado]?.includes(data.estado)) {
  throw new ValidationError({
    estado: `No se puede cambiar de ${orden.estado} a ${data.estado}`,
  });
}
```

### 4. Reemplazar N+1 queries con batch operations

Donde haya `for...of` con SELECT y UPDATE individuales, reemplazar por:

```ts
// 1 SELECT con IN
const productos = await db.select().from(productos)
  .where(inArray(productos.id, ids));

// 1 UPDATE con CASE (o múltiples en paralelo con Promise.all dentro de tx)
```

## Flujo

1. Buscar los patrones problemáticos en el código.
2. Aplicar los cambios uno por uno.
3. Ejecutar `pnpm build` (o `tsc --noEmit`) para verificar que compila.
4. Ejecutar tests si existen para el módulo modificado.

## Salida

```
## 🔧 Fix Bugs aplicados

### ✅ Completados
- [x] Transacciones en <N> operaciones
- [x] State machine para estados de orden
- [x] Batch queries reemplazadas
- [x] <otros fixes>

### 📦 Archivos modificados
- <archivo>
- <archivo>
```
