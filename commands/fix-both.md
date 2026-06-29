# /fix-both — Arregla seguridad y bugs en un solo comando

## Qué hace

Ejecuta `/fix-security` y `/fix-bugs` en secuencia:

1. Lee y aplica los cambios de seguridad: CORS, headers, rate limiting, transacciones, batch queries, variables de entorno.
2. Lee y aplica los cambios de bugs: state machine, `as any`, batch restantes.
3. Ejecuta build (o type-check) para verificar que todo compila.
4. Ejecuta tests si existen para verificar que los tests siguen pasando.
5. Genera reporte consolidado.

## Salida

```
## 🔧 Fix Completo aplicado

### Seguridad (N)
...
### Bugs (N)
...
### Archivos modificados (N)
...
### Build ✅ | Tests ✅ | 🟢
```
