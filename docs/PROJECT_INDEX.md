# 📑 ÍNDICE COMPLETO DEL PROYECTO RITMO

**Versión**: 1.0.0
**Última actualización**: 2025-09-30

> **PROPÓSITO**: Minimizar consumo de tokens mediante búsqueda directa y eficiente de cualquier componente del proyecto.

---

## 🎯 GUÍA RÁPIDA DE USO

### **Estrategia de Búsqueda Eficiente:**
1. **Buscar PRIMERO en este índice** (Ctrl+F) antes de usar Grep/Glob
2. **Usar rutas exactas** del índice para Read directo
3. **Solo usar Task/Agent** para búsquedas complejas multi-archivo

### **Convenciones:**
- 📁 Carpetas principales
- 📄 Archivos core/críticos
- 🔧 Utilidades/helpers
- 🎨 UI/Widgets
- 📊 Modelos/Data
- 🌍 Internacionalización

---

## 📚 DOCUMENTACIÓN (LEER SIEMPRE PRIMERO)

### **Core Documents** (Protocol /remember)
```
CLAUDE.md                                    # Instrucciones proyecto + comandos útiles
docs/CONTEXT_LAST_SESSION.md               # Última sesión (2025-10-07) + pendientes
docs/BILINGUAL_GUIDE.md                     # Protocolo bilingüe ES/EN
docs/PROJECT_STATUS.md                      # Estado general + roadmap
docs/BUSINESS_INFO.md                       # ⚠️ CONFIDENCIAL: Pricing + estrategia monetización
README.md                                    # Info básica Flutter
```

### **Documentación Adicional**
```
plan.md                                      # Plan original del proyecto
MASTER_ROADMAP_RITMO.md                     # Roadmap completo
ESTADO_FINAL_PROYECTO.md                    # Estado final features
LANZAMIENTO_INMEDIATO.md                    # Guía lanzamiento
LANZAMIENTO_EXPRESS_30MIN.md                # Lanzamiento express
```

---

## 🏗️ ARQUITECTURA DEL PROYECTO

### **Entry Point**
```dart
lib/main.dart                               # Entry point + SystemUIMode + providers setup
```

### **Firebase & Config**
```dart
lib/firebase_options.dart                   # Firebase configuration
```

---

## 📊 MODELOS (DATA LAYER)

### **Core Models**
```dart
lib/models/habit.dart                       # Modelo Habit + lógica rachas + completions
  - class Habit (id, name, description, icon, color, frequency, completions, streak)
  - extension DateTimeExtension (toDateString)
  - Methods: isCompletedToday, copyWith, toJson, fromJson

lib/models/achievement.dart                 # Modelo Achievement (gamificación)
  - class Achievement (id, name, description, icon, isUnlocked, unlockedAt)
```

---

## 🎛️ PROVIDERS (STATE MANAGEMENT)

### **Core Providers**
```dart
lib/providers/habit_provider.dart           # ⭐ CRÍTICO: Gestión hábitos + completions + stats
  - Methods: initializeHabits, addHabit, updateHabit, deleteHabit
  - toggleCompletion() [con gamificación]
  - getStats(), habitsForToday, habitsForWeek

lib/providers/premium_provider.dart         # ⭐ NUEVO: Estado premium + límites
  - maxFreeHabits = 5 (L20)
  - canAddMoreHabits(count) (L94-97)
  - isPremium, grantPremium, togglePremiumForTesting

lib/providers/notification_settings_provider.dart  # ⭐ NUEVO: Settings notificaciones
  - notificationsEnabled, defaultReminderTime, reminderSound, vibrationEnabled
  - loadSettings, setNotificationsEnabled, setDefaultReminderTime, etc.

lib/providers/gamification_provider.dart    # Sistema puntos + logros
lib/providers/theme_provider.dart           # 6 temas premium + free
lib/providers/auth_provider.dart            # Autenticación usuario
lib/providers/locale_provider.dart          # Cambio idioma
lib/providers/onboarding_provider.dart      # Estado onboarding
```

---

