# Checklist: API Design

## 📐 Diseño

- [ ] RESTful: recursos, no acciones
- [ ] Verbos HTTP correctos: GET (leer), POST (crear), PUT/PATCH (actualizar), DELETE (eliminar)
- [ ] URLs en plural: `/api/clientes`, no `/api/cliente`
- [ ] Versionado: `/api/v1/...` (cuando sea necesario)
- [ ] Consistencia en naming (camelCase, kebab-case, el que decida el proyecto)

## 📦 Request/Response

- [ ] DTO de request con validación Zod
- [ ] DTO de response sin exponer campos internos
- [ ] Paginación: `{ data: [], total, page, pageSize }`
- [ ] Errores: `{ error: { code, message, details? } }`
- [ ] Códigos HTTP correctos: 200, 201, 204, 400, 401, 403, 404, 409, 422, 500
- [ ] Content-Type: `application/json`

## 🔐 Seguridad

- [ ] Auth requerida por defecto, pública solo si explícito
- [ ] Rate limiting en endpoints sensibles
- [ ] Validación de entrada en todos los campos
- [ ] Sin exponer IDs internos (usar UUID)
- [ ] Sin exponer datos sensibles en listados

## 🧪 Documentación

- [ ] Endpoint, método, path documentados
- [ ] Parámetros: query, body, path documentados
- [ ] Ejemplo de request y response
- [ ] Códigos de error documentados
- [ ] Permisos requeridos documentados

## ⚡ Performance

- [ ] Paginación en listados (sin límite, sin offset infinito)
- [ ] Campos solicitados explícitamente si el payload es grande
- [ ] Índices en columnas usadas para filtrar/ordenar
- [ ] Sin N+1 queries
- [ ] Cache headers considerados (ETag, Last-Modified)
