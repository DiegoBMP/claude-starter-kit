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

#### E2E con Playwright
Si hay cambios en UI o flujos críticos, Playwright debe verificar:
- [ ] Navegación y rutas
- [ ] Flujo completo (crear → listar → editar → eliminar)
- [ ] Estados vacíos
- [ ] Manejo de errores (404, 500)
- [ ] Autenticación (login, logout, sesión expirada)

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

### ✅ Veredicto
**🟢 Listo para PR** | **🟡 Con observaciones** | **🔴 No listo**
```
