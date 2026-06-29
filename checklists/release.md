# Checklist: Release

## 🔄 Preparación

- [ ] Rama `main` actualizada y compila
- [ ] Version bump (semver): `major.minor.patch` según conventional commits
- [ ] CHANGELOG / release notes actualizados
- [ ] Tags git: `git tag vX.Y.Z && git push origin vX.Y.Z`
- [ ] Tests pasan en CI
- [ ] `pnpm audit` sin vulnerabilidades críticas/altas

## 🗄️ Base de datos

- [ ] Migraciones Drizzle listas y probadas
- [ ] Migraciones forward y rollback verificados
- [ ] Backup de BD realizado (si aplica)
- [ ] Migraciones aplicadas en staging y verificadas

## ⚙️ Configuración

- [ ] Variables de entorno actualizadas en el entorno destino
- [ ] Secretos rotados si es necesario
- [ ] URLs/endpoints de producción correctos
- [ ] CORS con orígenes de producción

## 🐳 Deploy

- [ ] Docker image construida y etiquetada
- [ ] Health check endpoint responde
- [ ] Logs del deploy sin errores
- [ ] Versión desplegada coincide con el tag

## 🧪 Smoke test post-deploy

- [ ] API responde (200 en health check)
- [ ] Login/autenticación funciona
- [ ] Flujo crítico verificado (crear, leer, actualizar, eliminar)
- [ ] Frontend carga sin errores de consola
- [ ] Errores 404/500 manejados correctamente

## 📊 Monitoreo

- [ ] Logs sin errores inesperados
- [ ] Métricas dentro de rangos normales
- [ ] Alertas configuradas para el nuevo release

## 🔙 Rollback plan

- [ ] Comando/script de rollback definido
- [ ] Tiempo estimado de rollback conocido
- [ ] Último tag estable identificado
