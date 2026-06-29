# /fix-security — Arregla issues de seguridad automáticamente

## Cuándo usarlo

Después de un `/review` o `/security` que encontró issues de seguridad, o cuando quieras aplicar las medidas básicas de protección.

## Qué arregla

### 1. CORS con orígenes explícitos

Reemplazar `app.use(cors())` (sin configuración) por CORS con orígenes explícitos desde variables de entorno.

### 2. Headers de seguridad

Agregar headers HTTP de seguridad: CSP, X-Content-Type-Options, X-Frame-Options, HSTS.

### 3. Rate limiting en endpoints sensibles

Agregar rate limiter global en `/api/` y más restrictivo en login/register.

### 4. Transacciones en operaciones multi-paso

Envolver operaciones que tocan múltiples tablas en transacciones.

### 5. Reemplazar N+1 queries con batch

Cambiar `for...of` con queries individuales por queries batch (IN, JOIN, o Promise.all dentro de transacción).

### 6. Agregar variables de entorno faltantes

Agregar a `.env` las variables de seguridad necesarias (CORS, secrets). Verificar que `.env` esté en `.gitignore`.

## Flujo

1. Verificar si las dependencias necesarias están instaladas. Si no, sugerir el comando de instalación para el package manager del proyecto.
2. Aplicar los cambios uno por uno, verificando que compila después de cada uno.
3. Ejecutar build (o type-check) al final para confirmar que todo compila.
4. Mostrar resumen de cambios aplicados.

## Salida

```
## 🔧 Fix Seguridad aplicados

### ✅ Completados
- [x] CORS con orígenes explícitos
- [x] Headers de seguridad
- [x] Rate limiting
- [x] Transacciones en operaciones críticas
- [x] Batch queries (N+1)
- [x] Variables de entorno

### ⚠️ Pendientes (requieren decisión tuya)
- [ ] Autenticación (diseñar esquema de auth)
- [ ] Migración a producción (certificados SSL, dominio)

### 📦 Dependencias instaladas
- <lista de paquetes agregados>
```