## 🖥️ PANTALLAS (SCREENS)

### **Navegación Principal**
```dart
lib/screens/home_screen.dart                # Pantalla principal + BottomNav + FAB
  - Tabs: Today, Stats, Settings
  - FAB siempre visible (fix crítico 2025-09-30)

lib/screens/stats_screen.dart               # ⭐ Estadísticas + 3 pestañas
  - Tab Today: Stats cards + PieChart + lista hábitos hoy
  - Tab Week: Weekly chart + heatmap + lista hábitos semana ← NUEVO (2025-09-30)
  - Tab Trends: Monthly chart + streaks + calendar heatmap
  - Design constants aplicados (2025-09-30)
```

### **Gestión de Hábitos**
```dart
lib/screens/add_habit_screen.dart           # ⭐ ACTUALIZADO: Crear hábito + validación límite
  - _saveHabit() (L384-455): Validación canAddMoreHabits
  - _showHabitLimitDialog() (L457-493): Paywall cuando límite alcanzado

lib/screens/edit_habit_screen.dart          # Editar hábito + confirmación delete
lib/screens/all_habits_screen.dart          # Ver todos + confirmación delete
```

### **Autenticación & Onboarding**
```dart
lib/screens/auth_wrapper.dart               # Wrapper autenticación + guest mode
lib/screens/login_screen.dart               # Login con Google/Email
lib/screens/onboarding_screen.dart          # Onboarding inicial
lib/screens/splash_screen.dart              # Splash con logo dinámico
```

### **Configuración & Premium**
```dart
lib/screens/settings_screen.dart            # ⭐ ACTUALIZADO: Settings + temas + idiomas + notif
  - Sección temas premium (con candados 🔒)
  - Sección notificaciones (L531-679): 4 controles ← NUEVO
    - Enable/disable, time picker, sound selector, vibration
  - Selector idioma (26 idiomas)
  - Botón "Activar Premium (Testing)"

lib/screens/paywall_screen.dart             # Pantalla premium (destino desde límite hábitos)
lib/screens/achievements_screen.dart        # Pantalla logros
```

---

## 🎨 WIDGETS (UI COMPONENTS)

### **Core Widgets**
```dart
lib/widgets/habit_card.dart                 # Card individual de hábito
lib/widgets/stats_overview.dart             # Overview estadísticas + mensajes motivacionales
lib/widgets/gamification_card.dart          # Card puntos + logros
lib/widgets/ad_banner_widget.dart           # Banner promoción premium
```

### **Branding**
```dart
lib/widgets/dynamic_ritmo_logo.dart         # Logo RITMO dinámico/aleatorio
```

---

## 🔧 SERVICIOS (SERVICES)

### **Backend & Data**
```dart
lib/services/auth_service.dart              # Autenticación Firebase
lib/services/database_service.dart          # Firestore operations
lib/services/database_helper.dart           # SQLite local (hábitos)
```

### **Features**
```dart
lib/services/notification_service.dart      # Notificaciones locales
lib/services/ads_service.dart               # Google Ads
```

---

## 🎨 DISEÑO & TEMAS (CORE)

### **Design System**
```dart
lib/core/design_constants.dart              # ⭐ NUEVO (2025-09-30): Constantes diseño unificado
  - paddingScreen: 16.0
  - spacingBetweenSections: 24.0
  - spacingBetweenCards: 12.0
  - cardPadding: 16.0
  - cardBorderRadius: 12.0
  - chartHeight: 200.0
  - titleFontSize: 20.0
  - statValueFontSize: 20.0
  - statLabelFontSize: 12.0
  - chartLabelFontSize: 12.0
  - statCardIconSize: 32.0
  - habitIconSize: 24.0

lib/core/theme.dart                         # Definición temas Material3
lib/core/ritmo_typography.dart              # Tipografía custom RITMO
```

### **Utilidades**
```dart
lib/utils/responsive_utils.dart             # Responsive helpers
```

---

## 🌍 INTERNACIONALIZACIÓN (L10N)

