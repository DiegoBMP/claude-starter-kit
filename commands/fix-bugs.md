# /fix-bugs — Arregla bugs y problemas de correctitud automáticamente

## Cuándo usarlo

Después de un `/review` que encontró bugs, o cuando quieras sanear problemas comunes de calidad.

## Qué arregla

### 1. Transacciones en operaciones multi-paso

Envolver en transacción las operaciones que combinan validación, inserts y side effects. Buscar métodos que toquen múltiples tablas sin protección transaccional.

### 2. Reemplazar `as any` con tipos explícitos

Buscar `as any` en services y routers y reemplazar con tipos concretos.

### 3. State machine para estados

Agregar validación de transiciones de estado válidas en entidades con flujo de estados (órdenes, tickets, solicitudes):

```ts
const TRANSICIONES_VALIDAS: Record<string, string[]> = {
  pendiente: ['en_progreso', 'cancelada'],
  en_progreso: ['completada', 'cancelada'],
  completada: [],
  cancelada: [],
};

if (!TRANSICIONES_VALIDAS[entidad.estado]?.includes(nuevoEstado)) {
  throw new ValidationError({
    estado: `No se puede cambiar de ${entidad.estado} a ${nuevoEstado}`,
  });
}
```

### 4. Reemplazar N+1 queries con batch operations

Donde haya `for...of` con SELECT y UPDATE individuales, reemplazar por queries batch con IN, JOIN, o múltiples operaciones en paralelo dentro de transacción.

## Flujo

1. Buscar los patrones problemáticos en el código.
2. Aplicar los cambios uno por uno.
3. Ejecutar build (o type-check) para verificar que compila.
4. Ejecutar tests si existen para el módulo modificado.

## Salida

```
## 🔧 Fix Bugs aplicados

### ✅ Completados
- [x] Transacciones en <N> operaciones
- [x] State machine para estados
- [x] Batch queries reemplazadas
- [x] <otros fixes>

### 📦 Archivos modificados
- <archivo>
- <archivo>
```
