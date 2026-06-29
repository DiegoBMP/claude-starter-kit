# /security — Escaneo de seguridad

## Cuándo usarlo

Antes de un deploy, al agregar endpoints nuevos, al modificar lógica de autenticación/autorización, o periódicamente como auditoría.

## Flujo

1. **Codebase Memory** — identificar endpoints, middlewares, esquemas de BD con datos sensibles.
2. **Revisión por capas:**

### 🔐 Autenticación & Autorización
- [ ] ¿JWT firmado y validado en cada endpoint protegido?
- [ ] ¿Tokens de acceso con expiración corta (≤ 15 min)?
- [ ] ¿Refresh token implementado con rotación?
- [ ] ¿Revocación de tokens posible?
- [ ] ¿Mínimo privilegio? (cada endpoint verifica rol/permiso específico, no solo "autenticado")
- [ ] ¿Rate limiting en login/register?

### 🗄️ Inyección & Validación
- [ ] ¿Toda entrada validada con Zod?
- [ ] ¿Sin SQL concatenado? (confirmar raw queries con placeholders)
- [ ] ¿No hay eval(), Function(), exec() con input de usuario?
- [ ] ¿Path traversal? (validar rutas de archivos si hay uploads)

### 🌐 Configuración
- [ ] ¿CORS con orígenes permitidos explícitos?
- [ ] ¿CSP configurada con directivas restrictivas?
- [ ] ¿HTTPS forzado en producción?
- [ ] ¿HSTS habilitado?
- [ ] ¿Cookies con Secure, HttpOnly, SameSite?

### 🔑 Secretos
- [ ] ¿Sin secretos hardcodeados? (API keys, passwords, tokens, JWT secrets)
- [ ] ¿Variables de entorno validadas al iniciar la app?
- [ ] ¿.env en .gitignore?

### 📝 Logging & Auditoría
- [ ] ¿Sin datos personales en logs?
- [ ] ¿Accesos a datos sensibles auditados?
- [ ] ¿Errores no exponen stack traces ni info interna en producción?

### 📦 Dependencias
- [ ] Ejecutar `npm audit` (o `pnpm audit`) y revisar vulnerabilidades críticas/altas.
- [ ] Verificar versiones de dependencias clave (Express, Drizzle, Zod) sin CVEs conocidos.

### 🧪 OWASP ASVS (chequeo rápido)
- [ ] V2: Autenticación
- [ ] V3: Manejo de sesiones
- [ ] V4: Control de acceso
- [ ] V5: Validación de entrada
- [ ] V8: Protección de datos
- [ ] V11: Lógica de negocio
- [ ] V14: Configuración

## Salida

```
## 🛡️ Escaneo de Seguridad

### 🔴 Críticos (N°)
- [ ] <descripción>

### 🟡 Altos (N°)
- [ ] <descripción>

### 🔵 Medios/Bajos (N°)
- [ ] <descripción>

### ✅ Resumen
**<X> críticos, <Y> altos, <Z> medios/bajos**
**Riesgo general: 🔴 Alto | 🟡 Medio | 🟢 Bajo**
```
