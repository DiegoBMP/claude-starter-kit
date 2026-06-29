# /commit — Genera texto de commit

## Cuándo usarlo

Cuando termines una feature o un grupo de cambios lógicos y quieras un mensaje de commit listo para copiar y pegar.

## Flujo

1. **Git diff** — analizar todos los cambios realizados (staged + unstaged + untracked).
2. **Clasificar cambios** por tipo: feat, fix, refactor, security, privacy, chore, docs.
3. **Generar mensaje** siguiendo Conventional Commits y las reglas del proyecto.

## Reglas

- Primer línea: `tipo(alcance): descripción breve (max 72 chars)`
- Cuerpo: bullets con cada cambio agrupado por categoría
- No incluir Co-Authored-By (se agrega al hacer commit)
- En español (consistente con el proyecto)

## Salida

```
<tipo>(<alcance>): <descripción breve>

# Features
- <descripción>

# Fixes
- <descripción>

# Refactor
- <descripción>

# Seguridad
- <descripción>

# Privacidad
- <descripción>

# Dependencias
- <descripción>

# Configuracion
- <descripción>
```
