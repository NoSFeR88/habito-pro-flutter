#!/usr/bin/env python3
"""
Script para generar iconos PNG de Ritmo en todas las densidades Android
Requiere: pip install cairosvg Pillow
"""

import os
import cairosvg
from PIL import Image
import io

# Configuración de densidades Android
DENSITIES = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192
}

# Archivo SVG de entrada
SVG_FILE = 'ritmo_icon.svg'
OUTPUT_DIR = '../android/app/src/main/res'

def generate_png_from_svg(svg_path, size):
    """Convierte SVG a PNG con el tamaño especificado"""
    try:
        # Leer el archivo SVG
        with open(svg_path, 'r') as f:
            svg_content = f.read()

        # Convertir SVG a PNG usando cairosvg
        png_bytes = cairosvg.svg2png(
            bytestring=svg_content.encode('utf-8'),
            output_width=size,
            output_height=size
        )

        # Crear imagen PIL para verificación
        image = Image.open(io.BytesIO(png_bytes))
        return png_bytes

    except ImportError:
        print("⚠️  cairosvg no está instalado. Instalando...")
        print("📦 Ejecuta: pip install cairosvg Pillow")
        return None
    except Exception as e:
        print(f"❌ Error generando PNG: {e}")
        return None

def create_android_icons():
    """Genera todos los iconos para densidades Android"""

    if not os.path.exists(SVG_FILE):
        print(f"❌ Archivo SVG no encontrado: {SVG_FILE}")
        return False

    print("🎨 Generando iconos de Ritmo para Android...")
    print("=" * 50)

    success_count = 0

    for density, size in DENSITIES.items():
        print(f"📱 Generando {density}: {size}x{size}px")

        # Generar PNG
        png_data = generate_png_from_svg(SVG_FILE, size)

        if png_data:
            # Crear directorio si no existe
            mipmap_dir = f"{OUTPUT_DIR}/mipmap-{density}"
            os.makedirs(mipmap_dir, exist_ok=True)

            # Guardar archivo
            output_path = f"{mipmap_dir}/ic_launcher.png"
            with open(output_path, 'wb') as f:
                f.write(png_data)

            print(f"✅ Creado: {output_path}")
            success_count += 1
        else:
            print(f"❌ Error creando {density}")

    # Generar también versión para Play Store (512px)
    print(f"🏪 Generando versión Play Store: 512x512px")
    png_data_512 = generate_png_from_svg(SVG_FILE, 512)

    if png_data_512:
        output_512 = f"ritmo_icon_512px.png"
        with open(output_512, 'wb') as f:
            f.write(png_data_512)
        print(f"✅ Creado: {output_512}")
        success_count += 1

    print("=" * 50)
    print(f"🎊 Completado: {success_count}/{len(DENSITIES)+1} iconos generados")

    if success_count == len(DENSITIES) + 1:
        print("🚀 ¡Todos los iconos listos para implementación!")
        return True
    else:
        print("⚠️  Algunos iconos no se pudieron generar")
        return False

def create_alternative_method():
    """Método alternativo usando herramientas del sistema"""
    print("\n🔧 MÉTODO ALTERNATIVO:")
    print("Si no tienes cairosvg, puedes:")
    print("1. Abrir ritmo_icon.svg en Inkscape/Illustrator")
    print("2. Exportar como PNG en estos tamaños:")

    for density, size in DENSITIES.items():
        print(f"   - {density}: {size}x{size}px → android/app/src/main/res/mipmap-{density}/ic_launcher.png")

    print(f"   - Play Store: 512x512px → ritmo_icon_512px.png")
    print("\n3. También puedes usar herramientas online como:")
    print("   - https://svg2png.com/")
    print("   - https://cloudconvert.com/svg-to-png")

if __name__ == "__main__":
    print("🎵 GENERADOR DE ICONOS RITMO")
    print("=" * 50)

    try:
        success = create_android_icons()

        if not success:
            create_alternative_method()

    except Exception as e:
        print(f"❌ Error general: {e}")
        create_alternative_method()

    print("\n📋 PRÓXIMOS PASOS:")
    print("1. Verificar que los archivos PNG se crearon correctamente")
    print("2. Ejecutar: flutter clean && flutter pub get")
    print("3. Compilar app para verificar icono: flutter build apk --debug")