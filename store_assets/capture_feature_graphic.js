#!/usr/bin/env node
/**
 * Script para capturar el Feature Graphic de Ritmo automáticamente
 * Genera PNG 1024x500px desde el template HTML
 */

const fs = require('fs');
const path = require('path');

async function captureFeatureGraphic() {
    try {
        console.log('🎨 CAPTURADOR DE FEATURE GRAPHIC - RITMO');
        console.log('='.repeat(50));

        // Verificar que el template HTML existe
        const templatePath = path.join(__dirname, 'feature_graphic_template.html');
        if (!fs.existsSync(templatePath)) {
            console.log('❌ Template HTML no encontrado:', templatePath);
            return false;
        }

        // Intentar usar Puppeteer
        let puppeteer;
        try {
            puppeteer = await import('puppeteer');
        } catch (error) {
            console.log('⚠️  Puppeteer no está instalado. Instalando...');
            console.log('📦 Ejecutando: npm install puppeteer');

            const { execSync } = require('child_process');
            try {
                execSync('npm install puppeteer', { stdio: 'inherit' });
                puppeteer = await import('puppeteer');
                console.log('✅ Puppeteer instalado exitosamente');
            } catch (installError) {
                console.log('❌ Error instalando Puppeteer:', installError.message);
                showManualMethod();
                return false;
            }
        }

        console.log('🌐 Iniciando navegador headless...');
        const browser = await puppeteer.default.launch({
            headless: 'new',
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });

        const page = await browser.newPage();

        // Configurar viewport para alta resolución
        await page.setViewport({
            width: 1200,
            height: 800,
            deviceScaleFactor: 2
        });

        // Convertir ruta a URL de archivo
        const fileUrl = `file://${templatePath.replace(/\\/g, '/')}`;
        console.log('📄 Cargando template:', fileUrl);

        await page.goto(fileUrl, {
            waitUntil: 'networkidle0',
            timeout: 30000
        });

        // Esperar a que las animaciones se carguen
        await page.waitForTimeout(2000);

        console.log('📸 Capturando feature graphic...');

        // Tomar screenshot del elemento específico
        const element = await page.$('.feature-graphic');
        if (!element) {
            console.log('❌ No se encontró el elemento .feature-graphic');
            await browser.close();
            return false;
        }

        const outputPath = path.join(__dirname, 'ritmo_feature_graphic_1024x500.png');
        await element.screenshot({
            path: outputPath,
            type: 'png',
            clip: {
                x: 0,
                y: 0,
                width: 1024,
                height: 500
            }
        });

        await browser.close();

        // Verificar que el archivo se creó
        if (fs.existsSync(outputPath)) {
            const stats = fs.statSync(outputPath);
            const fileSizeKB = Math.round(stats.size / 1024);

            console.log('✅ Feature graphic creado exitosamente!');
            console.log(`📄 Archivo: ${outputPath}`);
            console.log(`📦 Tamaño: ${fileSizeKB} KB`);

            if (fileSizeKB > 1024) {
                console.log('⚠️  Archivo > 1MB. Considerar comprimir para Play Store');
            }

            showNextSteps();
            return true;
        } else {
            console.log('❌ Error: No se pudo crear el archivo PNG');
            return false;
        }

    } catch (error) {
        console.log('❌ Error general:', error.message);
        showManualMethod();
        return false;
    }
}

function showNextSteps() {
    console.log('\n📋 PRÓXIMOS PASOS:');
    console.log('1. ✅ Feature graphic listo para Play Store');
    console.log('2. Verificar calidad y dimensiones (1024x500px)');
    console.log('3. Continuar con captura de screenshots');
    console.log('4. Configurar Google Play Console');
}

function showManualMethod() {
    console.log('\n🔧 MÉTODO MANUAL:');
    console.log('Si el método automático no funciona:');
    console.log('1. Abrir feature_graphic_template.html en navegador');
    console.log('2. Usar herramientas de desarrollador (F12)');
    console.log('3. Seleccionar elemento .feature-graphic');
    console.log('4. Tomar screenshot exacto 1024x500px');
    console.log('5. Guardar como: ritmo_feature_graphic_1024x500.png');
    console.log('\nAlternativamente:');
    console.log('- Usar herramientas como Figma/Canva');
    console.log('- Recrear con las especificaciones del template');
    console.log('- Usar servicios online de screenshot');
}

// Ejecutar script
console.log('🎵 INICIANDO CAPTURA DE FEATURE GRAPHIC...\n');
captureFeatureGraphic().catch(error => {
    console.log('❌ Error fatal:', error.message);
    showManualMethod();
});