#!/usr/bin/env node
/**
 * Script completo para capturar TODOS los screenshots de Ritmo
 * Método funcional con Puppeteer
 */

const puppeteer = require('puppeteer');
const fs = require('fs');

async function captureAllScreenshots() {
    console.log('🎯 CAPTURA COMPLETA DE SCREENSHOTS - RITMO');
    console.log('Nueva narrativa: Flexibilidad y Diferenciación');
    console.log('==========================================');

    try {
        const browser = await puppeteer.launch({
            headless: 'new',
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });

        const page = await browser.newPage();

        // Configurar viewport móvil (iPhone 14 Pro)
        await page.setViewport({ width: 390, height: 844 });

        const screenshots = [
            {
                name: 'screenshot_1_home_modern',
                url: 'http://localhost:8080',
                title: 'Diseñado para motivarte cada día',
                subtitle: 'UI moderna que realmente quieres abrir',
                action: null, // Solo cargar la página
                wait: 3000
            },
            {
                name: 'screenshot_2_flexibility',
                url: 'http://localhost:8080',
                title: 'Hábitos flexibles como tu vida real',
                subtitle: 'Tu ritmo, no el que te imponen otros',
                action: 'add_habit', // Navegar a crear hábito
                wait: 2000
            },
            {
                name: 'screenshot_3_stats',
                url: 'http://localhost:8080',
                title: 'Estadísticas que realmente motivan',
                subtitle: 'Progreso visual que inspira',
                action: 'stats', // Ir a estadísticas
                wait: 2000
            },
            {
                name: 'screenshot_4_reminders',
                url: 'http://localhost:8080',
                title: 'Recordatorios en el momento perfecto',
                subtitle: 'Cada hábito con su horario ideal',
                action: null, // Home con lista
                wait: 2000
            },
            {
                name: 'screenshot_5_progress',
                url: 'http://localhost:8080',
                title: 'Tu progreso nunca se sintió tan bien',
                subtitle: 'Éxito visual que motiva seguir',
                action: null, // Dashboard con progreso
                wait: 2000
            }
        ];

        let successCount = 0;

        for (let i = 0; i < screenshots.length; i++) {
            const shot = screenshots[i];
            console.log(`📸 [${i + 1}/5] Capturando: ${shot.title}`);

            try {
                // Navegar a la URL
                await page.goto(shot.url, {
                    waitUntil: 'networkidle0',
                    timeout: 30000
                });

                // Ejecutar acción específica si es necesaria
                if (shot.action === 'add_habit') {
                    try {
                        // Buscar botón de agregar hábito (puede ser + o "Add" o similar)
                        const addButton = await page.$('button[title*="add"], button:has-text("+"), .add-habit-button, [data-testid="add-habit"]');
                        if (addButton) {
                            await addButton.click();
                            console.log('  ✅ Clicked add habit button');
                        }
                    } catch (e) {
                        console.log('  ⚠️  Add button not found, using home view');
                    }
                } else if (shot.action === 'stats') {
                    try {
                        // Buscar enlace/botón de estadísticas
                        const statsButton = await page.$('a[href*="stats"], button:has-text("Stats"), .stats-button, [data-testid="stats"]');
                        if (statsButton) {
                            await statsButton.click();
                            console.log('  ✅ Clicked stats button');
                        }
                    } catch (e) {
                        console.log('  ⚠️  Stats button not found, using home view');
                    }
                }

                // Esperar que la página se estabilice
                await new Promise(resolve => setTimeout(resolve, shot.wait));

                // Capturar screenshot
                await page.screenshot({
                    path: `${shot.name}_base.png`,
                    type: 'png',
                    fullPage: false
                });

                console.log(`  ✅ Capturado: ${shot.name}_base.png`);
                successCount++;

            } catch (error) {
                console.log(`  ❌ Error en ${shot.name}: ${error.message}`);
            }

            // Pequeña pausa entre capturas
            await new Promise(resolve => setTimeout(resolve, 1000));
        }

        await browser.close();

        console.log('==========================================');
        console.log(`🎊 Captura completada: ${successCount}/5 screenshots`);

        if (successCount === 5) {
            console.log('🚀 ¡Todos los screenshots base capturados exitosamente!');
            console.log('\n📋 PRÓXIMOS PASOS:');
            console.log('1. Verificar calidad de cada imagen');
            console.log('2. Añadir overlays usando templates creados');
            console.log('3. Exportar versiones finales para Play Store');
        } else if (successCount > 0) {
            console.log(`✅ ${successCount} screenshots capturados correctamente`);
            console.log('⚠️  Algunos fallaron, revisar manualmente');
        } else {
            console.log('❌ No se pudo capturar ningún screenshot');
        }

        return successCount;

    } catch (error) {
        console.log('❌ Error general:', error.message);
        console.log('\n🔧 FALLBACK - MÉTODO MANUAL:');
        console.log('1. Abrir http://localhost:8080');
        console.log('2. F12 → Device toolbar → iPhone 14 Pro (390x844)');
        console.log('3. Navegar y capturar manualmente');
        console.log('4. Usar textos de overlay de la guía creada');
        return 0;
    }
}

// Información de overlays para referencia
function showOverlayInfo() {
    console.log('\n🎨 TEXTOS PARA OVERLAYS:');
    console.log('================================');
    console.log('Gradiente: rgba(139,92,246,0) → rgba(139,92,246,0.9)');
    console.log('Altura overlay: 120px (parte inferior)');
    console.log('Fuente título: 24px bold blanco');
    console.log('Fuente subtítulo: 16px regular blanco 90%');
    console.log('');

    const overlays = [
        '1. "Diseñado para motivarte cada día" | "UI moderna que realmente quieres abrir"',
        '2. "Hábitos flexibles como tu vida real" | "Tu ritmo, no el que te imponen otros" ⭐',
        '3. "Estadísticas que realmente motivan" | "Progreso visual que inspira"',
        '4. "Recordatorios en el momento perfecto" | "Cada hábito con su horario ideal"',
        '5. "Tu progreso nunca se sintió tan bien" | "Éxito visual que motiva seguir"'
    ];

    overlays.forEach(overlay => console.log(overlay));
    console.log('\n⭐ = PRIORIDAD #1 (Screenshot más importante)');
}

// Ejecutar captura
captureAllScreenshots().then(count => {
    showOverlayInfo();
    console.log('\n🎵 ¡Ritmo listo para conquistar Play Store!');
}).catch(console.error);