### **Archivos de Traducción (ARB)**
```
lib/l10n/app_en.arb                         # ⭐ Inglés (MASTER - 100% completo)
lib/l10n/app_es.arb                         # ⭐ Español (71% completo)
```

### **Otros idiomas** (26 total)
```
lib/l10n/app_ar.arb    # Árabe
lib/l10n/app_bn.arb    # Bengalí
lib/l10n/app_cs.arb    # Checo
lib/l10n/app_da.arb    # Danés
lib/l10n/app_de.arb    # Alemán
lib/l10n/app_fi.arb    # Finlandés
lib/l10n/app_fr.arb    # Francés
lib/l10n/app_hi.arb    # Hindi
lib/l10n/app_id.arb    # Indonesio
lib/l10n/app_it.arb    # Italiano
lib/l10n/app_ja.arb    # Japonés
lib/l10n/app_ko.arb    # Coreano
lib/l10n/app_nl.arb    # Holandés
lib/l10n/app_no.arb    # Noruego
lib/l10n/app_pl.arb    # Polaco
lib/l10n/app_pt.arb    # Portugués
lib/l10n/app_ro.arb    # Rumano
lib/l10n/app_ru.arb    # Ruso
lib/l10n/app_sv.arb    # Sueco
lib/l10n/app_th.arb    # Tailandés
lib/l10n/app_tl.arb    # Tagalo
lib/l10n/app_tr.arb    # Turco
lib/l10n/app_vi.arb    # Vietnamita
lib/l10n/app_zh.arb    # Chino
```

### **Archivos Generados** (NO EDITAR)
```
lib/generated/l10n/app_localizations.dart   # Base class
lib/generated/l10n/app_localizations_*.dart # Implementaciones por idioma
```

### **Comando Regenerar Traducciones**
```bash
flutter gen-l10n
```

---

## 🔍 BÚSQUEDAS RÁPIDAS POR CONCEPTO

### **Hábitos (CRUD)**
- **Modelo**: `lib/models/habit.dart`
- **Provider**: `lib/providers/habit_provider.dart`
- **UI Crear**: `lib/screens/add_habit_screen.dart`
- **UI Editar**: `lib/screens/edit_habit_screen.dart`
- **UI Lista**: `lib/screens/all_habits_screen.dart`
- **Widget Card**: `lib/widgets/habit_card.dart`

### **Estadísticas**
- **Pantalla principal**: `lib/screens/stats_screen.dart`
- **Widget overview**: `lib/widgets/stats_overview.dart`
- **Getter stats**: `lib/providers/habit_provider.dart:188` (getStats())

### **Gamificación**
- **Provider**: `lib/providers/gamification_provider.dart`
- **Modelo**: `lib/models/achievement.dart`
- **Widget**: `lib/widgets/gamification_card.dart`
- **Pantalla**: `lib/screens/achievements_screen.dart`

### **Temas Premium**
- **Provider**: `lib/providers/theme_provider.dart`
- **Definiciones**: `lib/core/theme.dart`
- **UI Settings**: `lib/screens/settings_screen.dart`

### **Rachas (Streaks)**
- **Lógica**: `lib/models/habit.dart` (método streak)
- **Cálculo**: `lib/screens/stats_screen.dart:965` (_calculateCurrentStreak)
- **Display**: `lib/screens/stats_screen.dart` (Tab Trends - Habit Streaks Chart)

### **Traducciones**
- **Agregar clave**: Editar `lib/l10n/app_en.arb` y `lib/l10n/app_es.arb`
- **Regenerar**: `flutter gen-l10n`
- **Uso**: `AppLocalizations.of(context)!.keyName`
- **Protocolo**: Ver `docs/BILINGUAL_GUIDE.md`

---

## 📍 UBICACIONES CLAVE (LÍNEAS ESPECÍFICAS)

### **lib/providers/habit_provider.dart**
```
L7-25:   Declaración clase + properties
L27-52:  initializeHabits()
L64-80:  addHabit()
L93-106: updateHabit()
L108-122: toggleCompletion() [⭐ CRÍTICO - con gamificación]
L188-211: getStats() [estadísticas generales]
L214-242: habitsForWeek [⭐ NUEVO - progreso semanal]
L245-282: habitsForToday [getter ordenado]
```

