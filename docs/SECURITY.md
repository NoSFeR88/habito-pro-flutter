# 🔒 SECURITY - SAST & Best Practices

**Versión**: 1.0.0
**Creado**: 2025-10-08 (Sesión 55)
**Parte de**: Plan Maestro Claude Code - Fase 2 (Pilot)

---

## 🎯 PROPÓSITO

Documentar las prácticas de seguridad implementadas en RITMO, incluyendo:
- ✅ SAST (Static Application Security Testing)
- ✅ Secrets Detection
- ✅ Dependency Scanning
- ✅ Code Quality Analysis
- ✅ OWASP Compliance

---

## 🛡️ SAST EN CI/CD

### **Pipeline de Seguridad**

Ubicación: `.github/workflows/security-scan.yml`

**Ejecuta automáticamente en**:
- Cada Pull Request a `master`/`main`
- Cada push a ramas `claude/**`
- Semanalmente (lunes 00:00 UTC)

---

## 🔍 COMPONENTES DE SEGURIDAD

### **1. Secrets Detection (Gitleaks)**

**Propósito**: Detectar secrets, API keys, tokens, passwords en código.

**Herramienta**: [Gitleaks](https://github.com/gitleaks/gitleaks)

**Qué detecta**:
- API keys (Google, Firebase, etc.)
- Passwords hardcoded
- Private keys (SSH, PGP)
- AWS credentials
- Tokens de autenticación
- Cualquier patrón que parezca secreto

**Configuración**:
```yaml
- name: Run Gitleaks
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Output**:
- ✅ Si no hay secrets: Job pasa
- 🔴 Si hay secrets: Job falla + reporte SARIF

**Acción si falla**:
1. Revisar `gitleaks-report` artifact
2. Identificar el secret expuesto
3. Remover del código
4. Revocar/rotar el secret
5. Reescribir historial si necesario (`git filter-branch`)

---

### **2. Dependency Scanning**

**Propósito**: Identificar dependencias con vulnerabilidades conocidas.

**Herramienta**: `flutter pub outdated` + OWASP Dependency-Check

**Qué verifica**:
- Versiones desactualizadas de packages
- Vulnerabilidades CVE reportadas
- Dependencias deprecated

**Configuración**:
```yaml
- name: Check for known vulnerabilities
  run: flutter pub outdated --show-all --json > outdated.json
```

**Output**: `dependency-report/outdated.json`

**Acción si hay vulnerabilidades**:
1. Revisar `outdated.json`
2. Actualizar packages vulnerables
3. Ejecutar tests para validar compatibilidad
4. Documentar en changelog

---

### **3. Code Quality Analysis**

**Propósito**: Detectar code smells, anti-patterns, inseguridades en código.

**Herramienta**: `flutter analyze`

**Qué detecta**:
- Null safety violations
- Unused variables/imports
- Deprecated API usage
- Potential null dereferences
- Code complexity issues

**Configuración**:
```yaml
- name: Run Flutter Analyze
  run: flutter analyze --no-fatal-infos --no-fatal-warnings
```

**Baseline**: `.github/BASELINE_WARNINGS.md` (304 warnings aceptables)

**Acción si aumenta baseline**:
1. Revisar nuevos warnings
2. Corregir issues de seguridad
3. Documentar warnings aceptables
4. Actualizar baseline si justificado

---

### **4. OWASP Dependency Check**

**Propósito**: Análisis profundo de dependencias según OWASP Top 10.

**Herramienta**: [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)

**Cuándo ejecuta**: Semanalmente + push a `main`/`master`

**Qué verifica**:
- CVE database matching
- Retired dependencies
- Experimental vulnerabilities
- Supply chain risks

**Output**: Reporte HTML en `reports/`

**Acción si hay CVEs**:
1. Revisar severidad (Critical/High/Medium/Low)
2. Priorizar fixes según severidad
3. Actualizar/reemplazar dependencias
4. Validar con security team (si aplica)

---

## 📊 SECURITY SUMMARY

**Generado automáticamente** al finalizar pipeline de seguridad.

**Incluye**:
- ✅/🔴 Secrets Detection status
- ✅/⚠️ Dependency vulnerabilities count
- ✅/⚠️ Code quality issues count
- 📋 Recomendaciones de acción

**Dónde verlo**:
- GitHub Actions summary
- PR comments (automático)
- Artifacts descargables

---

## 🚨 POLÍTICAS DE SEGURIDAD

### **Archivos Prohibidos en Git**

**NUNCA commitear**:
```
❌ firebase_options.dart (con valores reales)
❌ google-services.json
❌ .env files
❌ Private keys (.pem, .key)
❌ Keystore files (.jks, .keystore)
❌ API keys hardcoded
```

**Protección**: `.gitignore` + Gitleaks

---

### **Secrets Management**

**Usar**:
- ✅ GitHub Secrets para CI/CD
- ✅ Environment variables (`.env` gitignored)
- ✅ Firebase Remote Config para configs dinámicos
- ✅ Flutter SecureStorage para datos sensibles del usuario

**No usar**:
- ❌ Hardcoded secrets en código
- ❌ Commits con secrets (aunque luego se remuevan)
- ❌ Plain text storage de tokens

---

### **Dependency Updates**

**Estrategia**:
1. **Revisar semanalmente** via `flutter pub outdated`
2. **Actualizar non-breaking** inmediatamente
3. **Evaluar breaking changes** antes de actualizar
4. **Probar exhaustivamente** después de updates
5. **Documentar** cambios en changelog

**Prioridad**:
- 🔴 **Critical CVEs**: Inmediato (< 24h)
- 🟡 **High CVEs**: Urgente (< 1 semana)
- 🟢 **Medium/Low**: Planificado (próximo sprint)

---

## 🔐 SECURE CODING PRACTICES

### **Validación de Entrada**

```dart
// ❌ MAL - Sin validación
void createHabit(String name) {
  database.insert(name);
}

// ✅ BIEN - Validación completa
void createHabit(String name) {
  if (name.trim().isEmpty) {
    throw ValidationException('Name cannot be empty');
  }
  if (name.length > 100) {
    throw ValidationException('Name too long');
  }

  // Sanitizar (prevenir injection)
  final sanitized = HtmlEscape().convert(name);
  database.insert(sanitized);
}
```

---

### **Autenticación Segura**

```dart
// ✅ Usar Firebase Auth (OAuth)
final userCredential = await FirebaseAuth.instance.signInWithGoogle();

// ❌ NO implementar auth custom sin expertise
```

---

### **Almacenamiento Seguro**

```dart
// ✅ Para datos sensibles
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);

