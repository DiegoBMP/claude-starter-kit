# Documentación del proyecto

## Qué es

Claude Starter Kit es un kit de configuración que se copia a la carpeta `.claude/` de cualquier proyecto. Aporta:

- **Commands** — Slash commands (`/review`, `/security`, `/qa`, etc.) que guían a Claude en tareas comunes.
- **Checklists** — Listas de verificación manual o automática para PRs, releases, seguridad y APIs.
- **Scripts** — Automatizaciones pre-sesión (git sync, volcado de esquema BD).
- **Setup** — Script interactivo que genera `CLAUDE.md` con reglas base.

## Estructura

```
├── README.md            ← Instalación, comandos, MCPs y skills recomendadas
├── FLOW.md              ← Flujo recomendado de desarrollo a deploy
├── CONTRIBUTING.md      ← Este archivo
├── settings.json        ← Registro de slash commands
├── setup.sh             ← Setup interactivo que genera CLAUDE.md
├── .gitignore           ← Ignora .claude/ (solo para dogfooding)
├── commands/            ← Un .md por cada slash command
│   ├── README.md
│   ├── review.md
│   ├── security.md
│   ├── privacy.md
│   ├── qa.md
│   ├── debug.md
│   ├── refactor.md
│   ├── fix-security.md
│   ├── fix-bugs.md
│   ├── fix-both.md
│   ├── commit.md
│   ├── changelog.md
│   ├── check-pr.md
│   └── check-release.md
├── checklists/          ← Checklists en markdown
│   ├── api.md
│   ├── pr.md
│   ├── release.md
│   └── security.md
├── scripts/             ← Scripts de automatización
│   ├── sync-git.sh
│   └── dump-schema.sh
└── .claude/             ← Copia local (gitignored, solo para desarrollo)
```

## Cómo agregar un command nuevo

1. Crear `commands/<nombre>.md` con esta estructura:

~~~markdown
# /<nombre> — Descripción corta

## Cuándo usarlo

...

## Flujo

1. ...
2. ...

## Salida

```
## 🏷️ Resultado

...
```
~~~

2. Registrarlo en `settings.json`:

```json
"<nombre>": {
  "description": "Descripción corta para el menú",
  "command": "<nombre>"
}
```

3. Agregarlo a `commands/README.md` (tabla de comandos y tabla de uso).
4. Agregarlo a `README.md` (tabla de comandos y tabla de uso).
5. Si cambia el flujo, actualizar `FLOW.md`.

## Cómo agregar un checklist

1. Crear `checklists/<nombre>.md` con checkboxes:

```markdown
# Checklist: <título>

## <Sección>
- [ ] <item>
- [ ] <item>
```

2. Si tiene un comando asociado (como `/check-pr` usa `checklists/pr.md`), referenciarlo en el command.

## Cómo agregar un script

1. Crear `scripts/<nombre>.sh` con shebang y `set -e`.
2. El script asume que se ejecuta desde la raíz del proyecto.
3. Usar `$SCRIPT_DIR` para rutas relativas al script.
4. Agregarlo al tree de `README.md` y a la sección de scripts.

## Principios

- **Cero dependencias.** Todo es markdown, bash y JSON. No necesita npm install.
- **Genérico.** Sin nombres de librerías, frameworks ni proyectos específicos.
- **Portable.** El kit se copia y pega en `.claude/` de cualquier proyecto.
- **Opiniones con escape.** Las reglas de seguridad y privacidad son firmes, pero el stack lo elige el usuario en `setup.sh`.

## Dogfooding

Para usar los slash commands mientras desarrollamos el kit, existe `.claude/` (ignorado por git). Al modificar archivos en la raíz:

```bash
bash scripts/sync-local.sh
```
