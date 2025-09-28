# App Icon Guide - Ritmo

## Especificaciones Técnicas Google Play

### Dimensiones Requeridas
- **Icono principal**: 512 x 512 píxeles
- **Formato**: PNG de 32 bits
- **Tamaño máximo**: 1 MB
- **Fondo**: No transparente (debe ser sólido)

### Dimensiones Adicionales Android
- **48x48**: mdpi
- **72x72**: hdpi
- **96x96**: xhdpi
- **144x144**: xxhdpi
- **192x192**: xxxhdpi

## Concepto del Icono

### Simbolismo Principal
**"Ondas de Ritmo"** - Representación visual que combina:
1. **Ondas de audio/ritmo** (concepto principal)
2. **Círculo de progreso** (completion/hábitos)
3. **Diseño moderno y minimalista**

### Diseño Principal

#### Forma Base
- **Container**: Círculo con bordes redondeados (estilo moderno)
- **Fondo**: Gradiente del color primario de Ritmo
- **Gradiente**: De #8B5CF6 (púrpura) a #6366F1 (púrpura más oscuro)

#### Elemento Central
**Símbolo de Ondas Rítmicas**:
- **Forma**: 3-4 ondas concéntricas estilizadas
- **Color**: Blanco (#FFFFFF) con opacidad sutil
- **Estilo**: Líneas fluidas que sugieren movimiento
- **Posición**: Centrado perfectamente

#### Variante Alternativa
**"R" Estilizada**:
- **Letra**: "R" de Ritmo con diseño personalizado
- **Integración**: La "R" incorpora ondas en su diseño
- **Tipografía**: Moderna, geométrica, única

### Paleta de Colores

#### Opción A - Púrpura Primario
```css
Fondo gradiente:
  - Superior: #8B5CF6 (púrpura vibrante)
  - Inferior: #6366F1 (púrpura profundo)
Símbolo: #FFFFFF (blanco puro)
Sombras: #1F2937 (gris oscuro) con 20% opacidad
```

#### Opción B - Gradiente Dinámico
```css
Fondo gradiente:
  - Superior izquierda: #8B5CF6 (púrpura)
  - Centro: #A855F7 (púrpura medio)
  - Inferior derecha: #EC4899 (rosa vibrante)
Símbolo: #FFFFFF
```

#### Opción C - Minimalista
```css
Fondo: #8B5CF6 (sólido)
Símbolo: #FFFFFF
Acento: #F59E0B (dorado) para un pequeño detalle
```

## Estilos de Diseño

### Estilo A - Ondas Concéntricas
- **Elemento central**: Círculo pequeño sólido
- **Ondas**: 3 círculos concéntricos con gaps elegantes
- **Efecto**: Radiando desde el centro (como ripples de agua)
- **Sensación**: Calma, expansión, crecimiento

### Estilo B - Ondas de Audio
- **Elemento central**: Barras verticales de diferentes alturas
- **Patrón**: Simula visualización de ecualizador
- **Movimiento**: Ritmo visual dinámico
- **Sensación**: Energía, música, temporalidad

### Estilo C - "R" con Ondas
- **Base**: Letra "R" tipográfica moderna
- **Integración**: Ondas salen desde la "R"
- **Equilibrio**: 70% letra, 30% ondas
- **Sensación**: Marca, identidad, profesionalismo

## Consideraciones de Diseño

### Legibilidad
- **Tamaño mínimo**: Debe verse claramente a 48x48px
- **Contraste**: Alto contraste entre fondo y símbolo
- **Simplicidad**: Elementos reconocibles instantáneamente
- **Sin texto**: Evitar texto pequeño que no se lea

### Consistencia de Marca
- **Coherencia**: Alineado con la paleta de colores de la app
- **Personalidad**: Transmite profesionalismo y modernidad
- **Diferenciación**: Único en el mercado de habit trackers

### Competencia Visual
Diferenciarse de iconos existentes:
- **Habitica**: Verde con pixel art
- **Streaks**: Naranja con números
- **Forest**: Verde con árboles
- **HabitNow**: Azul con checkmarks
- **Ritmo**: Púrpura con ondas (ÚNICO)

## Variantes del Icono

### Versión Principal (Círculo)
- Para la mayoría de contextos
- Fondo circular con bordes suavemente redondeados
- Mejor para Google Play Store

### Versión Cuadrada Redondeada
- Para contextos que requieren forma cuadrada
- Mismos elementos, diferente container
- Corners radius: 22% del tamaño total

### Versión Monocromática
- Para contextos de una sola tinta
- Versión en blanco sobre fondo oscuro
- Versión en negro sobre fondo claro

## Archivos a Generar

### Set Completo Android
```
ic_launcher_main_512.png     (512x512 - Play Store)
ic_launcher_192.png          (xxxhdpi)
ic_launcher_144.png          (xxhdpi)
ic_launcher_96.png           (xhdpi)
ic_launcher_72.png           (hdpi)
ic_launcher_48.png           (mdpi)
```

### Versiones Adicionales
```
icon_round_512.png           (versión circular)
icon_square_512.png          (versión cuadrada)
icon_mono_white_512.png      (monocromático blanco)
icon_mono_black_512.png      (monocromático negro)
```

## Implementación Técnica

### En Android Studio
1. Usar **Image Asset Studio**
2. Generar automáticamente todas las densidades
3. Configurar adaptive icons (foreground + background)
4. Testear en diferentes launchers

### Archivos a Actualizar
```
android/app/src/main/res/mipmap-*/ic_launcher.png
android/app/src/main/res/mipmap-*/ic_launcher_round.png
android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
```

## Validación del Icono

### Checklist de Calidad
- [ ] Visible y reconocible a 48x48px
- [ ] Alto contraste y buena legibilidad
- [ ] Consistente con branding de Ritmo
- [ ] Único y diferenciado de competencia
- [ ] Sin elementos que se distorsionen al redimensionar
- [ ] Archivos en todas las densidades Android
- [ ] Cumple guidelines de Google Material Design

---

**Objetivo**: El icono debe ser instantáneamente reconocible como "Ritmo" y transmitir los conceptos de ritmo, progreso y profesionalismo.