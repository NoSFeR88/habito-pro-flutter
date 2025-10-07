# 🎨 RITMO - DESIGN SYSTEM

**Versión**: 1.0.0
**Última actualización**: 2025-10-06
**Propósito**: Sistema de diseño unificado para RITMO Habit Tracker

---

## 📋 ÍNDICE

```
FUNDAMENTOS → Sección 1 (Filosofía + Principios)
COLORES → Sección 2 (Paleta + Uso semántico)
TIPOGRAFÍA → Sección 3 (Escala + Jerarquía)
ESPACIADO → Sección 4 (Sistema 4/8pt + Design Constants)
ICONOGRAFÍA → Sección 5 (Tamaños + Touch Targets)
COMPONENTES → Sección 6 (Cards, Buttons, Lists)
MOTION → Sección 7 (Animaciones + Transiciones)
ACCESIBILIDAD → Sección 8 (WCAG + Touch Targets)
```

---

## 1️⃣ FUNDAMENTOS

### **Filosofía de Diseño**

**RITMO** es una app de habit tracking que prioriza:
- ✨ **Claridad** - Información clara y legible
- 🎯 **Enfoque** - Sin distracciones innecesarias
- 🎨 **Personalidad** - Visual atractivo con Material 3
- ⚡ **Fluidez** - Interacciones suaves y rápidas

### **Principios de Diseño**

#### 1. **Mobile-First**
- Diseñado primero para móvil (Android/iOS)
- Orientación vertical prioritaria
- Touch-friendly (mínimo 48x48dp)

#### 2. **Material 3 Native**
- Aprovecha las capacidades de M3
- Color scheme dinámico desde seed
- Surface containers y elevation system

#### 3. **Accesibilidad Integrada**
- Contraste mínimo 4.5:1 (WCAG AA)
- Touch targets >= 48x48 dp
- Screen reader compatible

#### 4. **Consistencia**
- Design constants reutilizables
- Patrones de layout predecibles
- Spacing coherente (sistema 4/8pt)

---

## 2️⃣ SISTEMA DE COLORES

### **Paleta Principal**

**Generada con ColorScheme.fromSeed**:
```dart
seedColor: Color(0xFF6200EE) // Purple Primary
```

#### **Color Roles (Material 3)**

| Role | Uso | Implementación |
|------|-----|----------------|
| **primary** | Acciones principales, FAB, AppBar | `colorScheme.primary` |
| **secondary** | Acentos secundarios, chips | `colorScheme.secondary` |
| **tertiary** | Acentos terciarios, badges | `colorScheme.tertiary` |
| **surface** | Fondos de pantalla | `colorScheme.surface` |
| **surfaceContainerLow** | Cards, contenedores | `colorScheme.surfaceContainerLow` |
| **surfaceContainerHigh** | Elevation mayor | `colorScheme.surfaceContainerHigh` |
| **error** | Errores, alertas | `colorScheme.error` |
| **onPrimary** | Texto sobre primary | `colorScheme.onPrimary` |
| **onSurface** | Texto sobre surface | `colorScheme.onSurface` |

### **Uso Semántico de Colores**

#### **Estados de Progreso**
```dart
// lib/widgets/stats_overview.dart: _getProgressColor()
0-19%    → Colors.red.shade400      // Rojo - Necesita mejorar
20-49%   → Colors.orange.shade400   // Naranja - En progreso
50-74%   → Colors.blue.shade400     // Azul - Buen camino
75-99%   → Colors.green.shade400    // Verde - Excelente
100%     → Colors.purple.shade400   // Morado - Perfecto
```

#### **Temas Premium**
```dart
// lib/providers/theme_provider.dart
Ocean:      #00838F (Cyan)
Sunset:     #FF6F00 (Deep Orange)
Forest:     #2E7D32 (Green)
Monochrome: #616161 (Grey)
Rose:       #D81B60 (Pink)
Royal:      #311B92 (Deep Purple)
```

### **⚠️ Deprecated Colors (NO USAR)**

