# 💼 INFORMACIÓN DE NEGOCIO - RITMO App

**⚠️ CONFIDENCIAL - Solo para Product Owner**

**Versión**: 1.0.0
**Última actualización**: 2025-10-07
**Acceso**: Restringido (No incluir en outputs de Claude)

---

## 🚨 ADVERTENCIA PARA CLAUDE

**Este archivo contiene información confidencial de negocio.**

❌ **NUNCA mencionar** esta información en respuestas a menos que el usuario **explícitamente** pregunte sobre:
- Pricing / Precios
- Estrategia de monetización
- Proyecciones de revenue
- Estrategia competitiva

✅ Para aspectos técnicos, referirse solo a:
- "Sistema premium implementado"
- "Límite free vs premium"
- "Características premium disponibles"

---

## 💰 PRICING STRATEGY

### **Modelo de Monetización**

| Tier | Precio | Características |
|------|--------|-----------------|
| **Free** | $0 | 5 hábitos máximo |
| **Premium** | $2.99/mes | Hábitos ilimitados + temas premium + features avanzados |

### **Planes Disponibles** (Paywall)

```dart
// lib/screens/paywall_screen.dart
Mensual:  $3.99/mes
Anual:    $29.99/año (37% descuento vs mensual)
Lifetime: $49.99 (pago único)
```

### **Pricing en Traducciones**

```json
// lib/l10n/app_en.arb
"premiumPrice": "$2.99/month"
"pricingText": "Only $3.99/month - 20% less than competition"

// lib/l10n/app_es.arb
"premiumPrice": "$2.99/mes"
"pricingText": "Solo $3.99/mes - 20% menos que la competencia"
```

---

## 📊 REVENUE PROJECTIONS

### **Fase 1: Lanzamiento (0-1K usuarios)**
- **Target conversión**: 2-5%
- **Revenue estimado**: $50-150/mes
- **Estrategia**: Validar pricing, recoger feedback

### **Fase 2: Crecimiento (1K-5K usuarios)**
- **Target conversión**: 3-7%
- **Revenue estimado**: $150-500/mes
- **Estrategia**: Optimizar onboarding premium, A/B testing pricing

### **Fase 3: Escalado (5K-50K usuarios)**
- **Target conversión**: 5-10%
- **Revenue estimado**: $500-5K/mes
- **Estrategia**: Implementar RevenueCat, análisis cohorts

---

## 🎯 ESTRATEGIA COMPETITIVA

### **Análisis Competencia**

| App | Precio | Nuestro Diferencial |
|-----|--------|---------------------|
| **Habitify** | $4.99/mes | 20% más barato + mejor UX |
| **Streaks** | $4.99/mes | Multiplataforma + 26 idiomas |
| **Way of Life** | $4.99/mes | Temas dramáticos únicos |
| **Habitica** | $4.99/mes | Gamificación + sin elementos infantiles |

### **Propuesta de Valor**

**Premium a $2.99/mes se justifica con**:
1. ✅ Hábitos ilimitados (vs 5 free)
2. ✅ 6 temas premium dramáticos (ejecutivo, neon, aurora, etc.)
3. ✅ Sistema de gamificación robusto
4. ✅ 26 idiomas soportados
5. ✅ UI/UX profesional (Material 3)
6. ✅ Accessibility completa (WCAG AA)

---

## 🛠️ IMPLEMENTACIÓN TÉCNICA

### **Límite Free**

```dart
// lib/providers/premium_provider.dart
final maxFreeHabits = 5; // Free tier limit

// Validación
bool canAddMoreHabits(int currentCount) {
  if (isPremium) return true;
  return currentCount < maxFreeHabits;
}
```

### **Features Premium**

| Feature | Archivo | Free | Premium |
|---------|---------|------|---------|
| Hábitos ilimitados | `premium_provider.dart` | 5 max | ∞ |
| Temas premium | `theme_provider.dart` | 1 tema | 7 temas |
| Cloud sync | `database_service.dart` | ❌ | ✅ (futuro) |
| Export data | N/A | ❌ | ✅ (futuro) |
| Smart reminders | N/A | ❌ | ✅ (futuro) |

