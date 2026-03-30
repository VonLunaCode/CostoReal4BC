# Script para sincronizar el Frontend con el Backend (OpenAPI)
# Uso: .\scripts\generate_api.ps1

Write-Host "--- Sincronizando Contrato OpenAPI ---" -ForegroundColor Cyan

# 1. Descargar el archivo openapi.json del Backend en ejecución
Write-Host "[1/2] Descargando openapi.json..." -ForegroundColor Yellow
try {
    curl http://localhost:8000/openapi.json -o lib/data/api_spec/openapi.json
    Write-Host "Exito: Especificación descargada." -ForegroundColor Green
} catch {
    Write-Host "Error: No se pudo conectar con el Backend. ¿Está Docker corriendo?" -ForegroundColor Red
    exit
}

# 2. Ejecutar el generador de código de Flutter
Write-Host "[2/2] Generando clases y modelos en Dart..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs

Write-Host "--- Proceso Finalizado con Exito ---" -ForegroundColor Cyan