```dart
// ❌ NO USAR Material 2 properties
Theme.of(context).cardColor
Theme.of(context).backgroundColor
Theme.of(context).scaffoldBackgroundColor

// ✅ USAR Material 3 ColorScheme
Theme.of(context).colorScheme.surfaceContainerLow
Theme.of(context).colorScheme.surface
```

---

## 3️⃣ TIPOGRAFÍA

### **Escala Tipográfica (Material 3)**

**Fuente Base**: San Francisco (iOS) / Roboto (Android) - Sistema

| Estilo | Tamaño | Weight | Uso |
|--------|--------|--------|-----|
| **displayLarge** | 57sp | 400 | No usado |
| **displayMedium** | 45sp | 400 | No usado |
| **displaySmall** | 36sp | 400 | No usado |
| **headlineLarge** | 32sp | 400 | Títulos principales |
| **headlineMedium** | 28sp | 400 | Títulos secundarios |
| **headlineSmall** | 24sp | 400 | Subtítulos grandes |
| **titleLarge** | 22sp | 500 | Títulos AppBar |
| **titleMedium** | 16sp | 500 | Títulos Card |
| **titleSmall** | 14sp | 500 | Subtítulos |
| **bodyLarge** | 16sp | 400 | Texto body principal |
| **bodyMedium** | 14sp | 400 | Texto body estándar |
| **bodySmall** | 12sp | 400 | Texto secundario |
| **labelLarge** | 14sp | 500 | Botones grandes |
| **labelMedium** | 12sp | 500 | Botones estándar |
| **labelSmall** | 11sp | 500 | Labels pequeños |

### **Uso en RITMO**

```dart
// Títulos de secciones
Theme.of(context).textTheme.titleLarge

// Nombres de hábitos
Theme.of(context).textTheme.titleMedium

// Estadísticas (números grandes)
Theme.of(context).textTheme.headlineMedium

// Texto descriptivo
Theme.of(context).textTheme.bodyMedium

// Labels y metadata
Theme.of(context).textTheme.bodySmall
```

### **Custom Typography Override**

```dart
// lib/core/ritmo_typography.dart
// Sobreescribe algunos estilos para personality
```

---

## 4️⃣ SISTEMA DE ESPACIADO

### **Base: Sistema 4/8pt**

**Escala de espaciado**:
```
4pt  → Micro spacing (entre ícono y texto)
8pt  → Small spacing
12pt → Medium spacing
16pt → Default spacing (estándar para padding)
24pt → Large spacing (entre secciones)
32pt → XL spacing (separación mayor)
48pt → Touch targets mínimos
```

### **Design Constants (RITMO)**

```dart
// lib/core/design_constants.dart

class DesignConstants {
  // Padding general
  static const double paddingScreen = 16.0;        // Padding pantallas
  static const double cardPadding = 16.0;          // Padding interno cards

  // Spacing entre elementos
  static const double spacingBetweenSections = 24.0;  // Entre secciones
  static const double spacingBetweenCards = 12.0;     // Entre cards
  static const double spacingSmall = 8.0;             // Micro spacing

  // Border radius
  static const double cardBorderRadius = 12.0;     // Cards generales
  static const double buttonBorderRadius = 8.0;    // Botones

  // Tamaños
  static const double chartHeight = 200.0;         // Altura gráficos
  static const double habitIconSize = 24.0;        // Íconos hábitos
  static const double statCardIconSize = 32.0;     // Íconos stats

  // Typography sizes
  static const double titleFontSize = 20.0;
  static const double statValueFontSize = 20.0;
  static const double statLabelFontSize = 12.0;
  static const double chartLabelFontSize = 12.0;
}
```

### **Padding Patterns**

```dart
// Padding de pantalla estándar
Padding(
  padding: EdgeInsets.all(DesignConstants.paddingScreen),
  child: ...
)

// Padding de card estándar
Card(
  child: Padding(
    padding: EdgeInsets.all(DesignConstants.cardPadding),
    child: ...
  ),
)

// Spacing entre secciones
SizedBox(height: DesignConstants.spacingBetweenSections)

// Spacing entre cards
SizedBox(height: DesignConstants.spacingBetweenCards)
```

