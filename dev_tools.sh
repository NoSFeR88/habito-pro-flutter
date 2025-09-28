#!/bin/bash
# 🛠️ HERRAMIENTAS DE DESARROLLO FLUTTER INTEGRADAS
# Script de utilidades para desarrollo profesional de Flutter

# Configuración de colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables de entorno
ADB_PATH="/c/Users/shill/AppData/Local/Android/sdk/platform-tools/adb.exe"
PROJECT_NAME="com.ritmo.daily_habits"

echo -e "${PURPLE}🛠️  HERRAMIENTAS DE DESARROLLO FLUTTER${NC}"
echo "=================================================="

function show_help() {
    echo -e "${CYAN}Comandos disponibles:${NC}"
    echo "  dev_tools.sh devices     - Lista dispositivos conectados"
    echo "  dev_tools.sh uninstall   - Desinstala la app para testing limpio"
    echo "  dev_tools.sh install     - Instala y ejecuta la app"
    echo "  dev_tools.sh logs        - Muestra logs del dispositivo"
    echo "  dev_tools.sh clean       - Limpia proyecto y reinstala dependencias"
    echo "  dev_tools.sh analyze     - Ejecuta análisis de código"
    echo "  dev_tools.sh test        - Ejecuta todos los tests"
    echo "  dev_tools.sh coverage    - Genera reporte de cobertura"
    echo "  dev_tools.sh build       - Construye APK de release"
    echo "  dev_tools.sh web         - Construye y sirve versión web"
    echo "  dev_tools.sh metrics     - Analiza métricas de código"
}

function list_devices() {
    echo -e "${BLUE}📱 Dispositivos conectados:${NC}"
    "$ADB_PATH" devices -l
    echo ""
    echo -e "${BLUE}🔄 Dispositivos Flutter:${NC}"
    flutter devices
}

function uninstall_app() {
    echo -e "${YELLOW}🗑️  Desinstalando app...${NC}"
    "$ADB_PATH" uninstall $PROJECT_NAME
    echo -e "${GREEN}✅ App desinstalada${NC}"
}

function install_and_run() {
    echo -e "${BLUE}🚀 Instalando y ejecutando app...${NC}"
    flutter run -d 2311DRK48G
}

function show_logs() {
    echo -e "${BLUE}📋 Logs del dispositivo (Ctrl+C para salir):${NC}"
    "$ADB_PATH" logcat -v time | grep flutter
}

function clean_project() {
    echo -e "${YELLOW}🧹 Limpiando proyecto...${NC}"
    flutter clean
    echo -e "${BLUE}📦 Obteniendo dependencias...${NC}"
    flutter pub get
    echo -e "${GREEN}✅ Proyecto limpio${NC}"
}

function analyze_code() {
    echo -e "${BLUE}🔍 Analizando código...${NC}"
    flutter analyze
    echo ""
    echo -e "${BLUE}📊 Verificando formato...${NC}"
    dart format --set-exit-if-changed lib/
}

function run_tests() {
    echo -e "${BLUE}🧪 Ejecutando tests...${NC}"
    flutter test
}

function generate_coverage() {
    echo -e "${BLUE}📈 Generando reporte de cobertura...${NC}"
    flutter test --coverage
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}✅ Reporte HTML generado en coverage/html/${NC}"
    else
        echo -e "${YELLOW}⚠️  Instala lcov para generar reporte HTML${NC}"
    fi
}

function build_release() {
    echo -e "${BLUE}🔨 Construyendo APK de release...${NC}"
    flutter build apk --release
    echo -e "${GREEN}✅ APK construido en build/app/outputs/flutter-apk/${NC}"
}

function build_web() {
    echo -e "${BLUE}🌐 Construyendo versión web...${NC}"
    flutter build web
    echo -e "${BLUE}🚀 Sirviendo versión web...${NC}"
    dhttpd --host 0.0.0.0 --port 8080 --path build/web/
}

function analyze_metrics() {
    echo -e "${BLUE}📊 Analizando métricas de código...${NC}"
    if command -v metrics &> /dev/null; then
        metrics analyze lib
    else
        echo -e "${YELLOW}⚠️  dart_code_metrics no disponible${NC}"
    fi
}

# Procesamiento de argumentos
case "${1:-help}" in
    "devices")
        list_devices
        ;;
    "uninstall")
        uninstall_app
        ;;
    "install")
        install_and_run
        ;;
    "logs")
        show_logs
        ;;
    "clean")
        clean_project
        ;;
    "analyze")
        analyze_code
        ;;
    "test")
        run_tests
        ;;
    "coverage")
        generate_coverage
        ;;
    "build")
        build_release
        ;;
    "web")
        build_web
        ;;
    "metrics")
        analyze_metrics
        ;;
    "help"|*)
        show_help
        ;;
esac