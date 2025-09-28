#!/usr/bin/env node
/**
 * SCRIPT UNIVERSAL PARA AÑADIR OVERLAYS A SCREENSHOTS
 * Reutilizable para todas las futuras aplicaciones
 *
 * Funcionalidades:
 * - Añade gradiente púrpura automáticamente
 * - Texto configurable por screenshot
 * - Calidad Play Store optimizada
 * - Template reutilizable
 */

const fs = require('fs');
const path = require('path');

// Configuración de overlays para Ritmo
const OVERLAY_CONFIG = {
    // Dimensiones estándar móvil
    width: 390,
    height: 844,

    // Configuración del overlay
    overlayHeight: 120,
    overlayPosition: 'bottom', // 'top', 'bottom', 'center'

    // Gradiente (personalizable por app)
    gradientStart: 'rgba(139, 92, 246, 0)',      // Transparente
    gradientEnd: 'rgba(139, 92, 246, 0.95)',     // Púrpura Ritmo

    // Tipografía
    titleFont: 'bold 24px Arial, sans-serif',
    titleColor: '#FFFFFF',
    titleShadow: '0 2px 4px rgba(0,0,0,0.5)',

    subtitleFont: '16px Arial, sans-serif',
    subtitleColor: 'rgba(255, 255, 255, 0.9)',

    // Espaciado
    textMargin: 20,
    titleSubtitleGap: 12
};

// Configuración específica de screenshots de Ritmo
const SCREENSHOTS_DATA = [
    {
        inputFile: 'screenshot_1_home_modern_base.png',
        outputFile: 'screenshot_1_home_modern_final.png',
        title: 'Diseñado para motivarte cada día',
        subtitle: 'UI moderna que realmente quieres abrir'
    },
    {
        inputFile: 'screenshot_2_flexibility_base.png',
        outputFile: 'screenshot_2_flexibility_final.png',
        title: 'Hábitos flexibles como tu vida real',
        subtitle: 'Tu ritmo, no el que te imponen otros',
        priority: 1 // Más importante
    },
    {
        inputFile: 'screenshot_3_stats_base.png',
        outputFile: 'screenshot_3_stats_final.png',
        title: 'Estadísticas que realmente motivan',
        subtitle: 'Progreso visual que inspira'
    },
    {
        inputFile: 'screenshot_4_reminders_base.png',
        outputFile: 'screenshot_4_reminders_final.png',
        title: 'Recordatorios en el momento perfecto',
        subtitle: 'Cada hábito con su horario ideal'
    },
    {
        inputFile: 'screenshot_5_progress_base.png',
        outputFile: 'screenshot_5_progress_final.png',
        title: 'Tu progreso nunca se sintió tan bien',
        subtitle: 'Éxito visual que motiva seguir'
    }
];

async function installSharpIfNeeded() {
    try {
        require('sharp');
        return true;
    } catch (error) {
        console.log('📦 Instalando Sharp para procesamiento de imágenes...');
        const { execSync } = require('child_process');
        try {
            execSync('npm install sharp', { stdio: 'inherit' });
            console.log('✅ Sharp instalado exitosamente');
            return true;
        } catch (installError) {
            console.log('❌ Error instalando Sharp:', installError.message);
            return false;
        }
    }
}

async function createOverlayCanvas(width, height, config) {
    const sharp = require('sharp');

    // Calcular posición del overlay
    let overlayY;
    switch (config.overlayPosition) {
        case 'top':
            overlayY = 0;
            break;
        case 'center':
            overlayY = (height - config.overlayHeight) / 2;
            break;
        case 'bottom':
        default:
            overlayY = height - config.overlayHeight;
            break;
    }

    // Crear SVG del overlay con gradiente
    const overlaySvg = `
    <svg width="${width}" height="${config.overlayHeight}" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <linearGradient id="overlayGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" style="stop-color:${config.gradientStart}" />
                <stop offset="100%" style="stop-color:${config.gradientEnd}" />
            </linearGradient>
        </defs>
        <rect width="100%" height="100%" fill="url(#overlayGradient)" />
    </svg>`;

    return {
        svgBuffer: Buffer.from(overlaySvg),
        position: { top: overlayY, left: 0 }
    };
}

async function addTextToImage(imagePath, texts, config) {
    const sharp = require('sharp');

    try {
        // Cargar imagen base
        const image = sharp(imagePath);
        const metadata = await image.metadata();

        // Crear overlay de gradiente
        const { svgBuffer, position } = await createOverlayCanvas(
            metadata.width,
            metadata.height,
            config
        );

        // Calcular posiciones de texto
        const titleY = position.top + config.textMargin + 20;
        const subtitleY = titleY + config.titleSubtitleGap + 24; // 24px es aprox altura del título

        // Crear SVG con textos
        const textSvg = `
        <svg width="${metadata.width}" height="${metadata.height}" xmlns="http://www.w3.org/2000/svg">
            <text x="50%" y="${titleY}"
                  text-anchor="middle"
                  font="${config.titleFont}"
                  fill="${config.titleColor}"
                  style="text-shadow: ${config.titleShadow}">
                ${texts.title}
            </text>
            <text x="50%" y="${subtitleY}"
                  text-anchor="middle"
                  font="${config.subtitleFont}"
                  fill="${config.subtitleColor}">
                ${texts.subtitle}
            </text>
        </svg>`;

        const textBuffer = Buffer.from(textSvg);

        // Combinar imagen base + overlay + textos
        const result = await image
            .composite([
                {
                    input: svgBuffer,
                    top: position.top,
                    left: position.left
                },
                {
                    input: textBuffer,
                    top: 0,
                    left: 0
                }
            ])
            .png({ quality: 95 })
            .toBuffer();

        return result;

    } catch (error) {
        throw new Error(`Error procesando imagen ${imagePath}: ${error.message}`);
    }
}