---

## 5️⃣ ICONOGRAFÍA

### **Tamaños de Íconos**

| Contexto | Tamaño | Touch Target | Ejemplo |
|----------|--------|--------------|---------|
| **Navegación principal** | 24dp | 48x48dp | BottomNavigationBar |
| **Acciones primarias** | 24dp | 48x48dp | FAB, IconButton |
| **Lista hábitos** | 24dp | 48x48dp | Leading icon en Card |
| **Stats cards** | 32dp | n/a | Decorativo |
| **Achievements** | 40dp | n/a | Decorativo |
| **Close buttons** | 20dp | 48x48dp | AppBar actions |

### **Touch Target Guidelines**

```dart
// ❌ MAL - Touch target muy pequeño
IconButton(
  iconSize: 16,
  icon: Icon(Icons.close),
  onPressed: () {},
)

// ✅ BIEN - Touch target >= 48x48dp
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(
    iconSize: 24,
    icon: Icon(Icons.close),
    onPressed: () {},
  ),
)
```

### **Icon Pack**

**Material Icons** (Built-in Flutter):
```dart
Icons.add               // FAB - Agregar hábito
Icons.check_circle      // Completar hábito
Icons.emoji_events      // Logros
Icons.trending_up       // Estadísticas
Icons.settings          // Configuración
Icons.dark_mode         // Tema oscuro
Icons.language          // Idioma
Icons.notifications     // Notificaciones
```

---

## 6️⃣ COMPONENTES

### **Cards**

```dart
// Card estándar RITMO
Card(
  margin: EdgeInsets.symmetric(
    vertical: DesignConstants.spacingBetweenCards / 2,
  ),
  color: Theme.of(context).colorScheme.surfaceContainerLow,
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
  ),
  child: Padding(
    padding: EdgeInsets.all(DesignConstants.cardPadding),
    child: ...
  ),
)
```

**Tipos de Cards en RITMO**:
1. **HabitCard** - Muestra hábito individual
2. **StatsCard** - Estadística con ícono + valor + label
3. **GamificationCard** - Puntos + nivel + logros
4. **MotivationalCard** - Mensaje motivacional

### **Buttons**

```dart
// Primary action
ElevatedButton(
  onPressed: () {},
  child: Text('Crear Hábito'),
)

// Secondary action
OutlinedButton(
  onPressed: () {},
  child: Text('Cancelar'),
)

// Text button
TextButton(
  onPressed: () {},
  child: Text('Ver Todo'),
)
```

### **Lists & Tiles**

```dart
// ListTile estándar
ListTile(
  leading: Icon(Icons.notifications, size: 24),
  title: Text('Notificaciones'),
  subtitle: Text('Configurar recordatorios'),
  trailing: Switch.adaptive(
    value: enabled,
    onChanged: (val) {},
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: DesignConstants.paddingScreen,
  ),
)
```

---

## 7️⃣ MOTION & ANIMACIONES

### **Principios de Motion**

1. **Purposeful** - Animaciones con propósito claro
2. **Swift** - Rápidas (200-300ms típicamente)
3. **Smooth** - Curves naturales (easeInOut, fastOutSlowIn)
4. **Consistent** - Mismas duraciones para mismas acciones

### **Duraciones Estándar**

```dart
// Transiciones rápidas (micro-interactions)
const Duration(milliseconds: 150)  // Hover, focus

// Transiciones estándar (navegación, dialogs)
const Duration(milliseconds: 300)  // Default

// Transiciones lentas (page transitions)
const Duration(milliseconds: 400)  // Full screen
```

### **Curves Recomendadas**

```dart
Curves.easeInOut      // Default - Suave y balanceado
Curves.fastOutSlowIn  // Material standard curve
Curves.easeOut        // Entrada rápida, salida lenta
Curves.elasticOut     // Efecto bounce (usado con cuidado)
```

