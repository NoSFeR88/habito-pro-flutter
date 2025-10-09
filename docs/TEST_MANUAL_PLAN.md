# 🧪 PLAN DE TEST MANUAL - RITMO v1.0.1+2

**Fecha**: 2025-10-08
**Tester**: Usuario
**Objetivo**: Validar app completa antes de deployment a Play Store
**Duración estimada**: 50 minutos
**Build**: Debug APK

---

## 📱 REQUISITOS PREVIOS

### Dispositivo de test:
- [ ] Android físico o emulador configurado
- [ ] APK debug instalado: `app-debug.apk`
- [ ] Internet disponible (Firebase, notificaciones)
- [ ] Permisos de notificaciones habilitados
- [ ] Almacenamiento limpio (simular usuario nuevo)

### Herramientas:
- [ ] Capturador de pantalla (nativo Android o ADB)
- [ ] Temporizador para notificaciones
- [ ] Hoja de notas para bugs

---

## 🎯 FASE 1: TEST INICIAL (15 min)

### 1.1 Primera instalación y Onboarding ✨

**Objetivo**: Validar nuevo onboarding rediseñado

**Pasos**:
1. [ ] Abrir app por primera vez
2. [ ] Verificar splash screen (logo RITMO)
3. [ ] Entrar al nuevo onboarding

**Página 1: Gamificación** 🎮
- [ ] Se ve el icono de fuego con racha
- [ ] Badge "+5 pts" flotante visible
- [ ] Título: "¡Convierte hábitos en juego!"
- [ ] 3 feature cards con iconos coloridos:
  - [ ] "5 puntos" - Trofeo amarillo
  - [ ] "Rachas" - Fuego naranja
  - [ ] "Logros" - Medalla púrpura
- [ ] Gradiente de fondo sutil
- [ ] Page indicator (1/3) animado
- [ ] Botón "Siguiente" con flecha

4. [ ] **Pulsar "Siguiente"**

**Página 2: Visualización** 📊
- [ ] Mockup de gráfico de barras animado
- [ ] 7 barras (L-D) con alturas diferentes
- [ ] Título: "Visualiza tu progreso"
- [ ] 2 feature cards:
  - [ ] "Gráficos" - Torta azul
  - [ ] "Heatmap" - Calendario verde
- [ ] Page indicator (2/3)
- [ ] Botón "Siguiente"

5. [ ] **Pulsar "Siguiente"**

**Página 3: Personalización** 🎨
- [ ] Stack de 4 previews de themes flotantes
- [ ] Colores: azul, púrpura, naranja, teal
- [ ] Título: "¡Haz tu app única!"
- [ ] 2 feature cards:
  - [ ] "9 Temas" - Paleta rosa
  - [ ] "Modo Oscuro" - Luna índigo
- [ ] Page indicator (3/3)
- [ ] Botón "Comenzar mi ritmo" con check
- [ ] Texto abajo: "Gratis • Sin tarjeta"

6. [ ] **Pulsar "Comenzar mi ritmo"**
7. [ ] Verificar que entra a HomeScreen vacía

**✅ RESULTADO ESPERADO**:
- Onboarding fluido sin crashes
- Animaciones suaves (fade transitions)
- Diseño moderno y atractivo
- Skip button funcional (opcional: probar)
- NO se menciona idiomas

**❌ BUGS POSIBLES**:
- [ ] Crash al cambiar de página
- [ ] Imágenes no cargan
- [ ] Textos cortados o overflows
- [ ] Botones no responden

---

### 1.2 Crear primer hábito

**Objetivo**: Validar flujo de creación

**Pasos**:
1. [ ] En HomeScreen, ver mensaje "No hay hábitos aún"
2. [ ] Pulsar FAB "+" o botón "Crear primer hábito"
3. [ ] Pantalla AddHabitScreen se abre
4. [ ] Completar formulario:
   - **Nombre**: "Ejercicio matutino"
   - **Descripción**: "30 min cardio"
   - **Icono**: Fitness (seleccionar)
   - **Color**: Púrpura (seleccionar)
   - **Frecuencia**: Diaria (7 días)
   - **Recordatorio**: 09:00 AM ✅ Activado
5. [ ] Pulsar "Guardar"
6. [ ] Volver a HomeScreen

**✅ RESULTADO ESPERADO**:
- Hábito aparece en lista
- Card con color púrpura
- Icono fitness visible
- Checkbox para completar hoy

