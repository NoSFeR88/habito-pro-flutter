#!/usr/bin/env python3
"""
Script para crear NUEVO Feature Graphic de Ritmo
Concepto: "Tu ritmo perfecto" - Flexibilidad y Diseño Moderno
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
except ImportError:
    print("Instalando Pillow...")
    import subprocess
    subprocess.run(["pip", "install", "Pillow"], check=True)
    from PIL import Image, ImageDraw, ImageFont
    import os

def create_new_feature_graphic():
    print("NUEVO FEATURE GRAPHIC - RITMO 2025")
    print("Concepto: Tu ritmo perfecto - Flexibilidad")
    print("=" * 60)

    # Dimensiones exactas Play Store
    WIDTH = 1024
    HEIGHT = 500

    # Crear imagen base con gradiente más sutil
    img = Image.new('RGB', (WIDTH, HEIGHT), color='#2D2B42')
    draw = ImageDraw.Draw(img)

    # Gradiente más moderno y sutil
    print("Creando gradiente moderno...")
    for x in range(WIDTH):
        # Gradiente más suave: #2D2B42 -> #3A3A5C -> #8B5CF6
        if x < WIDTH // 3:
            # Primera parte: #2D2B42 -> #3A3A5C
            ratio = x / (WIDTH // 3)
            r = int(45 + (58 - 45) * ratio)
            g = int(43 + (58 - 43) * ratio)
            b = int(66 + (92 - 66) * ratio)
        elif x < 2 * WIDTH // 3:
            # Segunda parte: #3A3A5C -> más sutil
            ratio = (x - WIDTH // 3) / (WIDTH // 3)
            r = int(58 + (70 - 58) * ratio)
            g = int(58 + (70 - 58) * ratio)
            b = int(92 + (120 - 92) * ratio)
        else:
            # Tercera parte: hacia púrpura suave
            ratio = (x - 2 * WIDTH // 3) / (WIDTH // 3)
            r = int(70 + (139 - 70) * ratio * 0.6)  # Más sutil
            g = int(70 + (92 - 70) * ratio * 0.6)
            b = int(120 + (246 - 120) * ratio * 0.6)

        color = (r, g, b)
        draw.line([(x, 0), (x, HEIGHT)], fill=color)

    # Cargar fuentes
    try:
        font_logo = ImageFont.truetype("arial.ttf", 48)  # Más grande
        font_tagline = ImageFont.truetype("arial.ttf", 18)
        font_badge = ImageFont.truetype("arial.ttf", 14)
        font_badge_small = ImageFont.truetype("arial.ttf", 11)
        font_calendar = ImageFont.truetype("arial.ttf", 10)
    except:
        print("Usando fuentes por defecto...")
        font_logo = ImageFont.load_default()
        font_tagline = ImageFont.load_default()
        font_badge = ImageFont.load_default()
        font_badge_small = ImageFont.load_default()
        font_calendar = ImageFont.load_default()

    print("Seccion izquierda: Branding moderno...")

    # SECCIÓN IZQUIERDA: Logo y Tagline más prominentes
    logo_x = 40
    logo_y = HEIGHT // 2 - 50

    # Logo "Ritmo" más grande y llamativo
    draw.text((logo_x, logo_y), "Ritmo", font=font_logo, fill='#FFFFFF')

    # Tagline principal redefinido
    tagline_x = 40
    tagline_y = logo_y + 55
    draw.text((tagline_x, tagline_y), "Tu ritmo perfecto", font=font_tagline, fill='#E2E8F0')

    # Subtítulo diferenciador
    subtitle_y = tagline_y + 25
    draw.text((tagline_x, subtitle_y), "Habitos flexibles como tu vida", font=font_calendar, fill='#A855F7')

    print("Seccion central: Calendario flexible...")

    # SECCIÓN CENTRAL: Calendario Flexible (DIFERENCIADOR #1)
    cal_x = 340
    cal_y = HEIGHT // 2 - 80
    cal_width = 300
    cal_height = 160

    # Fondo del calendario
    cal_bg = [cal_x, cal_y, cal_x + cal_width, cal_y + cal_height]
    draw.rounded_rectangle(cal_bg, radius=12, fill='#3A3A5C', outline='#8B5CF6', width=2)

    # Título del calendario
    draw.text((cal_x + 10, cal_y + 10), "Semana Flexible:", font=font_badge, fill='#FFFFFF')

    # Días de la semana con flexibilidad
    days = ['L', 'M', 'X', 'J', 'V', 'S', 'D']
    day_width = 35
    day_height = 25
    start_x = cal_x + 15
    start_y = cal_y + 35

    # Estado de cada día (flexible, no rígido)
    day_states = [
        ('L', True, 'Gym 7AM'),      # Lunes: activo
        ('M', False, 'Descanso'),    # Martes: descanso
        ('X', True, 'Gym 7AM'),      # Miércoles: activo
        ('J', True, 'Lectura 9PM'),  # Jueves: diferente
        ('V', True, 'Gym 7AM'),      # Viernes: activo
        ('S', False, 'Libre'),       # Sábado: libre
        ('D', True, 'Yoga 10AM'),    # Domingo: diferente
    ]

    for i, (day, active, activity) in enumerate(day_states):
        x = start_x + (i % 7) * (day_width + 5)
        y = start_y + (i // 7) * (day_height + 15)

        # Color según estado
        if active:
            color = '#10B981'  # Verde para días activos
            text_color = '#FFFFFF'
        else:
            color = '#6B7280'  # Gris para días libres
            text_color = '#D1D5DB'

        # Círculo del día
        draw.ellipse([x, y, x + day_width, y + day_height], fill=color)

        # Letra del día
        text_bbox = draw.textbbox((0, 0), day, font=font_badge)
        text_width = text_bbox[2] - text_bbox[0]
        text_height = text_bbox[3] - text_bbox[1]
        text_x = x + (day_width - text_width) // 2
        text_y = y + (day_height - text_height) // 2
        draw.text((text_x, text_y), day, font=font_badge, fill=text_color)

        # Actividad debajo (solo si está activo)
        if active and i < 4:  # Solo primeros 4 para no saturar
            activity_y = y + day_height + 5
            draw.text((x - 5, activity_y), activity[:8], font=font_calendar, fill='#E2E8F0')

    # Flecha de concepto: Rigidez → Flexibilidad
    arrow_x = cal_x + cal_width + 20
    arrow_y = HEIGHT // 2 - 15
    draw.text((arrow_x, arrow_y), "→", font=font_logo, fill='#8B5CF6')

    print("Seccion derecha: Badge y estadisticas...")

    # SECCIÓN DERECHA: Badge principal redefinido
    badge_x = WIDTH - 220
    badge_y = 50
    badge_width = 180
    badge_height = 60

    # Badge más grande y llamativo
    badge_rect = [badge_x, badge_y, badge_x + badge_width, badge_y + badge_height]
    draw.rounded_rectangle(badge_rect, radius=15, fill='#F59E0B')

    # Texto del badge principal
    badge_text_x = badge_x + badge_width // 2
    badge_text_y = badge_y + 12

    # "HÁBITOS FLEXIBLES"
    main_text = "HABITOS FLEXIBLES"
    text_bbox = draw.textbbox((0, 0), main_text, font=font_badge)
    text_width = text_bbox[2] - text_bbox[0]
    draw.text((badge_text_x - text_width // 2, badge_text_y), main_text, font=font_badge, fill='#FFFFFF')

    # "No más rigidez"
    sub_text = "No mas rigidez"
    sub_bbox = draw.textbbox((0, 0), sub_text, font=font_badge_small)
    sub_width = sub_bbox[2] - sub_bbox[0]
    draw.text((badge_text_x - sub_width // 2, badge_text_y + 25), sub_text, font=font_badge_small, fill='#FFFFFF')

    # Estadísticas modernas (parte inferior derecha)
    stats_x = badge_x
    stats_y = badge_y + 80

    # Mini gráficos de progreso
    progress_items = [
        ("87% Exito", 0.87, '#10B981'),
        ("22 Dias racha", 0.9, '#8B5CF6'),
        ("3x Semana", 0.6, '#F59E0B'),
    ]

    for i, (label, progress, color) in enumerate(progress_items):
        y = stats_y + i * 30

        # Label
        draw.text((stats_x, y), label, font=font_calendar, fill='#E2E8F0')

        # Mini barra de progreso
        bar_x = stats_x + 80
        bar_width = 60
        bar_height = 6

        # Fondo
        draw.rectangle([bar_x, y + 5, bar_x + bar_width, y + 5 + bar_height], fill='#3A3A5C')

        # Progreso
        progress_width = int(bar_width * progress)
        draw.rectangle([bar_x, y + 5, bar_x + progress_width, y + 5 + bar_height], fill=color)

    # Elementos decorativos: ondas sutiles
    print("Elementos decorativos finales...")

    # Ondas de fondo muy sutiles
    for i in range(3):
        wave_x = 200 + i * 100
        wave_y = HEIGHT // 2 + 50
        wave_radius = 30 + i * 15

        # Círculo de onda sutil
        draw.ellipse([
            wave_x - wave_radius, wave_y - wave_radius,
            wave_x + wave_radius, wave_y + wave_radius
        ], outline='#8B5CF6', width=1)

    # Guardar imagen
    output_path = 'ritmo_feature_graphic_v2_flexibility.png'
    img.save(output_path, 'PNG', quality=95)

    # Verificar archivo
    if os.path.exists(output_path):
        file_size = os.path.getsize(output_path)
        file_size_kb = file_size // 1024

        print("=" * 60)
        print("NUEVO FEATURE GRAPHIC CREADO!")
        print(f"Archivo: {output_path}")
        print(f"Concepto: Flexibilidad y Ritmo Perfecto")
        print(f"Dimensiones: {WIDTH}x{HEIGHT}px")
        print(f"Tamano: {file_size_kb} KB")

        print("\nDIFERENCIADORES INCLUIDOS:")
        print("1. Calendario flexible (L-X-V gym, no diario)")
        print("2. Diferentes horarios por habito")
        print("3. Dias libres mostrados como positivos")
        print("4. Estadisticas motivadoras")
        print("5. Diseno moderno 2025")

        if file_size_kb > 1024:
            print("\nOPTIMIZACION: Archivo >1MB, considerar comprimir")

        print("\nPROXIMOS PASOS:")
        print("1. Feature graphic V2 listo para Play Store")
        print("2. Capturar screenshots con nueva narrativa")
        print("3. Actualizar textos de Play Store")
        print("4. A/B testing vs version anterior")

        return True
    else:
        print("ERROR: No se pudo crear el archivo")
        return False

if __name__ == "__main__":
    try:
        create_new_feature_graphic()
    except Exception as e:
        print(f"Error: {e}")
        print("\nSOLUCION ALTERNATIVA:")
        print("1. Crear manualmente en Figma/Canva")
        print("2. Usar concepto de calendario flexible")
        print("3. Badge 'HABITOS FLEXIBLES'")
        print("4. Enfoque en diferenciacion vs rigidez")