# /review-focus — Review profundo de un módulo o vista

## Cuándo usarlo

Cuando necesitás revisar a fondo una parte concreta del proyecto: una vista, un servicio, un flujo de datos. A diferencia de `/review` (que mira todo el diff), este hace zoom en lo que vos definís.

## Flujo

### 1. Definir el scope

Preguntar al usuario:

> ¿Qué módulo, vista, servicio o flujo querés revisar?
>
> Ejemplos: "la vista de checkout", "el servicio de notificaciones", "el flujo de login", "el endpoint POST /api/orders"

### 2. Mapear el subgrafo (codebase-memory intensivo)

Usando codebase-memory, trazar todo lo que toca ese scope:

- `search_graph` — encontrar la función, clase, ruta o componente raíz
- `trace_path` con `mode=calls` y `mode=data_flow` — mapear dependencias hacia adentro y hacia afuera, 3 niveles de profundidad
- `get_code_snippet` — leer el código fuente de cada nodo relevante
- `get_architecture` — entender el contexto del módulo en el proyecto

### 3. Revisar con profundidad

Sobre cada archivo y función del subgrafo, evaluar:

#### 🐛 Bugs & Correctitud
- ¿Manejo de errores cubre todos los caminos?
- ¿Casos borde? (null, vacío, límites, timeout)
- ¿Carreras o condiciones de concurrencia?
- ¿Validación de entrada completa?

#### ⚡ Performance
- ¿N+1 queries? ¿Faltan índices?
- ¿Cálculos redundantes? ¿Re-renders innecesarios?
- ¿Carga lazy de dependencias pesadas?

#### 🏗️ Arquitectura
- ¿Responsabilidad única o hace demasiado?
- ¿Acoplamiento con otros módulos? ¿Debería estar aislado?
- ¿El contrato (API, props, types) es estable y claro?

#### 🛡️ Seguridad
- ¿Validación de auth y permisos en cada entrada?
- ¿Datos sensibles expuestos?
- ¿Inyección posible en inputs?

#### 🧪 Testeabilidad
- ¿Es fácil testear este módulo de forma aislada?
- ¿Depende de global state, singletons o time?
- ¿Faltan tests para los caminos no felices?

### 4. Generar reporte

```
## 🔍 Review Focus: <scope>

### 🗺️ Mapa del módulo
Entrada: <endpoint | ruta | función raíz>
Dependencias directas: <N archivos>
Profundidad trazada: 3 niveles

```
<función raíz>
├── llama a <fn1>
│   ├── lee <tabla1>
│   └── escribe <tabla2>
├── llama a <fn2>
│   └── llama a <fn3>
└── retorna <tipo>
```

### 🐛 Bugs (N)
- [ ] <descripción> — <archivo>:<línea>

### ⚡ Performance (N)
...

### 🏗️ Arquitectura (N)
...

### 🛡️ Seguridad (N)
...

### 🧪 Testeabilidad (N)
...

### ✅ Veredicto
**🟢 Aprobado** | **🟡 Aprobado con observaciones** | **🔴 Requiere cambios**

### 💡 Recomendaciones
- <mejora concreta>
```

## Persistencia

Al terminar, guardar el reporte en `.claude/reports/review-focus-<slug>-<fecha>.md` para que el usuario pueda consultarlo después, incluso en otra sesión.

## Reglas

- **No salirse del scope.** Si un archivo no está en el subgrafo, no se revisa.
- **Profundidad 3.** Si hay más niveles, mencionarlos pero no expandir.
- **El mapa del módulo es obligatorio.** Es lo que diferencia este comando de un `/review` genérico.