async function processAllScreenshots() {
    console.log('🎨 GENERADOR UNIVERSAL DE OVERLAYS');
    console.log('==================================');
    console.log('📱 App: Ritmo - Hábitos Flexibles');
    console.log('🎯 Nueva narrativa: Flexibilidad y Diferenciación');
    console.log('');

    // Verificar e instalar dependencias
    const sharpAvailable = await installSharpIfNeeded();
    if (!sharpAvailable) {
        console.log('❌ No se pudo instalar Sharp. Proceso cancelado.');
        return false;
    }

    const sharp = require('sharp');
    let successCount = 0;
    let prioritySuccess = false;

    console.log(`📸 Procesando ${SCREENSHOTS_DATA.length} screenshots...`);
    console.log('');

    for (let i = 0; i < SCREENSHOTS_DATA.length; i++) {
        const screenshot = SCREENSHOTS_DATA[i];
        const priority = screenshot.priority ? ` ⭐ PRIORIDAD #${screenshot.priority}` : '';

        console.log(`[${i + 1}/${SCREENSHOTS_DATA.length}] ${screenshot.title}${priority}`);

        try {
            // Verificar que existe el archivo base
            if (!fs.existsSync(screenshot.inputFile)) {
                console.log(`  ❌ Archivo no encontrado: ${screenshot.inputFile}`);
                continue;
            }

            // Procesar imagen
            const resultBuffer = await addTextToImage(
                screenshot.inputFile,
                {
                    title: screenshot.title,
                    subtitle: screenshot.subtitle
                },
                OVERLAY_CONFIG
            );

            // Guardar resultado
            fs.writeFileSync(screenshot.outputFile, resultBuffer);

            // Verificar tamaño del archivo
            const stats = fs.statSync(screenshot.outputFile);
            const fileSizeKB = Math.round(stats.size / 1024);

            console.log(`  ✅ Creado: ${screenshot.outputFile} (${fileSizeKB} KB)`);

            if (screenshot.priority === 1) {
                prioritySuccess = true;
            }

            successCount++;

        } catch (error) {
            console.log(`  ❌ Error: ${error.message}`);
        }
    }

    console.log('');
    console.log('==================================');
    console.log(`🎊 Procesamiento completado: ${successCount}/${SCREENSHOTS_DATA.length}`);

    if (successCount === SCREENSHOTS_DATA.length) {
        console.log('🚀 ¡Todos los overlays añadidos exitosamente!');

        if (prioritySuccess) {
            console.log('⭐ Screenshot prioritario (flexibilidad) completado');
        }

        console.log('');
        console.log('📋 ARCHIVOS FINALES PARA PLAY STORE:');
        SCREENSHOTS_DATA.forEach((shot, i) => {
            const priority = shot.priority ? ' ⭐' : '';
            console.log(`${i + 1}. ${shot.outputFile}${priority}`);
        });

        console.log('');
        console.log('🎯 PRÓXIMOS PASOS:');
        console.log('1. ✅ Screenshots finales listos');
        console.log('2. 📦 Subir a Google Play Console');
        console.log('3. 🚀 Configurar store listing');
        console.log('4. 🎊 ¡Lanzar Ritmo!');

        return true;

    } else if (successCount > 0) {
        console.log(`✅ ${successCount} overlays creados correctamente`);
        console.log('⚠️  Revisar errores para los fallidos');
        return false;
    } else {
        console.log('❌ No se pudo procesar ningún screenshot');
        return false;
    }
}

// Función para configuraciones futuras (template reutilizable)
function generateConfigTemplate(appName, primaryColor, gradientColor) {
    return {
        appName,
        primaryColor,
        gradientStart: `rgba(${gradientColor}, 0)`,
        gradientEnd: `rgba(${gradientColor}, 0.95)`,
        // ... resto de configuración
    };
}

// Ejecutar procesamiento
if (require.main === module) {
    processAllScreenshots()
        .then(success => {
            if (success) {
                console.log('');
                console.log('🎵 ¡Ritmo listo para conquistar Play Store!');
                console.log('💡 Este script es reutilizable para futuras apps');
            }
        })
        .catch(error => {
            console.log('❌ Error fatal:', error.message);
            console.log('');
            console.log('🔧 FALLBACK MANUAL:');
            console.log('1. Usar Canva/Figma para añadir overlays');
            console.log('2. Gradiente: rgba(139,92,246,0) → rgba(139,92,246,0.95)');
            console.log('3. Textos según especificaciones en código');
        });
}

module.exports = {
    processAllScreenshots,
    generateConfigTemplate,
    OVERLAY_CONFIG,
    SCREENSHOTS_DATA
};