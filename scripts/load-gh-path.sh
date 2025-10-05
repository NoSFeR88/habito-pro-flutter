#!/bin/bash
# load-gh-path.sh
# Helper script para cargar GitHub CLI en el PATH de la sesión actual
# Uso: source scripts/load-gh-path.sh

# Agregar GitHub CLI al PATH si no está ya
if ! command -v gh &> /dev/null; then
    export PATH="$PATH:/c/Program Files/GitHub CLI"
    echo "[*] GitHub CLI agregado al PATH de la sesión actual"
    echo "[*] gh version: $(gh --version | head -n 1)"
else
    echo "[*] GitHub CLI ya disponible: $(gh --version | head -n 1)"
fi
