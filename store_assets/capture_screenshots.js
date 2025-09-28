#!/usr/bin/env node
/**
 * Script para capturar Screenshots estratégicos de Ritmo
 * Nueva narrativa: Flexibilidad y Diferenciación Real
 */

const fs = require('fs');
const path = require('path');

// URLs y configuración
const BASE_URL = 'http://localhost:8080';
const SCREENSHOTS_CONFIG = [
    {
        name: 'screenshot_1_home_modern',
        url: BASE_URL,
        title: 'Diseñado para motivarte cada día',
        subtitle: 'UI moderna que realmente quieres abrir',
        wait: 3000
    },
    {
        name: 'screenshot_2_flexibility',
        url: BASE_URL + '/#/add',  // Pantalla de agregar hábito
        title: 'Hábitos flexibles como tu vida real',
        subtitle: 'Tu ritmo, no el que te imponen otros',
        wait: 2000
    },
    {
        name: 'screenshot_3_stats_advanced',
        url: BASE_URL + '/#/stats',  // Pantalla de estadísticas
        title: 'Estadísticas que realmente motivan',
        subtitle: 'Progreso visual que inspira',
        wait: 2000
    },
    {
        name: 'screenshot_4_reminders',
        url: BASE_URL,  // Home con lista de hábitos
        title: 'Recordatorios en el momento perfecto',
        subtitle: 'Cada hábito con su horario ideal',
        wait: 2000
    },
    {
        name: 'screenshot_5_progress',
        url: BASE_URL,  // Dashboard con progreso
        title: 'Tu progreso nunca se sintió tan bien',
        subtitle: 'Éxito visual que motiva seguir',
        wait: 2000
    }
];

async function captureScreenshots() {
    try {
        console.log('📱 CAPTURADOR DE SCREENSHOTS - RITMO 2025');
        console.log('Nueva narrativa: Flexibilidad y Diferenciación');
        console.log('=' * 60);

        // Verificar que la app esté corriendo
        console.log('🌐 Verificando que la app esté disponible...');

        // Intentar usar Puppeteer
        let puppeteer;
        try {
            puppeteer = await import('puppeteer');
        } catch (error) {
            console.log('⚠️  Puppeteer no encontrado. Instalando...');
            const { execSync } = require('child_process');
            execSync('npm install puppeteer', { stdio: 'inherit' });
            puppeteer = await import('puppeteer');
        }

        console.log('🚀 Iniciando navegador para capturas...');
        const browser = await puppeteer.default.launch({
            headless: 'new',
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-web-security'
            ]
        });

        const page = await browser.newPage();

        // Configurar viewport para móvil (tamaño típico de screenshots Play Store)
        await page.setViewport({
            width: 390,   // iPhone 14 Pro width
            height: 844,  // iPhone 14 Pro height
            deviceScaleFactor: 2
        });

        let successCount = 0;

        // Capturar cada screenshot
        for (let i = 0; i < SCREENSHOTS_CONFIG.length; i++) {
            const config = SCREENSHOTS_CONFIG[i];
            console.log(`📸 Capturando ${i + 1}/5: ${config.title}`);

            try {
                // Navegar a la URL
                await page.goto(config.url, {
                    waitUntil: 'networkidle0',
                    timeout: 30000
                });

                // Esperar que la página se cargue completamente
                await page.waitForTimeout(config.wait);

                // Tomar screenshot base
                const screenshotPath = `${config.name}_base.png`;
                await page.screenshot({
                    path: screenshotPath,
                    fullPage: false,
                    type: 'png'
                });

                console.log(`  ✅ Base capturado: ${screenshotPath}`);

                // Crear versión con overlay
                await createScreenshotWithOverlay(config, screenshotPath);

                successCount++;

            } catch (error) {
                console.log(`  ❌ Error capturando ${config.name}: ${error.message}`);
            }
        }

        await browser.close();

        console.log('=' * 60);
        console.log(`🎊 Capturas completadas: ${successCount}/${SCREENSHOTS_CONFIG.length}`);

        if (successCount === SCREENSHOTS_CONFIG.length) {
            console.log('🚀 ¡Todos los screenshots listos para Play Store!');
            showNextSteps();
        } else {
            console.log('⚠️  Algunos screenshots fallaron.');
            showManualMethod();
        }

        return successCount === SCREENSHOTS_CONFIG.length;

    } catch (error) {
        console.log('❌ Error general:', error.message);
        showManualMethod();
        return false;
    }
}

async function createScreenshotWithOverlay(config, basePath) {
    try {
        // Usar sharp para agregar overlay
        const sharp = await import('sharp');

        // Leer screenshot base
        const baseImage = sharp.default(basePath);
        const metadata = await baseImage.metadata();

        // Crear overlay SVG
        const overlayHeight = 120;
        const overlayY = metadata.height - overlayHeight;

        const overlaySvg = `
        <svg width="${metadata.width}" height="${overlayHeight}">
            <defs>
                <linearGradient id="grad1" x1="0%" y1="0%" x2="0%" y2="100%">
                    <stop offset="0%" style="stop-color:rgba(139,92,246,0);stop-opacity:0" />
                    <stop offset="100%" style="stop-color:rgba(139,92,246,0.9);stop-opacity:1" />
                </linearGradient>
            </defs>
            <rect width="100%" height="100%" fill="url(#grad1)" />
            <text x="50%" y="30%" text-anchor="middle" font-family="Arial" font-size="24" font-weight="bold" fill="white">
                ${config.title}
            </text>
            <text x="50%" y="70%" text-anchor="middle" font-family="Arial" font-size="16" fill="white" opacity="0.9">
                ${config.subtitle}
            </text>
        </svg>`;

        // Crear imagen con overlay
        const overlayBuffer = Buffer.from(overlaySvg);
        const finalPath = `${config.name}_final.png`;

        await baseImage
            .composite([{
                input: overlayBuffer,
                top: overlayY,
                left: 0
            }])
            .png()
            .toFile(finalPath);

        console.log(`  ✅ Con overlay: ${finalPath}`);

        // Eliminar archivo base temporal
        if (fs.existsSync(basePath)) {
            fs.unlinkSync(basePath);
        }

        return true;

    } catch (error) {
        console.log(`  ⚠️  Error creando overlay para ${config.name}: ${error.message}`);
        return false;
    }
}

function showNextSteps() {
    console.log('\n📋 PRÓXIMOS PASOS:');
    console.log('1. ✅ Screenshots con nueva narrativa listos');
    console.log('2. Verificar calidad de cada imagen');
    console.log('3. Configurar Google Play Console con assets');
    console.log('4. Subir AAB y completar store listing');
    console.log('5. Lanzar y monitorear conversión');
}

function showManualMethod() {
    console.log('\n🔧 MÉTODO MANUAL:');
    console.log('Si el método automático falla:');
    console.log('1. Abrir http://localhost:8080 en navegador');
    console.log('2. Navegar a cada pantalla manualmente');
    console.log('3. Tomar screenshots con herramientas del navegador');
    console.log('4. Agregar overlays con Canva/Figma');
    console.log('\nTextos para overlays:');

    SCREENSHOTS_CONFIG.forEach((config, i) => {
        console.log(`${i + 1}. "${config.title}" - "${config.subtitle}"`);
    });
}

// Ejecutar script
console.log('🎵 INICIANDO CAPTURA DE SCREENSHOTS...\n');
captureScreenshots().catch(error => {
    console.log('❌ Error fatal:', error.message);
    showManualMethod();
});