**❌ BUGS POSIBLES**:
- [ ] No guarda el hábito
- [ ] Campos no validan
- [ ] Color/icono no se aplica

---

### 1.3 Crear 2 hábitos más

**Pasos**:
1. [ ] Crear "Leer 20 min"
   - Frecuencia: Lun-Mié-Vie
   - Color: Verde
   - Icono: Libro
   - Sin recordatorio

2. [ ] Crear "Meditar 10 min"
   - Frecuencia: Diaria
   - Color: Azul
   - Icono: Spa
   - Recordatorio: 20:00

3. [ ] Verificar 3 hábitos en HomeScreen

**✅ RESULTADO ESPERADO**:
- 3 cards de hábitos visibles
- Colores distintos aplicados correctamente
- Iconos únicos en cada card

---

### 1.4 Completar hábitos y gamificación

**Objetivo**: Validar sistema de puntos y gamificación

**Pasos**:
1. [ ] Pulsar checkbox en "Ejercicio matutino"
2. [ ] Verificar animación de completado
3. [ ] Ver badge "+5 pts" flotante
4. [ ] Card con GamificationCard visible arriba
5. [ ] Verificar puntos totales: 5
6. [ ] Completar "Leer 20 min" → +5 pts
7. [ ] Completar "Meditar 10 min" → +5 pts
8. [ ] Total puntos: 15
9. [ ] Racha actual: 1 día

**✅ RESULTADO ESPERADO**:
- Cada checkbox toggle funciona
- Animación visual al completar
- Puntos se suman correctamente
- GamificationCard con:
  - "15 Puntos" con trofeo
  - "Racha: 1 día" con fuego
  - Progress bar visible

**❌ BUGS POSIBLES**:
- [ ] Puntos no se suman
- [ ] Racha no actualiza
- [ ] Animación falla
- [ ] GamificationCard no aparece

---

## 🔍 FASE 2: TEST CRÍTICO (20 min)

### 2.1 Estadísticas mejoradas

**Objetivo**: Validar gráficas con nuevo diseño

