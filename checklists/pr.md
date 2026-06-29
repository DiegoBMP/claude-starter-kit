# Checklist: Pull Request

## 🔍 Before submitting

- [ ] Código compila sin errores
- [ ] Tests pasan
- [ ] Sin `console.log` / `debugger` / `TODO` sin issue
- [ ] Sin secretos hardcodeados
- [ ] Conventional commit message: `tipo(alcance): descripción`

## 🏗️ Arquitectura

- [ ] Respeta separación routes → controllers → services → repositories (server)
- [ ] DTOs usados en fronteras (API, BD)
- [ ] Sin acceso a BD desde controllers
- [ ] Sin lógica de negocio en capa de presentación

## 🛡️ Seguridad

- [ ] Toda entrada validada (schema validation en runtime)
- [ ] Sin SQL concatenado
- [ ] Auth validada en endpoints protegidos
- [ ] Permisos verificados (no solo "autenticado")
- [ ] Errores no filtran stack traces ni info interna
- [ ] CORS configurado (si aplica)

## 🔒 Privacidad

- [ ] No se registran datos personales en logs
- [ ] No se exponen datos sensibles en respuestas API
- [ ] Datos mínimos en payloads (minimización)
- [ ] Si hay datos personales nuevos: checklist de privacidad ejecutado

## 📦 Dependencias

- [ ] Sin dependencias nuevas sin revisar
- [ ] Sin dependencias con vulnerabilidades conocidas
- [ ] Dependencias correctas en `package.json` (dependencies vs devDependencies)

## 🧪 Tests

- [ ] Cobertura para el nuevo código (unitarias donde aplique)
- [ ] Casos borde cubiertos (vacío, error, límites)
- [ ] Tests existentes no rotos

## 📚 Documentación

- [ ] README actualizado si cambió la configuración o el flujo
- [ ] Comentarios de código solo si explican el "por qué", no el "qué"
- [ ] Tipos actualizados en shared/
