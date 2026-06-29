# /privacy — Revisión de Privacidad (Ley 21.719 + GDPR)

## Cuándo usarlo

Al agregar endpoints que manejen datos personales, al modificar esquemas de BD con datos de usuarios, antes de un deploy, o como auditoría periódica.

## Flujo

1. **Codebase Memory** — identificar qué datos personales maneja el módulo modificado.
2. **Revisión por principio:**

### 📋 Datos Personales Detectados
Identificar en el código modificado:
- RUT / RUN
- Nombre completo
- Correo electrónico
- Teléfono
- Dirección
- IP
- Geolocalización
- Datos biométricos
- Datos financieros
- Cookies / tracking

### 🎯 Minimización (Ley 21.719 Art. 4)
- [ ] ¿Solo se recopilan los datos estrictamente necesarios?
- [ ] ¿Hay campos en la BD que no se usan? → Eliminar
- [ ] ¿Los formularios piden solo lo mínimo?

### ✅ Consentimiento (Ley 21.719 Art. 6-7)
- [ ] ¿Hay consentimiento explícito del titular?
- [ ] ¿El consentimiento es revocable?
- [ ] ¿Las finalidades están claramente informadas?

### 🗑️ Derecho al Olvido (Ley 21.719 Art. 13)
- [ ] ¿Existe endpoint/mecanismo para eliminar datos personales?
- [ ] ¿El borrado es físico o lógico? (debe ser físico cuando corresponda)
- [ ] ¿Se propagó la eliminación a sistemas relacionados?

### 🔄 Portabilidad (Ley 21.719 Art. 14)
- [ ] ¿El usuario puede exportar sus datos?
- [ ] ¿Formato estándar? (JSON, CSV)

### 🔍 Acceso y Rectificación
- [ ] ¿El usuario puede consultar sus datos?
- [ ] ¿Puede solicitar correcciones?

### 📝 Auditoría
- [ ] ¿Se registra quién accedió a datos personales, cuándo y por qué?
- [ ] ¿Los logs de auditoría están protegidos contra alteración?

### 🕐 Retención
- [ ] ¿Política de retención definida?
- [ ] ¿Los datos se eliminan automáticamente después del período legal?
- [ ] ¿Hay datos acumulados sin propósito? → Programar purga

### 🛡️ Medidas de Seguridad
- [ ] ¿Datos personales cifrados en reposo? (BD, backups)
- [ ] ¿Datos personales cifrados en tránsito? (HTTPS)
- [ ] ¿Acceso a datos personales con mínimo privilegio?

## Salida

```
## 🔒 Revisión de Privacidad

### Datos personales identificados
- <campo> → <ubicación> → <riesgo: alto/medio/bajo>

### 🚩 Hallazgos
- [ ] <hallazgo> — <severidad>

### 📋 Checklist Ley 21.719
Minimización:     ✅ | ❌ | ⚠️
Consentimiento:   ✅ | ❌ | ⚠️
Olvido:           ✅ | ❌ | ⚠️
Portabilidad:     ✅ | ❌ | ⚠️
Auditoría:        ✅ | ❌ | ⚠️
Retención:        ✅ | ❌ | ⚠️

### ✅ Resumen
**<X> hallazgos — <cumple/no cumple parcialmente/no cumple>**
```