**Pasos**:
1. [ ] Ir a tab "Estadísticas" (bottom nav)
2. [ ] Tab "HOY":
   - [ ] Ver 3 stat cards arriba (Total/Racha/Porcentaje)
   - [ ] PieChart con:
     - Verde brillante (#4CAF50) = 3 completados
     - Naranja (#FF9800) = 0 pendientes
     - Leyenda abajo con colores
     - Badges con iconos ✓
   - [ ] Lista de hábitos de hoy con checkmarks

3. [ ] Tab "SEMANA":
   - [ ] LineChart semanal con:
     - Color azul vibrante (#2196F3)
     - Gradiente debajo de la línea
     - Dots colorizados (verde >75%, naranja 50-75%, rojo <50%)
     - Grid sutil visible
     - Labels L-M-X-J-V-S-D
     - Tooltip al tocar (opcional si funciona)
   - [ ] Heatmap semanal con:
     - Calendario L-D
     - Celdas verdes = completado
     - Celdas naranjas = pendiente
     - Celdas grises = no programado
     - Leyenda expandible abajo

4. [ ] Tab "TENDENCIAS":
   - [ ] LineChart mensual con:
     - Color púrpura (#9C27B0)
     - Gradiente púrpura debajo
     - Labels W1-W2-W3-W4
     - Dots colorizados
   - [ ] BarChart de rachas con:
     - Barras por hábito
     - Gradientes verticales en barras
     - Background bars grises
     - Labels de nombres (truncados si largo)

**✅ RESULTADO ESPERADO**:
- Colores vibrantes y contrastados
- Diferencias claras entre valores
- Grid lines visibles
- Labels legibles
- Tooltips funcionales (si aplica)

**❌ BUGS POSIBLES**:
- [ ] Gráficas en blanco
- [ ] Colores poco contrastados
- [ ] Overflows en labels
- [ ] Datos incorrectos

---

### 2.2 Botón "Ver Estadísticas" individual

**Objetivo**: Validar fix reciente del botón

**Pasos**:
1. [ ] Volver a tab "Inicio"
2. [ ] Mantener pulsado (long press) en "Ejercicio matutino"
3. [ ] Ver bottom sheet con 3 opciones:
   - Editar
   - Ver estadísticas
   - Eliminar
4. [ ] **Pulsar "Ver estadísticas"**
5. [ ] Verificar navegación a StatsScreen
6. [ ] AppBar muestra:
   - Título: "Ejercicio matutino"
   - Subtítulo: "Estadísticas"
   - Botón atrás funcional
7. [ ] Todas las gráficas filtradas por ese hábito
8. [ ] Pulsar botón atrás → volver a home

**✅ RESULTADO ESPERADO**:
- Botón funciona (antes no hacía nada)
- Navegación correcta
- AppBar con nombre del hábito
- Datos filtrados solo de ese hábito

**❌ BUGS POSIBLES**:
- [ ] Botón no hace nada
- [ ] Crash al pulsar
- [ ] AppBar sin título correcto
- [ ] Muestra datos de todos los hábitos

---

### 2.3 Cambio de idioma y notificaciones

**Objetivo**: Validar fix crítico de notificaciones localizadas

**Pasos**:
1. [ ] Ir a Settings (bottom nav o menú)
2. [ ] Sección "Idioma"
3. [ ] Idioma actual: **Español** (verificar)
4. [ ] Scroll hasta "Notificaciones"
5. [ ] Verificar toggle "Habilitar notificaciones" = ON
6. [ ] Pulsar en "Sonido de recordatorio"
7. [ ] Ver nuevo ModalBottomSheet con:
   - Handle bar arriba
   - Icono volumen + título
   - 4 opciones con iconos y descripciones:
     - 🔔 Predeterminado - "Sonido del sistema"
     - 🔕 Ninguno - "Sin sonido"
     - 🎵 Campana - "Campana suave"
     - 🔔 Timbre - "Timbre clásico"
   - Opción seleccionada con:
     - Background coloreado
     - Barra azul izquierda
     - Check circle
8. [ ] Seleccionar una opción → cierra automáticamente
9. [ ] **AHORA CAMBIAR IDIOMA**:
   - Volver a sección "Idioma"
   - Cambiar a **English**
   - Verificar que toda la UI cambia a inglés
10. [ ] Verificar que "Notifications" dice "Notifications" (inglés)
11. [ ] Volver a sección "Idioma"
12. [ ] Cambiar de vuelta a **Español**

**✅ RESULTADO ESPERADO**:
- ModalBottomSheet moderno (no caja fea)
- Cambio de idioma instantáneo en UI
- Sin crashes al cambiar idioma

---

### 2.4 Programar notificación y validar idioma

**CRÍTICO**: Este test valida el fix principal de la sesión

**Pasos**:
1. [ ] Ir a "Editar" el hábito "Ejercicio matutino"
2. [ ] Cambiar hora de recordatorio a: **+2 minutos desde ahora**
   - Ejemplo: Si son 14:35 → poner 14:37
3. [ ] Activar toggle "Recordatorio"
4. [ ] Guardar hábito
5. [ ] **ESPERAR 2 minutos** (ir a otra app, pantalla home)
6. [ ] **Cuando llegue notificación**:
   - [ ] Idioma correcto (ESPAÑOL si está en ES)
   - [ ] Título: "Recordatorios de Hábitos" (no "Habit Reminders")
   - [ ] Mensaje: "Ejercicio matutino" + texto en español
   - [ ] Icono de la app visible
   - [ ] Sonido/vibración según configuración

7. [ ] **REPETIR en inglés**:
   - Cambiar idioma a English
   - Editar hábito "Meditar 10 min"
   - Poner recordatorio +2 minutos
   - Esperar notificación
   - [ ] Verificar que llega en INGLÉS
   - [ ] Título: "Habit Reminders"

**✅ RESULTADO ESPERADO**:
- Notificaciones en el idioma correcto de la app
- NO siempre en inglés (bug anterior)
- Sonido configurado funciona
- Pulsar notificación abre la app

**❌ BUGS POSIBLES**:
- [ ] Notificación siempre en inglés (BUG CRÍTICO)
- [ ] No llega notificación
- [ ] Crash al abrir desde notificación
- [ ] Sonido incorrecto

---

### 2.5 Themes con profundidad visual

**Objetivo**: Validar mejoras en themes premium

**Pasos**:
1. [ ] Ir a Settings → "Temas"
2. [ ] Cambiar a tema **"Executive Minimalist"** (premium)
3. [ ] Si está bloqueado → "Activar Premium (Testing)"
4. [ ] Una vez activado:
   - [ ] Observar cambio de colores
   - [ ] Verificar:
     - Backgrounds con diferentes tonos de gris
     - Cards con elevación sutil
     - AppBar con color distinto
     - Botones con nuevo color
   - [ ] Ir a Inicio → ver diferencia visual
   - [ ] Ir a Estadísticas → gráficas adaptan colores

5. [ ] Cambiar a tema **"Neon Cyber"**
   - [ ] Fondos negros profundos (#0a0a0a)
   - [ ] Acentos cyan (#00ffff) y rosa (#ff1493)
   - [ ] Efecto cyberpunk con capas de negro
   - [ ] Gráficas con colores neón

6. [ ] Cambiar a tema **"Aurora Inspiration"**
   - [ ] Fondos lavanda (#2e1a4a oscuro, #f8f4ff claro)
   - [ ] Acentos púrpura/rosa/dorado
   - [ ] Efecto aurora con gradientes

7. [ ] Cambiar a modo oscuro/claro en cada theme
   - [ ] Toggle "Modo Oscuro"
   - [ ] Verificar que fondos cambian dramáticamente

**✅ RESULTADO ESPERADO**:
- 6 niveles de profundidad visual por theme
- Fondos NO estáticos (cambian entre screens)
- Cada theme se siente ÚNICO
- Transiciones suaves al cambiar

**❌ BUGS POSIBLES**:
- [ ] Fondos todos iguales
- [ ] Sin contraste entre themes
- [ ] Crash al cambiar theme
- [ ] Modo oscuro no funciona

---

### 2.6 Responsive y orientación

**Objetivo**: Validar que no hay overflows

**Pasos**:
1. [ ] En cada pantalla principal:
   - [ ] HomeScreen con 3 hábitos
   - [ ] StatsScreen (3 tabs)
   - [ ] Settings completo
   - [ ] AddHabitScreen con formulario largo

2. [ ] Verificar:
   - [ ] Sin overflows (barras amarillas/rojas)
   - [ ] Textos largos con ellipsis (...)
   - [ ] Botones táctiles (mínimo 48x48)
   - [ ] Scroll funciona en pantallas largas

3. [ ] (Opcional) Rotar pantalla:
   - [ ] Debe permanecer vertical (bloqueado)
   - [ ] No crashes por rotación

**✅ RESULTADO ESPERADO**:
- Todo se ve bien en pantalla vertical
- Sin overflows visuales
- Textos no cortados abruptamente

---

## 📸 FASE 3: CAPTURA DE SCREENSHOTS (15 min)

**Objetivo**: Generar screenshots profesionales para Play Store

### Configuración previa:
- [ ] Resetear app (desinstalar + reinstalar) para simular usuario nuevo
- [ ] Idioma: **Español** primero
- [ ] Theme: **Blue (free)** o **Aurora (premium)** si quieres impresionar
- [ ] Datos de ejemplo: 3-5 hábitos con nombres atractivos

### Screenshots requeridos (ESPAÑOL):

**1. Onboarding - Página 1 (Gamificación)** 📸
- [ ] Capturar pantalla completa
- [ ] Verificar que se ve el fuego + "+5 pts"
- [ ] Nombre: `01_onboarding_gamification_es.png`

**2. Onboarding - Página 2 (Visualización)** 📸
- [ ] Capturar gráfico mockup
- [ ] Nombre: `02_onboarding_visualization_es.png`

**3. Onboarding - Página 3 (Personalización)** 📸
- [ ] Capturar stack de themes
- [ ] Nombre: `03_onboarding_customization_es.png`

**4. HomeScreen con hábitos** 📸
- [ ] 3-5 hábitos visibles
- [ ] GamificationCard arriba con puntos
- [ ] Algunos completados (checks verdes)
- [ ] Nombre: `04_home_habits_es.png`

**5. Estadísticas - Gráfica semanal** 📸
- [ ] Tab "Semana" seleccionado
- [ ] LineChart azul visible
- [ ] Heatmap con colores
- [ ] Nombre: `05_stats_weekly_es.png`

**6. Estadísticas - Gráfica de torta** 📸
- [ ] Tab "Hoy" seleccionado
- [ ] PieChart verde/naranja
- [ ] Stat cards arriba
- [ ] Nombre: `06_stats_today_es.png`

**7. Settings - Temas premium** 📸
- [ ] Sección de temas abierta
- [ ] Varios themes visibles con candados 🔒
- [ ] Nombre: `07_settings_themes_es.png`

**8. Paywall Screen (opcional)** 📸
- [ ] Pantalla de premium
- [ ] Features destacados
- [ ] Nombre: `08_paywall_es.png`

---

### Screenshots requeridos (ENGLISH):

Repetir los mismos 8 screenshots pero con idioma **English**:
- [ ] `01_onboarding_gamification_en.png`
- [ ] `02_onboarding_visualization_en.png`
- [ ] `03_onboarding_customization_en.png`
- [ ] `04_home_habits_en.png`
- [ ] `05_stats_weekly_en.png`
- [ ] `06_stats_today_en.png`
- [ ] `07_settings_themes_en.png`
- [ ] `08_paywall_en.png`

**Total screenshots**: 16 (8 ES + 8 EN)

---

## 🐛 FASE 4: REPORTE DE BUGS (SI HAY)

### Formato de reporte:

```markdown
## BUG #X: [Título descriptivo]

**Severidad**: 🔴 Crítico / 🟡 Alto / 🟢 Medio / ⚪ Bajo

**Ubicación**: [Pantalla / Feature]

**Pasos para reproducir**:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Comportamiento actual**:
[Qué pasa - con screenshot si es posible]

**Comportamiento esperado**:
[Qué debería pasar]

**Impacto**:
[Bloquea deployment? / Afecta UX? / Solo visual?]

**Prioridad de fix**: ⬆️ Urgente / ➡️ Antes de deployment / ⬇️ Post-launch
```

### Ejemplo:

```markdown
## BUG #1: Notificaciones siguen en inglés

**Severidad**: 🔴 Crítico

**Ubicación**: Notificaciones locales

**Pasos para reproducir**:
1. Cambiar idioma a Español
2. Programar recordatorio en 1 min
3. Esperar notificación

**Comportamiento actual**:
Notificación llega con título "Habit Reminders" (inglés)

**Comportamiento esperado**:
Debería decir "Recordatorios de Hábitos" (español)

**Impacto**:
BLOQUEA DEPLOYMENT - Feature crítica no funciona

**Prioridad de fix**: ⬆️ URGENTE
```

---

## ✅ CHECKLIST FINAL

Al completar el test, verificar:

- [ ] **Fase 1** completada (15 min)
  - [ ] Onboarding funciona perfecto
  - [ ] Creación de hábitos OK
  - [ ] Gamificación funciona

- [ ] **Fase 2** completada (20 min)
  - [ ] Estadísticas con gráficas mejoradas
  - [ ] Botón "Ver estadísticas" funciona
  - [ ] Notificaciones localizadas OK
  - [ ] Themes con profundidad visual
  - [ ] Responsive sin overflows

- [ ] **Fase 3** completada (15 min)
  - [ ] 16 screenshots capturados (8 ES + 8 EN)
  - [ ] Screenshots en carpeta `/screenshots`

- [ ] **Bugs reportados**: [Número] bugs encontrados
  - [ ] 0 bugs críticos 🔴
  - [ ] X bugs altos 🟡
  - [ ] X bugs medios 🟢

---

## 🎯 CRITERIOS DE ÉXITO

### ✅ App lista para deployment si:
- ✅ 0 crashes durante el test
- ✅ 0 bugs críticos (🔴)
- ✅ Notificaciones localizadas funcionan
- ✅ Onboarding nuevo es atractivo
- ✅ Gráficas se ven profesionales
- ✅ Themes se diferencian claramente
- ✅ 16 screenshots de calidad capturados

### ⚠️ Requiere fix antes de deployment si:
- ⚠️ 1+ bugs críticos encontrados
- ⚠️ Notificaciones no funcionan
- ⚠️ Crashes frecuentes
- ⚠️ Onboarding roto

### 🚫 No deployable si:
- 🚫 App no inicia
- 🚫 Crashes constantes
- 🚫 múltiples features core rotas

---

## 📊 TIEMPO ESTIMADO POR FASE

| Fase | Tiempo | Acumulado |
|------|--------|-----------|
| Fase 1: Test Inicial | 15 min | 15 min |
| Fase 2: Test Crítico | 20 min | 35 min |
| Fase 3: Screenshots | 15 min | 50 min |
| **TOTAL** | **50 min** | |

---

**Preparado por**: Claude (Sesión 57)
**Build**: v1.0.1+2 debug
**Fecha test**: 2025-10-08

