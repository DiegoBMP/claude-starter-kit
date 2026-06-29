# Checklist: Seguridad (OWASP Top 10 + API Top 10)

## A1: Broken Access Control
- [ ] Principio de mínimo privilegio: cada endpoint verifica permiso específico
- [ ] Sin IDOR (cada usuario solo accede a sus recursos)
- [ ] Sin escalación de privilegios vertical/horizontal
- [ ] Sin acceso a endpoints admin desde cuentas normales
- [ ] BOLA/BFLA verificado (API Top 10)

## A2: Cryptographic Failures
- [ ] Contraseñas: Argon2id
- [ ] HTTPS obligatorio en producción
- [ ] Datos sensibles cifrados en reposo (BD)
- [ ] Sin algoritmos criptográficos débiles (MD5, SHA1, DES)

## A3: Injection
- [ ] SQL: Drizzle query builder o raw queries parametrizadas. Sin concatenación.
- [ ] NoSQL: validación estricta de entrada
- [ ] XSS: escape en salidas, CSP, React escapa por defecto
- [ ] Command injection: sin exec/eval con input de usuario

## A4: Insecure Design
- [ ] Límites de rate en login/register
- [ ] Límites de tamaño en payloads
- [ ] Throttling en operaciones costosas

## A5: Security Misconfiguration
- [ ] CORS orígenes explícitos, no wildcard en producción
- [ ] CSP configurada y activa
- [ ] HSTS habilitado
- [ ] Sin debug mode en producción
- [ ] Headers de seguridad: X-Content-Type-Options, X-Frame-Options

## A6: Vulnerable Components
- [ ] Dependencias actualizadas
- [ ] `pnpm audit` sin críticos/altos
- [ ] Sin librerías deprecadas o sin mantenimiento

## A7: Auth Failures
- [ ] JWT expiración ≤ 15 min
- [ ] Refresh token con rotación
- [ ] Sin sesiones estáticas
- [ ] MFA considerado para acciones sensibles

## A8: Data Integrity
- [ ] JWT firmado y verificado
- [ ] Sin deserialización insegura
- [ ] Integrity checks en datos críticos

## A9: Logging & Monitoring
- [ ] Sin datos personales en logs
- [ ] Eventos de seguridad logueados (accesos denegados, login fallidos)
- [ ] Alertas configuradas para patrones sospechosos

## A10: SSRF
- [ ] URLs externas validadas y permit-listed
- [ ] Sin redireccionamiento abierto

## API específicos
- [ ] Sin exponer IDs autoincrementales (usar UUID)
- [ ] Sin información excesiva en errores
- [ ] Paginación con límites forzados
- [ ] Schema validation en toda entrada (Zod)
