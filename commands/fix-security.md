# /fix-security — Arregla issues de seguridad automáticamente

## Cuándo usarlo

Después de un `/review` o `/security` que encontró issues de seguridad, o cuando quieras aplicar las medidas básicas de protección.

## Qué arregla

### 1. CORS con orígenes explícitos

Reemplazar `app.use(cors())` por:

```ts
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') || 'http://localhost:5173',
  credentials: true,
}));
```

Si el archivo no tiene `process.env.CORS_ORIGIN`, agregarlo.

### 2. Helmet + headers de seguridad

Agregar `helmet` y configurar CSP:

```bash
pnpm add helmet -r --filter @servifrenos/server
```

```ts
import helmet from 'helmet';
app.use(helmet());
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:"],
  },
}));
```

### 3. Rate limiting en endpoints sensibles

```bash
pnpm add express-rate-limit -r --filter @servifrenos/server
```

Agregar rate limiter global o por endpoint en `app.ts`:

```ts
import rateLimit from 'express-rate-limit';
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100 });
app.use('/api/', limiter);
```

### 4. Transacciones en operaciones multi-paso

Envolver `ventasService.crear()` y `ordenesService.completar()` en `db.transaction()`:

```ts
await db.transaction(async (tx) => {
  // todo: validación, inserts, descuento de stock
});
```

### 5. Reemplazar N+1 queries con batch

Cambiar `for...of` con SELECT/UPDATE individuales por:

```ts
// Batch SELECT
const productos = await db.select().from(productos).where(inArray(productos.id, ids));

// Batch UPDATE con CASE (si Drizzle lo soporta) o individuales dentro de tx
```

### 6. Agregar variables de entorno faltantes

Agregar a `.env` (y verificar que esté en `.gitignore`):

```
CORS_ORIGIN=http://localhost:5173,https://tudominio.com
JWT_SECRET=<generar secreto>
```

## Flujo

1. Verificar si las dependencias necesarias están instaladas (`helmet`, `express-rate-limit`, etc.). Si no, instalarlas.
2. Aplicar los cambios uno por uno, verificando que compila después de cada uno.
3. Ejecutar `pnpm build` (o `tsc --noEmit`) al final para confirmar que todo compila.
4. Mostrar resumen de cambios aplicados.

## Salida

```
## 🔧 Fix Seguridad aplicados

### ✅ Completados
- [x] CORS con orígenes explícitos
- [x] Helmet + headers de seguridad
- [x] Rate limiting
- [x] Transacciones en operaciones críticas
- [x] Batch queries (N+1)
- [x] Variables de entorno

### ⚠️ Pendientes (requieren decisión tuya)
- [ ] JWT / autenticación (diseñar esquema de auth)
- [ ] Migración a producción (certificados SSL, dominio)

### 📦 Dependencias instaladas
- helmet
- express-rate-limit
```