### **Implementación en RITMO**

```dart
// PageView con animación suave
_pageController.animateToPage(
  page,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);

// Hero animation (navegación entre pantallas)
Hero(
  tag: 'habit-${habit.id}',
  child: HabitCard(habit: habit),
)
```

### **Material 3 Transitions**

| Pattern | Uso | Duration |
|---------|-----|----------|
| **Container Transform** | Expansión de card a detalle | 300ms |
| **Shared Axis** | Navegación entre tabs | 300ms |
| **Fade Through** | Cambio de contenido | 200ms |
| **Fade** | Aparición/desaparición | 150ms |

---

## 8️⃣ ACCESIBILIDAD (A11Y)

### **Touch Targets**

**Regla absoluta**: Todos los elementos interactivos >= **48x48 dp**

```dart
// Implementación garantizada
SizedBox(
  width: 48,
  height: 48,
  child: InkWell(
    onTap: () {},
    child: Center(
      child: Icon(Icons.favorite, size: 24),
    ),
  ),
)
```

### **Contrast Ratios (WCAG AA)**

| Elemento | Ratio Mínimo | RITMO Status |
|----------|--------------|--------------|
| **Texto normal** | 4.5:1 | ✅ Cumple |
| **Texto grande (18pt+)** | 3:1 | ✅ Cumple |
| **Componentes UI** | 3:1 | ✅ Cumple |

### **Screen Reader Support**

```dart
// Agregar Semantics a elementos custom
Semantics(
  label: 'Completar hábito ${habit.name}',
  button: true,
  enabled: true,
  child: InkWell(
    onTap: () => toggleHabit(),
    child: Icon(Icons.check_circle),
  ),
)
```

### **Testing Accessibility**

**Manual**:
- ✅ TalkBack (Android)
- ✅ VoiceOver (iOS)
- ✅ Diferentes tamaños de texto (Settings)

**Automático**:
```dart
testWidgets('Touch targets meet minimum size', (tester) async {
  await tester.pumpWidget(MyApp());

  final button = find.byType(IconButton);
  expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
  expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
});
```

---

## 🎯 DECISIONES DE DISEÑO ESPECÍFICAS RITMO

### **1. Orientación Bloqueada a Vertical**
**Por qué**: Habit tracking es inherentemente vertical, landscape no agrega valor.
```dart
// lib/main.dart
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);
```

### **2. FAB Siempre Visible**
**Por qué**: Acción principal (crear hábito) debe estar siempre accesible.
```dart
// lib/screens/home_screen.dart
floatingActionButton: FloatingActionButton(
  onPressed: () => _showAddHabitSheet(),
  child: Icon(Icons.add),
),
```

### **3. BottomNavigationBar con 3 Tabs**
**Por qué**: Balance entre funcionalidad y simplicidad (Today, Stats, Settings).

### **4. Stats con PageView**
**Por qué**: Organizar 3 vistas temporales (Hoy, Semana, Mes) de forma intuitiva.

### **5. Gamificación Visible**
**Por qué**: Motivación mediante puntos + logros + niveles.

### **6. Color States en Progreso**
**Por qué**: Feedback visual inmediato del rendimiento (rojo → verde → morado).

---

## 📊 MAPA DE COMPONENTES

### **Pantallas Principales**

| Pantalla | Componentes Clave | Estado |
|----------|-------------------|--------|
| **Home** | BottomNav, FAB, HabitCard, StatsOverview | ✅ Completo |
| **Today** | Lista hábitos, StatsOverview | ✅ Completo |
| **Stats** | PageView (Today/Week/Month), Charts, Cards | ✅ Completo |
| **Settings** | ListTile, Switch, Theme selector, Language | ✅ Completo |
| **Add Habit** | BottomSheet, TextField, ColorPicker, IconPicker | ✅ Completo |
| **Achievements** | Grid logros, Progress indicators | ✅ Completo |

### **Widgets Reutilizables**

