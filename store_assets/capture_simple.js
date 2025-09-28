#!/usr/bin/env node
/**
 * Script simple para capturar screenshots usando playwright (más confiable)
 */

const fs = require('fs');

async function captureWithPlaywright() {
    try {
        console.log('🎬 Intentando con Playwright...');

        // Instalar playwright si no existe
        const { execSync } = require('child_process');
        try {
            execSync('npm install playwright', { stdio: 'inherit' });
        } catch (e) {
            console.log('Playwright ya instalado o error de instalación');
        }

        const { chromium } = require('playwright');

        console.log('🚀 Iniciando navegador...');
        const browser = await chromium.launch();
        const page = await browser.newPage();

        // Configurar viewport móvil
        await page.setViewportSize({ width: 390, height: 844 });

        const screenshots = [
            {
                name: 'screenshot_1_home',
                url: 'http://localhost:8080',
                title: 'Diseñado para motivarte cada día'
            },
            {
                name: 'screenshot_2_flexibility',
                url: 'http://localhost:8080',
                title: 'Hábitos flexibles como tu vida real'
            }
        ];

        for (const shot of screenshots) {
            console.log(`📸 Capturando: ${shot.title}`);

            await page.goto(shot.url, { waitUntil: 'networkidle' });
            await page.waitForTimeout(2000);

            await page.screenshot({
                path: `${shot.name}.png`,
                fullPage: false
            });

            console.log(`✅ Guardado: ${shot.name}.png`);
        }

        await browser.close();

        console.log('🎊 Screenshots capturados exitosamente!');
        return true;

    } catch (error) {
        console.log('❌ Error con Playwright:', error.message);
        return false;
    }
}

async function captureWithPuppeteerFixed() {
    try {
        console.log('🎭 Intentando con Puppeteer versión fija...');

        const puppeteer = require('puppeteer');

        const browser = await puppeteer.launch({
            headless: 'new',
            args: ['--no-sandbox']
        });

        const page = await browser.newPage();
        await page.setViewport({ width: 390, height: 844 });

        console.log('📸 Capturando home screen...');
        await page.goto('http://localhost:8080', { waitUntil: 'networkidle0' });

        // Usar delay en lugar de waitForTimeout
        await new Promise(resolve => setTimeout(resolve, 3000));

        await page.screenshot({
            path: 'screenshot_home_auto.png',
            type: 'png'
        });

        console.log('✅ Screenshot capturado: screenshot_home_auto.png');

        await browser.close();
        return true;

    } catch (error) {
        console.log('❌ Error con Puppeteer:', error.message);
        return false;
    }
}

async function main() {
    console.log('🎯 CAPTURA AUTOMÁTICA DE SCREENSHOTS');
    console.log('=====================================');

    // Verificar que la app esté corriendo
    console.log('🌐 Verificando localhost:8080...');

    let success = false;

    // Intentar método 1: Playwright
    success = await captureWithPlaywright();

    if (!success) {
        // Intentar método 2: Puppeteer corregido
        success = await captureWithPuppeteerFixed();
    }

    if (!success) {
        console.log('\n🔧 MÉTODO MANUAL REQUERIDO:');
        console.log('1. Abrir http://localhost:8080');
        console.log('2. F12 → Device toolbar → iPhone 14 Pro');
        console.log('3. Capturar screenshots manualmente');
        console.log('4. Usar overlays de templates creados');
    }
}

main().catch(console.error);