#!/usr/bin/env node
/**
 * Script para convertir icono SVG de Ritmo a PNG en todas las densidades Android
 * Requiere: npm install sharp
 */

const fs = require('fs');
const path = require('path');

// Configuración de densidades Android
const DENSITIES = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192
};

const SVG_FILE = 'ritmo_icon.svg';
const OUTPUT_DIR = '../android/app/src/main/res';

async function convertSvgToPng() {
    try {
        // Intentar importar sharp
        const sharp = await import('sharp');
        return sharp.default;
    } catch (error) {
        console.log('⚠️  Sharp no está instalado. Instalando...');
        console.log('📦 Ejecutando: npm install sharp');

        const { execSync } = require('child_process');
        try {
            execSync('npm install sharp', { stdio: 'inherit' });
            const sharp = await import('sharp');
            return sharp.default;
        } catch (installError) {
            console.log('❌ Error instalando sharp:', installError.message);
            return null;
        }
    }
}

async function generateIcons() {
    console.log('🎵 GENERADOR DE ICONOS RITMO (Node.js)');
    console.log('='.repeat(50));

    const sharp = await convertSvgToPng();
    if (!sharp) {
        console.log('❌ No se pudo instalar sharp. Usando método alternativo...');
        showAlternativeMethod();
        return false;
    }

    if (!fs.existsSync(SVG_FILE)) {
        console.log(`❌ Archivo SVG no encontrado: ${SVG_FILE}`);
        return false;
    }

    console.log('🎨 Generando iconos de Ritmo para Android...');

    let successCount = 0;
    const totalIcons = Object.keys(DENSITIES).length + 1; // +1 para Play Store

    // Generar iconos para cada densidad Android
    for (const [density, size] of Object.entries(DENSITIES)) {
        try {
            console.log(`📱 Generando ${density}: ${size}x${size}px`);

            // Crear directorio mipmap si no existe
            const mipmapDir = path.join(OUTPUT_DIR, `mipmap-${density}`);
            if (!fs.existsSync(mipmapDir)) {
                fs.mkdirSync(mipmapDir, { recursive: true });
            }

            // Convertir SVG a PNG
            const outputPath = path.join(mipmapDir, 'ic_launcher.png');
            await sharp(SVG_FILE)
                .resize(size, size)
                .png()
                .toFile(outputPath);

            console.log(`✅ Creado: ${outputPath}`);
            successCount++;

        } catch (error) {
            console.log(`❌ Error creando ${density}: ${error.message}`);
        }
    }

    // Generar versión para Play Store (512px)
    try {
        console.log('🏪 Generando versión Play Store: 512x512px');

        const playStoreOutput = 'ritmo_icon_512px.png';
        await sharp(SVG_FILE)
            .resize(512, 512)
            .png()
            .toFile(playStoreOutput);

        console.log(`✅ Creado: ${playStoreOutput}`);
        successCount++;

    } catch (error) {
        console.log(`❌ Error creando versión Play Store: ${error.message}`);
    }

    console.log('='.repeat(50));
    console.log(`🎊 Completado: ${successCount}/${totalIcons} iconos generados`);

    if (successCount === totalIcons) {
        console.log('🚀 ¡Todos los iconos listos para implementación!');
        showNextSteps();
        return true;
    } else {
        console.log('⚠️  Algunos iconos no se pudieron generar');
        showAlternativeMethod();
        return false;
    }
}

function showNextSteps() {
    console.log('\n📋 PRÓXIMOS PASOS:');
    console.log('1. Verificar que los archivos PNG se crearon correctamente');
    console.log('2. Ejecutar: flutter clean && flutter pub get');
    console.log('3. Compilar app: flutter build apk --debug');
    console.log('4. Verificar icono en el dispositivo');
}

function showAlternativeMethod() {
    console.log('\n🔧 MÉTODO ALTERNATIVO:');
    console.log('Si no se puede usar Node.js, puedes:');
    console.log('1. Abrir ritmo_icon.svg en cualquier editor (Inkscape, Illustrator, GIMP)');
    console.log('2. Exportar como PNG en estos tamaños:');

    for (const [density, size] of Object.entries(DENSITIES)) {
        console.log(`   - ${density}: ${size}x${size}px → android/app/src/main/res/mipmap-${density}/ic_launcher.png`);
    }

    console.log('   - Play Store: 512x512px → ritmo_icon_512px.png');
    console.log('\n3. Herramientas online:');
    console.log('   - https://svg2png.com/');
    console.log('   - https://cloudconvert.com/svg-to-png');
    console.log('   - https://convertio.co/svg-png/');
}

// Ejecutar script
generateIcons().catch(error => {
    console.log('❌ Error general:', error.message);
    showAlternativeMethod();
});