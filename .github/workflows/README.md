# GitHub Actions Workflows - RITMO

## 📋 Workflows Configurados

### `claude-ci.yml` - CI para Agentes Claude

**Propósito**: Validación automática de PRs generados por agentes Claude.

**Triggers**:
- Push a ramas `claude/**`
- Pull requests a `master`/`main`

**Jobs Incluidos**:

1. **📊 Análisis Estático** (`analyze`)
   - `flutter analyze`
   - Verificación de formato de código
   - Timeout: 10 minutos

2. **🧪 Tests Unitarios** (`test`)
   - `flutter test --coverage`
   - Upload de coverage a Codecov
   - Timeout: 15 minutos

3. **🌍 Verificación i18n** (`i18n-check`)
   - Generación de traducciones
   - Detección de strings hardcoded
   - Warning si >150 strings sin traducir

4. **🏗️ Validación de Build** (`build-check`)
   - Build de APK debug
   - Upload de artifact (7 días retención)
   - Timeout: 20 minutos

5. **🔐 Security Scan** (`security`)
   - Detección de secrets expuestos
   - Verificación que `firebase_options.dart` no cambió
   - Patrones de API keys

6. **💬 Comentar Resultados** (`comment-results`)
   - Crea comentario en PR con resultados
   - Checklist para revisor humano
   - Solo en pull requests

7. **🚧 Gate de Aprobación** (`require-approval`)
   - Bloquea merge automático para `claude/**`
   - Verifica que no sea WIP/DRAFT
   - **Requiere aprobación humana**

---

## 🔐 Seguridad y Gates

### Ramas `claude/**`

**Protecciones Automáticas**:
- ✅ CI debe pasar (7 jobs)
- ✅ Aprobación humana requerida
- ✅ No merge automático
- ✅ Verificación de secrets

### Ramas Protegidas Recomendadas

Configurar en GitHub → Settings → Branches:

**Para `master`**:
- ✅ Require pull request before merging
- ✅ Require status checks to pass:
  - `Análisis Estático`
  - `Tests Unitarios`
  - `Build Validation`
  - `Security Scan`
- ✅ Require at least 1 approval
- ✅ Dismiss stale reviews
- ✅ Require review from Code Owners (opcional)

---

## 📊 Artifacts Generados

### APK Debug
- **Nombre**: `app-debug-apk`
- **Ruta**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Retención**: 7 días
- **Uso**: Testing manual de PRs

### Coverage Report
- **Plataforma**: Codecov
- **Archivo**: `coverage/lcov.info`
- **Flags**: `unittests`
- **URL**: `https://codecov.io/gh/<owner>/<repo>`

---

## 🚀 Uso Típico

### Workflow del Agente

1. **Agente crea branch** `claude/fix-overflow`

2. **Agente hace cambios** y push

3. **CI se ejecuta automáticamente**:
   ```
   ✅ Análisis Estático - Passed
   ✅ Tests Unitarios - Passed
   ✅ Verificación i18n - Passed
   ✅ Build Validation - Passed
   ✅ Security Scan - Passed
   ```

4. **Agente crea PR** a `master`

5. **CI comenta en PR** con resultados y checklist

6. **Gate bloquea merge** hasta aprobación humana

7. **Revisor humano**:
   - Revisa código
   - Verifica tests
   - Aprueba PR

8. **Merge a master** ✅

---

## 🛠️ Configuración Adicional

### Codecov (Opcional)

1. Crear cuenta en https://codecov.io

2. Agregar secreto en GitHub:
   ```
   Settings → Secrets → Actions
   Nombre: CODECOV_TOKEN
   Valor: <token de codecov>
   ```

3. Badge para README:
   ```markdown
   [![codecov](https://codecov.io/gh/<owner>/<repo>/branch/master/graph/badge.svg)](https://codecov.io/gh/<owner>/<repo>)
   ```

### GitHub Packages (Opcional)

Para caché de dependencias:

```yaml
- name: Cache Flutter packages
  uses: actions/cache@v3
  with:
    path: ~/.pub-cache
    key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.yaml') }}
    restore-keys: |
      ${{ runner.os }}-pub-
```

---

## 📝 Customización

### Agregar Nuevo Check

1. Editar `.github/workflows/claude-ci.yml`

2. Agregar nuevo job:
   ```yaml
   my-custom-check:
     name: 🎯 Custom Check
     runs-on: windows-latest
     steps:
       - uses: actions/checkout@v4
       - name: Run custom check
         run: ./scripts/my-check.ps1
   ```

3. Agregar a `needs` del job `require-approval`:
   ```yaml
   needs: [analyze, test, ..., my-custom-check]
   ```

### Modificar Timeouts

Ajustar `timeout-minutes` en cada job según necesidad:
```yaml
timeout-minutes: 15  # Aumentar si tests tardan más
```

### Agregar Notificaciones

Slack:
```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 🚨 Troubleshooting

### "flutter: command not found"

**Causa**: Flutter no instalado en runner

**Solución**: Verificar que `subosito/flutter-action@v2` está presente

### "Tests timeout"

**Causa**: Tests tardan más de 15 minutos

**Solución**: Aumentar `timeout-minutes` en job `test`

### "Security scan falla"

**Causa**: Posible secret detectado

**Solución**:
1. Revisar archivos modificados
2. Mover secrets a `.env` o secret manager
3. Actualizar `.gitignore`

### "firebase_options.dart modificado"

**Causa**: Archivo de configuración Firebase cambió

**Solución**:
- Si es intencional: Aprobar manualmente
- Si es error: Revertir cambios

---

## 📚 Referencias

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Flutter CI/CD](https://docs.flutter.dev/deployment/cd)
- [Codecov Docs](https://docs.codecov.com)
- [Plan Maestro](../Plan%20Maestro%20—%20Claude%20Code%20+%20Agents.pdf)

---

**Versión**: 1.0.0
**Última actualización**: 2025-10-05
**Parte de**: Plan Maestro Claude Code + Agents para RITMO
