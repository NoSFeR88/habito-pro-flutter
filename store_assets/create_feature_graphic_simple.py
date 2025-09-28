#!/usr/bin/env python3
"""
Script para crear Feature Graphic de Ritmo usando PIL/Pillow
Crea PNG 1024x500px con especificaciones exactas
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

def create_feature_graphic():
    print("CREADOR DE FEATURE GRAPHIC - RITMO")
    print("=" * 50)

    # Dimensiones exactas Play Store
    WIDTH = 1024
    HEIGHT = 500

    # Crear imagen base
    img = Image.new('RGB', (WIDTH, HEIGHT), color='#2D2B42')
    draw = ImageDraw.Draw(img)

    # Crear gradiente de fondo
    print("Creando gradiente de fondo...")
    for x in range(WIDTH):
        # Gradiente horizontal: #2D2B42 -> #3A3A5C -> #8B5CF6
        if x < WIDTH // 2:
            # Primera mitad: #2D2B42 -> #3A3A5C
            ratio = x / (WIDTH // 2)
            r = int(45 + (58 - 45) * ratio)
            g = int(43 + (58 - 43) * ratio)
            b = int(66 + (92 - 66) * ratio)
        else:
            # Segunda mitad: #3A3A5C -> #8B5CF6
            ratio = (x - WIDTH // 2) / (WIDTH // 2)
            r = int(58 + (139 - 58) * ratio)
            g = int(58 + (92 - 58) * ratio)
            b = int(92 + (246 - 92) * ratio)

        color = (r, g, b)
        draw.line([(x, 0), (x, HEIGHT)], fill=color)

    # Intentar cargar fuente, usar default si no disponible
    try:
        # Intentar cargar fuente Bold para el logo
        font_logo = ImageFont.truetype("arial.ttf", 52)
        font_tagline = ImageFont.truetype("arial.ttf", 20)
        font_badge = ImageFont.truetype("arial.ttf", 16)
        font_badge_small = ImageFont.truetype("arial.ttf", 12)
    except:
        print("Fuente Arial no encontrada, usando fuente por defecto")
        font_logo = ImageFont.load_default()
        font_tagline = ImageFont.load_default()
        font_badge = ImageFont.load_default()
        font_badge_small = ImageFont.load_default()

    print("Anadiendo texto principal...")

    # Logo "Ritmo" (lado izquierdo)
    logo_x = 50
    logo_y = HEIGHT // 2 - 40
    draw.text((logo_x, logo_y), "Ritmo", font=font_logo, fill='#FFFFFF')

    # Tagline
    tagline_x = 50
    tagline_y = logo_y + 60
    draw.text((tagline_x, tagline_y), "Tu ritmo diario perfecto", font=font_tagline, fill='#E2E8F0')

    print("Creando badge de idiomas...")

    # Badge "26 IDIOMAS" (lado derecho)
    badge_x = WIDTH - 200
    badge_y = 60
    badge_width = 140
    badge_height = 50

    # Fondo del badge (dorado)
    badge_rect = [badge_x, badge_y, badge_x + badge_width, badge_y + badge_height]
    draw.rounded_rectangle(badge_rect, radius=12, fill='#F59E0B')

    # Texto del badge
    badge_text_x = badge_x + badge_width // 2
    badge_text_y = badge_y + 8

    # Centrar texto "26 IDIOMAS"
    text_bbox = draw.textbbox((0, 0), "26 IDIOMAS", font=font_badge)
    text_width = text_bbox[2] - text_bbox[0]
    draw.text((badge_text_x - text_width // 2, badge_text_y), "26 IDIOMAS", font=font_badge, fill='#FFFFFF')

    # Texto "Lider del mercado"
    sub_text = "Lider del mercado"
    sub_bbox = draw.textbbox((0, 0), sub_text, font=font_badge_small)
    sub_width = sub_bbox[2] - sub_bbox[0]
    draw.text((badge_text_x - sub_width // 2, badge_text_y + 22), sub_text, font=font_badge_small, fill='#FFFFFF')

    print("Anadiendo elementos visuales...")

    # Ondas de audio (centro-izquierda)
    wave_x = 300
    wave_y = HEIGHT // 2
    wave_heights = [30, 50, 40, 60, 35]
    wave_width = 4
    wave_gap = 6

    for i, height in enumerate(wave_heights):
        x = wave_x + i * (wave_width + wave_gap)
        y = wave_y - height // 2
        # Gradiente purpura para las ondas
        draw.rectangle([x, y, x + wave_width, y + height], fill='#8B5CF6')

    # Flecha de transicion
    arrow_x = wave_x + 120
    arrow_y = wave_y - 10
    draw.text((arrow_x, arrow_y), "->", font=font_tagline, fill='#FFFFFF')

    # Barras de progreso (centro-derecha)
    progress_x = arrow_x + 60
    progress_y = wave_y - 40
    progress_width = 80
    progress_height = 8
    progress_gap = 15

    # Progreso de habitos
    progress_values = [0.85, 0.72, 0.90, 0.68]

    for i, progress in enumerate(progress_values):
        y = progress_y + i * progress_gap

        # Indicador de habito
        draw.ellipse([progress_x - 25, y - 5, progress_x - 15, y + 5], fill='#FFFFFF')

        # Fondo de la barra
        bar_bg = [progress_x, y, progress_x + progress_width, y + progress_height]
        draw.rectangle(bar_bg, fill='#3A3A5C')

        # Progreso
        progress_pixels = int(progress_width * progress)
        bar_progress = [progress_x, y, progress_x + progress_pixels, y + progress_height]
        draw.rectangle(bar_progress, fill='#10B981')

    # Iconos de habitos adicionales (lado derecho)
    habits_x = WIDTH - 120
    habits_y = HEIGHT // 2 - 50

    for i in range(5):
        y = habits_y + i * 20
        # Icono de habito (circulo pequeno)
        draw.ellipse([habits_x, y, habits_x + 16, y + 16], fill='#8B5CF6')

        # Mini barra de progreso
        mini_bar_x = habits_x + 24
        mini_bar_y = y + 6
        mini_progress = [0.85, 0.72, 0.90, 0.68, 0.94][i]

        # Fondo mini barra
        draw.rectangle([mini_bar_x, mini_bar_y, mini_bar_x + 40, mini_bar_y + 4], fill='#3A3A5C')
        # Progreso mini barra
        mini_width = int(40 * mini_progress)
        draw.rectangle([mini_bar_x, mini_bar_y, mini_bar_x + mini_width, mini_bar_y + 4], fill='#10B981')

    # Guardar imagen
    output_path = 'ritmo_feature_graphic_1024x500.png'
    img.save(output_path, 'PNG', quality=95)

    # Verificar archivo creado
    if os.path.exists(output_path):
        file_size = os.path.getsize(output_path)
        file_size_kb = file_size // 1024

        print("=" * 50)
        print("Feature graphic creado exitosamente!")
        print(f"Archivo: {output_path}")
        print(f"Dimensiones: {WIDTH}x{HEIGHT}px")
        print(f"Tamano: {file_size_kb} KB")

        if file_size_kb > 1024:
            print("Archivo > 1MB. Considerar optimizar para Play Store")

        print("\nPROXIMOS PASOS:")
        print("1. Feature graphic listo para Play Store")
        print("2. Verificar calidad visual")
        print("3. Continuar con captura de screenshots")
        print("4. Configurar Google Play Console")

        return True
    else:
        print("Error: No se pudo crear el archivo")
        return False

if __name__ == "__main__":
    try:
        create_feature_graphic()
    except Exception as e:
        print(f"Error: {e}")
        print("\nSOLUCION ALTERNATIVA:")
        print("1. Usar el template HTML abierto en navegador")
        print("2. Tomar screenshot manual del elemento .feature-graphic")
        print("3. Redimensionar a 1024x500px exactos")
        print("4. Guardar como PNG con calidad alta")