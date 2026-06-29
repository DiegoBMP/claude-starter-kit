# /changelog — Generar changelog desde conventional commits

## Cuándo usarlo

Antes de un release, para generar `CHANGELOG.md` o las release notes a partir de los commits desde el último tag.

## Flujo

1. Encontrar el último tag: `git describe --tags --abbrev=0`.
2. Listar commits desde ese tag hasta HEAD: `git log <tag>..HEAD --format="%s"`.
3. Clasificar cada commit según conventional commits:

| Prefijo | Sección |
|---------|---------|
| `feat:` | ✨ Nuevas funcionalidades |
| `fix:` | 🐛 Bugs corregidos |
| `security:` | 🛡️ Seguridad |
| `privacy:` | 🔒 Privacidad |
| `perf:` | ⚡ Performance |
| `refactor:` | 🔧 Refactorización |
| `docs:` | 📚 Documentación |
| `test:` | 🧪 Tests |
| `chore:` | 📦 Mantenimiento |
| `style:` | 🎨 Estilo |
| `ci:` | ⚙️ CI/CD |

4. Si un commit no sigue conventional commits, ponerlo en "Otros cambios".

5. Agrupar por sección, ordenar alfabéticamente dentro de cada una.

6. Incluir el rango de commits y la fecha.

## Salida

```
## <versión> (<fecha>)

### ✨ Nuevas funcionalidades
- <descripción> (<hash>)

### 🐛 Bugs corregidos
- <descripción> (<hash>)

### 🛡️ Seguridad
- <descripción> (<hash>)

### 🔧 Refactorización
- <descripción> (<hash>)

### 📚 Documentación
- <descripción> (<hash>)

### 📦 Mantenimiento
- <descripción> (<hash>)
```

## Reglas

- Si el rango de commits está vacío, avisar: "No hay commits desde el último tag."
- Si no hay tags, listar todos los commits y sugerir crear el primer tag.
- Preguntar si se escribe el resultado en `CHANGELOG.md` o solo se muestra.
- Si ya existe `CHANGELOG.md`, insertar la nueva versión al principio del archivo.