---

## 📈 MÉTRICAS DE MONETIZACIÓN

### **KPIs a Trackear**

1. **Conversion Rate**: % usuarios free → premium
2. **Churn Rate**: % cancelaciones mensuales
3. **LTV (Lifetime Value)**: Revenue promedio por usuario
4. **CAC (Customer Acquisition Cost)**: Costo por usuario adquirido
5. **Payback Period**: Tiempo en recuperar CAC

### **Metas por Fase**

| Métrica | Fase 1 | Fase 2 | Fase 3 |
|---------|--------|--------|--------|
| Conversion | 2-5% | 3-7% | 5-10% |
| Churn | <20% | <15% | <10% |
| LTV | $5-10 | $10-20 | $20-50 |
| Payback | <3 meses | <2 meses | <1 mes |

---

## 🚀 ROADMAP DE MONETIZACIÓN

### **Fase 4: Completada** ✅
- ✅ Límite 5 hábitos free
- ✅ Paywall screen con 3 planes
- ✅ Botón "Activar Premium (Testing)"
- ✅ Temas premium con candados
- ✅ Traducción de pricing (EN/ES)

### **Fase 5: Planificada** (3-6 meses)
- [ ] Integrar RevenueCat (IAP real)
- [ ] Implementar trial gratuito (7 días)
- [ ] A/B testing de pricing
- [ ] Promociones estacionales
- [ ] Referral program

### **Fase 6: Futuro** (6-12 meses)
- [ ] Lifetime plan con descuento
- [ ] Pricing regional (por país)
- [ ] Enterprise/Teams plan
- [ ] Partner integrations

---

## 🔐 SEGURIDAD DE PRICING

### **Archivos con Pricing Hardcoded**

⚠️ **Mantener sincronizados**:
```
lib/screens/paywall_screen.dart:32-52  → $3.99, $29.99, $49.99
lib/l10n/app_en.arb:108                 → $2.99/month
lib/l10n/app_es.arb:108                 → $2.99/mes
lib/providers/theme_provider.dart:18    → Comentario "$2.99/month"
```

### **Cambio de Pricing**

**Protocolo**:
1. Actualizar `BUSINESS_INFO.md` primero
2. Actualizar `paywall_screen.dart`
3. Actualizar `app_en.arb` y `app_es.arb`
4. Regenerar traducciones: `flutter gen-l10n`
5. Testing completo del paywall
6. PR con aprobación de @product-owner

---

## 📝 NOTAS DE PRODUCTO

### **Feedback de Usuarios Beta**
- ✅ Pricing percibido como justo ($2.99 vs $4.99 competencia)
- ✅ Temas premium son el mayor driver de conversión
- ⚠️ Algunos usuarios piden trial gratuito (considerar en v2)

### **Decisiones de Producto**

**¿Por qué $2.99 y no $3.99?**
- Psychological pricing (below $3 threshold)
- Competitivo vs mercado ($4.99 estándar)
- Justificado con features premium únicos

**¿Por qué límite de 5 hábitos?**
- Permite uso significativo (no demo)
- Genera necesidad de upgrade natural
- Basado en data: 70% usuarios usan 3-7 hábitos

---

## 🔗 REFERENCIAS

### **Archivos Técnicos Relacionados**
- `lib/providers/premium_provider.dart` - Lógica premium
- `lib/screens/paywall_screen.dart` - UI paywall
- `lib/screens/settings_screen.dart` - Toggle premium testing
- `lib/providers/theme_provider.dart` - Protección temas premium

### **Documentación**
- `docs/PROJECT_STATUS.md` - Estado fase monetización
- `docs/SETTINGS_ANALYSIS.md` - Análisis valor percibido
- `MASTER_ROADMAP_RITMO.md` - Roadmap completo monetización

---

**🔒 FIN DE INFORMACIÓN CONFIDENCIAL**

> ⚠️ **RECORDATORIO**: Claude debe evitar mencionar pricing específico en outputs técnicos a menos que sea explícitamente requerido por el usuario.
