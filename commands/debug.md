# /debug — Depuración guiada

## Cuándo usarlo

Cuando hay un bug, error inesperado, o comportamiento incorrecto en la aplicación.

## Flujo

1. **Recopilar información del problema.**
   - ¿Qué se esperaba vs qué ocurrió?
   - ¿En qué entorno? (dev, prod)
   - ¿Pasos para reproducir?
   - ¿Mensaje de error exacto? (logs, terminal, consola del navegador)

2. **Codebase Memory** — buscar el código relevante: funciones involucradas, flujo de datos, dependencias.

3. **Análisis sistemático:**

### Si es error de compilación/TypeScript
- [ ] Revisar tsconfig y tipos importados
- [ ] Buscar `any` o casteos incorrectos
- [ ] Verificar que los schemas Zod y tipos de TS estén sincronizados
- [ ] Revisar imports cíclicos

### Si es error en API (server)
- [ ] ¿Llega la request al endpoint? (log en controller)
- [ ] ¿La validación Zod rechaza la entrada?
- [ ] ¿La query DB devuelve lo esperado?
- [ ] ¿El error se captura y devuelve correctamente?
- [ ] Revisar middlewares (auth, CORS, rate limiting)
- [ ] Probar con curl/Postman para aislar el frontend

### Si es error en UI (client)
- [ ] ¿Error de red? (network tab)
- [ ] ¿Error de React? (console errors, component stack)
- [ ] ¿Estado incorrecto? (TanStack Query devtools)
- [ ] ¿Renderizado condicional cubre todos los estados?
- [ ] Probar con datos mínimos/vacíos

### Si es error en BD
- [ ] ¿Migraciones aplicadas?
- [ ] ¿Schema de Drizzle y BD real sincronizados?
- [ ] Revisar índices y constraints
- [ ] ¿Transacciones manejadas correctamente?

### Herramientas
- Usar Context7 si el error involucra una librería cuyo comportamiento específico se desconoce.
- Revisar issues de GitHub de las dependencias si parece bug conocido.

## Salida

```
## 🐛 Debug Report

### Problema
<descripción>

### Causa raíz encontrada
<explicación>

### Solución aplicada
<código o pasos>

### Validación
- [ ] ¿El bug se reprodujo antes del fix?
- [ ] ¿El bug no se reproduce después del fix?
- [ ] ¿Hay tests que cubren este caso?
- [ ] ¿Podría haber efectos secundarios?

### Prevención
<cómo evitar que vuelva a ocurrir>
```
