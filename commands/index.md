# /index — Indexar el proyecto con codebase-memory

## Cuándo usarlo

La primera vez que abrís un proyecto con Claude Code, o después de cambios grandes en la estructura del código (nuevos módulos, refactors grandes).

## Qué hace

Ejecuta `index_repository` de codebase-memory-mcp, que escanea cada archivo con LSP y construye un grafo del código: funciones, clases, rutas, llamadas entre ellas, flujo de datos.

El índice persiste en disco. No hace falta re-ejecutarlo en cada sesión.

## Cuándo re-indexar

- Después de un refactor grande
- Después de agregar un módulo o servicio nuevo
- Si los comandos `-focus` empiezan a dar resultados incompletos

Para cambios chicos, `detect_changes` es suficiente y más rápido. Pedile a Claude: _"detectá cambios con codebase-memory"_.

## Salida

```
## 📊 Proyecto indexado

- Nodos: <N>
- Aristas: <N>
- Funciones: <N>
- Rutas: <N>
- Clases: <N>

✅ Listo. Los comandos /review-focus, /qa-focus y /security-focus ya pueden trazar el código.
```
