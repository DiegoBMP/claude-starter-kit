# /security-focus — Auditoría de seguridad de un endpoint o área

## Cuándo usarlo

Cuando necesitás revisar la seguridad de un endpoint, API surface o módulo concreto. A diferencia de `/security` (que escanea todo el proyecto), este traza en profundidad un punto de entrada específico.

## Flujo

### 1. Definir el scope

Preguntar al usuario:

> ¿Qué endpoint, API o área querés auditar?
>
> Ejemplos: "POST /api/orders", "el módulo de pagos", "la API de exportación", "el flujo de reset de password"

### 2. Mapear la superficie de ataque (codebase-memory intensivo)

- `search_graph` — encontrar la ruta o punto de entrada
- `trace_path` con `mode=data_flow` — seguir cada input del usuario hasta donde se consume
- `trace_path` con `mode=calls` — mapear middlewares, guards, validators
- Identificar: qué entra, quién lo procesa, dónde se almacena, qué se devuelve

### 3. Auditar por capa

#### 🔐 Autenticación & Autorización
- [ ] ¿El endpoint requiere auth? ¿Es explícito o implícito?
- [ ] ¿El middleware de auth valida firma, expiración y claims?
- [ ] ¿Se verifica permiso específico o solo "autenticado"?
- [ ] ¿IDOR posible? (el user X puede acceder al recurso del user Y?)

#### 🗄️ Inyección & Validación
- [ ] ¿Todo input del usuario tiene schema validation en runtime?
- [ ] ¿Hay raw SQL concatenado en este camino?
- [ ] ¿Hay path traversal en file uploads/downloads?
- [ ] ¿Hay eval(), exec(), deserialización insegura en el camino?

#### 📝 Datos sensibles
- [ ] ¿El request body incluye datos sensibles? (password, token, DNI)
- [ ] ¿La response expone campos que no debería? (password hash, IDs internos)
- [ ] ¿Se loguean datos personales en este flujo?
- [ ] ¿Las queries usan SELECT *? ¿Se filtran columnas sensibles?

#### ⚡ Rate & Abuso
- [ ] ¿Este endpoint tiene rate limiting? ¿Es suficiente para su criticidad?
- [ ] ¿Un atacante puede enumerar recursos? (IDs secuenciales, timestamps)
- [ ] ¿El payload tiene límite de tamaño?

#### 🌐 Configuración
- [ ] ¿CORS aplica a este endpoint?
- [ ] ¿Headers de seguridad en la response? (CSP, X-Content-Type, X-Frame)
- [ ] ¿HTTPS forzado? ¿HSTS?

### 4. Generar reporte

```
## 🛡️ Security Focus: <scope>

### 🗺️ Superficie de ataque
Entrada: <endpoint o función>
Inputs que acepta: <campos>
Dónde se almacena: <tablas>
Qué devuelve: <campos>

Middlewares en el camino:
1. <middleware1> → archivo:línea
2. <middleware2> → archivo:línea

### 🔴 Críticos (N)
- [ ] <hallazgo> — <archivo>:<línea> — OWASP: <A1-A10>

### 🟡 Altos (N)
...

### 🔵 Medios/Bajos (N)
...

### 📊 Evaluación OWASP
| Categoría | Estado |
|-----------|--------|
| A1: Broken Access Control | ✅ | ⚠️ | ❌ | N/A |
| A2: Cryptographic Failures | ✅ | ⚠️ | ❌ | N/A |
| A3: Injection | ✅ | ⚠️ | ❌ | N/A |
| A4: Insecure Design | ✅ | ⚠️ | ❌ | N/A |
| A5: Security Misconfiguration | ✅ | ⚠️ | ❌ | N/A |
| A6: Vulnerable Components | ✅ | ⚠️ | ❌ | N/A |
| A7: Auth Failures | ✅ | ⚠️ | ❌ | N/A |
| A8: Data Integrity | ✅ | ⚠️ | ❌ | N/A |
| A9: Logging & Monitoring | ✅ | ⚠️ | ❌ | N/A |
| A10: SSRF | ✅ | ⚠️ | ❌ | N/A |

### ✅ Veredicto
**Riesgo: 🔴 Alto | 🟡 Medio | 🟢 Bajo**
```

## Persistencia

Al terminar, guardar el reporte en `.claude/reports/security-focus-<slug>-<fecha>.md`.

## Reglas

- **Seguir cada input del usuario hasta el final.** Validación → transformación → almacenamiento → respuesta.
- **Si un middleware falta, señalarlo con el archivo donde debería agregarse.**
- **No auditar todo el proyecto.** Solo el scope y sus dependencias directas.
- **Cada hallazgo crítico debe tener archivo:línea concreto.**