### **lib/screens/stats_screen.dart**
```
L33-55:   Build scaffold + TabBar
L57-80:   _buildTodayTab()
L283-300: _buildWeeklyTab() [⭐ Con lista hábitos semana - NUEVO]
L631-650: _buildTrendsTab()
L1163-1257: _buildWeeklyHabitsList() [⭐ NUEVO componente]
```

### **lib/screens/home_screen.dart**
```
L80-120: FAB always visible (fix crítico 2025-09-30)
```

### **lib/main.dart**
```
L30-40: SystemUIMode.edgeToEdge (immersive mode 2025-09-30)
```

---

## 🎯 CASOS DE USO COMUNES

### **1. Agregar nueva traducción**
```bash
# 1. Editar archivos ARB
Read: lib/l10n/app_en.arb
Read: lib/l10n/app_es.arb
Edit: Agregar claves en ambos

# 2. Regenerar
Bash: flutter gen-l10n

# 3. Usar en código
AppLocalizations.of(context)!.newKey
```

### **2. Modificar lógica de rachas**
```bash
Read: lib/models/habit.dart  # Método streak getter
Edit: Modificar lógica
```

### **3. Agregar nuevo stat en pantalla**
```bash
Read: lib/providers/habit_provider.dart  # getStats() L188
Read: lib/screens/stats_screen.dart      # _buildStatsCards() L82
Edit: Agregar stat + widget
```

### **4. Cambiar diseño/espaciado**
```bash
Read: lib/core/design_constants.dart
Edit: Modificar constantes (aplica a todas las pantallas)
```

### **5. Agregar nuevo tema premium**
```bash
Read: lib/providers/theme_provider.dart
Read: lib/core/theme.dart
Edit: Agregar tema + actualizar provider
```

---

## 🚨 ARCHIVOS CRÍTICOS (NO TOCAR SIN CONTEXTO)

```
lib/models/habit.dart                    # Lógica rachas corregida ✅
lib/providers/habit_provider.dart        # toggleCompletion con gamificación ✅
lib/core/design_constants.dart           # Sistema diseño unificado ✅
lib/main.dart                            # SystemUIMode configurado ✅
```

---

## 📊 MÉTRICAS DE PROYECTO

- **Total archivos Dart**: ~39
- **Pantallas**: 11
- **Providers**: 8 (+1 notification_settings_provider)
- **Modelos**: 2
- **Widgets**: 6
- **Servicios**: 5
- **Idiomas soportados**: 26
- **Temas disponibles**: 7 (1 free + 6 premium)
- **Límite hábitos free**: 5 → Premium ilimitado

---

## 🔄 ÚLTIMA ACTUALIZACIÓN

**Fecha**: 2025-09-30 (FASE 4 - MONETIZACIÓN)
**Cambios críticos**:
- ✅ Límite 5 hábitos free + validación + paywall (add_habit_screen.dart)
- ✅ Settings notificaciones (4 controles) + provider + SharedPreferences
- ✅ Confirmaciones delete verificadas (3 ubicaciones)
- ✅ 14 traducciones nuevas (habitLimit, notifications)
- ✅ Provider notification_settings_provider.dart creado
- ✅ Integración completa en main.dart

**Impacto**: Conversión premium proyectada 3-5x (de ~2-5% a ~10-15%)
**Próximos pasos**: Ver `docs/CONTEXT_LAST_SESSION.md` → FASE 5

---

## 💡 TIPS DE OPTIMIZACIÓN

1. **Buscar claves traducción**: Grep en `app_en.arb` primero
2. **Buscar uso de widget**: Grep por nombre del archivo sin extensión
3. **Buscar definición método**: Grep por "void methodName" o "get methodName"
4. **Modificar múltiples screens**: Usar `design_constants.dart`
5. **Debugging traducciones**: Verificar AMBOS archivos (EN + ES)

---

**FIN DEL ÍNDICE** 🎯