// ❌ NO usar SharedPreferences para secrets
// final prefs = await SharedPreferences.getInstance();
// prefs.setString('auth_token', token); // ❌ Inseguro
```

---

## 📋 SECURITY CHECKLIST

### **Pre-Commit**
- [ ] No hay secrets hardcoded
- [ ] Validación de inputs implementada
- [ ] Datos sensibles en secure storage
- [ ] Gitleaks local pasa (si disponible)

### **Pre-PR**
- [ ] Security scan CI pasa (verde)
- [ ] No hay nuevas vulnerabilidades
- [ ] Baseline de warnings no aumentó
- [ ] Documentación de seguridad actualizada

### **Pre-Release**
- [ ] OWASP Dependency Check ejecutado
- [ ] Todas las vulnerabilidades críticas resueltas
- [ ] Penetration testing (si aplica)
- [ ] Security audit documentado

---

## 🚀 CONTINUOUS IMPROVEMENT

### **Métricas de Seguridad**

**Trackear**:
- Número de secrets detectados (meta: 0)
- Vulnerabilidades por severidad
- Tiempo promedio de resolución
- Warnings de código (trending)

**KPIs**:
- 🎯 **0 secrets** expuestos en git
- 🎯 **0 Critical/High CVEs** en producción
- 🎯 **< 7 días** para resolver High CVEs
- 🎯 **Baseline warnings** estable o decreciente

---

### **Training & Awareness**

**Para desarrolladores**:
- Leer este documento antes de contribuir
- Entender OWASP Top 10
- Conocer herramientas de security scanning
- Reportar vulnerabilidades inmediatamente

---

## 📚 RECURSOS

### **Herramientas**
- [Gitleaks](https://github.com/gitleaks/gitleaks) - Secrets detection
- [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)

### **Referencias**
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### **Reporting**
- **Security issues**: Reportar a project maintainer (no público)
- **Vulnerabilidades CVE**: Crear issue privado en GitHub

---

## 🔄 INCIDENT RESPONSE

### **Si se detecta secret expuesto**:

1. **Inmediato** (< 1 hora):
   - Revocar/rotar el secret inmediatamente
   - Analizar si fue usado maliciosamente
   - Notificar a security team

2. **Corto plazo** (< 24 horas):
   - Reescribir historial git si necesario
   - Actualizar código con nuevo secret
   - Verificar logs de uso del secret

3. **Documentación**:
   - Crear post-mortem
   - Actualizar procesos para prevenir recurrencia
   - Entrenar team sobre mejores prácticas

---

## ✅ COMPLIANCE

### **GDPR/Privacy**
- Datos de usuario encriptados
- Consentimiento explícito
- Derecho al olvido implementado

### **Mobile Security**
- SSL Pinning (si aplica)
- Obfuscación de código
- ProGuard/R8 en release builds

---

**🎯 OBJETIVO**: Seguridad proactiva, detección temprana, respuesta rápida.

---

*Creado: 2025-10-08 (Sesión 55)*
*Última actualización: 2025-10-08*
*Próxima revisión: 2025-11-08*