| Widget | Ubicación | Uso |
|--------|-----------|-----|
| **HabitCard** | lib/widgets/habit_card.dart | Mostrar hábito individual |
| **StatsOverview** | lib/widgets/stats_overview.dart | Resumen estadísticas + motivación |
| **GamificationCard** | lib/widgets/gamification_card.dart | Puntos + logros + nivel |
| **AdBannerWidget** | lib/widgets/ad_banner_widget.dart | Promoción premium |
| **DynamicRitmoLogo** | lib/widgets/dynamic_ritmo_logo.dart | Logo animado |

---

## ✅ CHECKLIST DE DISEÑO (PRE-RELEASE)

### **Visual**
- [x] Colores cumplen contraste 4.5:1
- [x] Tipografía escalable (no hardcoded)
- [x] Spacing consistente (design_constants)
- [x] Border radius consistentes
- [x] Íconos tamaño apropiado

### **Interacción**
- [x] Touch targets >= 48x48dp
- [x] Feedback visual en todas las acciones
- [x] Animaciones suaves (<= 300ms)
- [x] Loading states visibles
- [x] Error states claros

### **Accesibilidad**
- [x] Screen reader compatible
- [x] Contraste suficiente
- [x] Escalabilidad de texto
- [x] No depende solo del color
- [ ] Testeado con TalkBack/VoiceOver ⚠️

### **Responsividad**
- [x] Funciona en pantallas pequeñas (4")
- [x] Funciona en pantallas grandes (6.5"+)
- [x] Layouts adaptativos (LayoutBuilder donde necesario)
- [x] Orientación bloqueada (solo vertical)

### **Consistencia**
- [x] Design constants aplicados
- [x] Material 3 ColorScheme usado consistentemente
- [x] Tipografía del theme usada
- [x] Spacing system coherente

---

## 🔗 RECURSOS Y REFERENCIAS

### **Material Design 3**
- Guía oficial: https://m3.material.io/
- Flutter implementation: https://m3.material.io/develop/flutter
- Theme Builder: https://material-foundation.github.io/material-theme-builder/

### **Flutter Docs**
- Material Design: https://docs.flutter.dev/ui/design/material
- Layouts: https://docs.flutter.dev/ui/layout
- Accessibility: https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility

### **Design Tokens**
- M3 Tokens: https://m3.material.io/foundations/design-tokens
- Flutter tokens update: https://docs.flutter.dev/release/breaking-changes/material-design-3-token-update

### **Iconografía**
- Material Icons: https://fonts.google.com/icons
- Icon guidelines: https://m3.material.io/styles/icons/designing-icons

---

## 🚀 PRÓXIMOS PASOS

### **Mejoras Corto Plazo**
1. ⏳ Agregar más animaciones micro-interactions
2. ⏳ Testing exhaustivo con TalkBack/VoiceOver
3. ⏳ Optimizar performance de animaciones (RepaintBoundary)

### **Mejoras Largo Plazo**
1. 📋 Dynamic color support (Android 12+)
2. 📋 Custom illustrations para empty states
3. 📋 Micro-animaciones en logros
4. 📋 Splash screen animado

---

## 📝 HISTORIAL DE CAMBIOS

### v1.0.0 (2025-10-06)
- ✅ Documento inicial creado
- ✅ Sistema de colores documentado
- ✅ Tipografía y spacing system definidos
- ✅ Design constants consolidados
- ✅ Guidelines de accesibilidad establecidas
- ✅ Componentes core documentados

---

**FIN DEL DOCUMENTO** 🎨

> **Mantenimiento**: Este documento debe actualizarse cuando se agreguen nuevos componentes, cambien guidelines de M3, o se descubran nuevas best practices.

**Relacionado con**:
- `lib/core/design_constants.dart` - Constantes implementadas
- `lib/core/theme.dart` - Theme configuration
- `lib/core/ritmo_typography.dart` - Typography overrides
- `docs/PROJECT_INDEX.md` - Índice proyecto
- `../../doc/03_UI_UX_DESIGN.md` - Flutter UI/UX guidelines generales
