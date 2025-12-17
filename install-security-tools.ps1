#!/usr/bin/env pwsh
# --------------------------------------------------------------
# Script: install-security-tools.ps1
#
# Propósito:
#   Instalar y verificar herramientas de seguridad necesarias
#   para el pipeline DevSecOps del proyecto en Windows.
#
# Herramientas cubiertas:
#   - Chocolatey (gestor de paquetes)
#   - Hadolint (linting de Dockerfile)
#   - Trivy (escaneo de vulnerabilidades)
#   - SonarScanner (análisis estático - opcional)
#
# Público objetivo:
#   - Entornos académicos
#   - Desarrolladores en Windows
#
# Encabezado visual informativo
# Script para instalar herramientas de seguridad en Windows
# Este script facilita la instalación de todas las herramientas necesarias
# --------------------------------------------------------------

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "INSTALADOR DE HERRAMIENTAS DE SEGURIDAD" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# --------------------------------------------------------------
# Verificación de Chocolatey
#
# Chocolatey se utiliza como gestor de paquetes para Windows
# y permite instalar herramientas CLI de forma reproducible.
# --------------------------------------------------------------
Write-Host "[INFO] Verificando Chocolatey..." -ForegroundColor Blue
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "[✓] Chocolatey está instalado" -ForegroundColor Green
} else {
    Write-Host "[!] Chocolatey no está instalado" -ForegroundColor Red
    Write-Host "[INFO] Instalando Chocolatey..." -ForegroundColor Blue
    Write-Host "[INFO] Necesitarás ejecutar PowerShell como Administrador" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ejecuta este comando en PowerShell como Administrador:" -ForegroundColor Yellow
    Write-Host "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Presiona Enter después de instalar Chocolatey"
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Yellow
Write-Host "Instalando herramientas..." -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Yellow

# --------------------------------------------------------------
# Instalación de Hadolint
#
# Hadolint analiza Dockerfiles en busca de:
#   - malas prácticas
#   - problemas de seguridad
#   - errores comunes
# --------------------------------------------------------------
Write-Host ""
Write-Host "[1/3] Instalando Hadolint..." -ForegroundColor Blue
if (Get-Command hadolint -ErrorAction SilentlyContinue) {
    Write-Host "[✓] Hadolint ya está instalado" -ForegroundColor Green
    hadolint --version
} else {
    Write-Host "[INFO] Instalando con Chocolatey..." -ForegroundColor Blue
    choco install hadolint -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Hadolint instalado correctamente" -ForegroundColor Green
    } else {
        Write-Host "[!] Error al instalar Hadolint" -ForegroundColor Red
        Write-Host "[INFO] Instala manualmente desde: https://github.com/hadolint/hadolint/releases" -ForegroundColor Yellow
    }
}

# --------------------------------------------------------------
# Instalación de Trivy
#
# Trivy se utiliza para:
#   - escanear imágenes Docker
#   - detectar vulnerabilidades CVE
#   - validar configuraciones inseguras
# --------------------------------------------------------------
Write-Host ""
Write-Host "[2/3] Instalando Trivy..." -ForegroundColor Blue
if (Get-Command trivy -ErrorAction SilentlyContinue) {
    Write-Host "[✓] Trivy ya está instalado" -ForegroundColor Green
    trivy --version
} else {
    Write-Host "[INFO] Instalando con Chocolatey..." -ForegroundColor Blue
    choco install trivy -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Trivy instalado correctamente" -ForegroundColor Green
    } else {
        Write-Host "[!] Error al instalar Trivy" -ForegroundColor Red
        Write-Host "[INFO] Instala manualmente desde: https://github.com/aquasecurity/trivy/releases" -ForegroundColor Yellow
    }
}

# --------------------------------------------------------------
# Instalación de SonarScanner (opcional)
#
# SonarScanner permite análisis estático de código:
#   - calidad
#   - bugs
#   - code smells
#   - vulnerabilidades
# --------------------------------------------------------------
Write-Host ""
Write-Host "[3/3] Instalando SonarScanner (opcional)..." -ForegroundColor Blue
if (Get-Command sonar-scanner -ErrorAction SilentlyContinue) {
    Write-Host "[✓] SonarScanner ya está instalado" -ForegroundColor Green
    sonar-scanner --version
} else {
    Write-Host "[INFO] Instalando con Chocolatey..." -ForegroundColor Blue
    choco install sonarscanner -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] SonarScanner instalado correctamente" -ForegroundColor Green
    } else {
        Write-Host "[!] Error al instalar SonarScanner" -ForegroundColor Red
        Write-Host "[INFO] Instala manualmente desde: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "RESUMEN DE INSTALACIÓN" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# --------------------------------------------------------------
# Resumen final de herramientas disponibles
#
# Se verifica la presencia de herramientas clave
# utilizadas por el pipeline de seguridad.
# --------------------------------------------------------------
$tools = @("hadolint", "trivy", "docker", "node", "npm")
foreach ($tool in $tools) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Host "[✓] $tool - Instalado" -ForegroundColor Green
    } else {
        Write-Host "[✗] $tool - NO instalado" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "¡Instalación completada!" -ForegroundColor Green
Write-Host "Ahora puedes ejecutar: ./security-pipeline.ps1" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan


# --------------------------------------------------------------
#
# Observaciones técnicas (NO aplicadas)
#
# --------------------------------------------
# Dependencia de Chocolatey
#
#   Facilita instalación en Windows
#   Reduce pasos manuales
#
#   Limitación:
#   - Requiere permisos de Administrador
#   - No es multiplataforma
#
#   Alternativa:
#   - Scripts separados para Linux / macOS
#
# --------------------------------------------
# Enfoque interactivo
#
#   Uso de Read-Host facilita uso manual
#   Ideal para entorno académico
#
#   En CI/CD:
#   - El script debería ser no interactivo
#   - Uso de flags automáticos
#
# --------------------------------------------
# Versionado de herramientas
#
#   Se instala la última versión disponible
#
#   En producción:
#   - Fijar versiones específicas
#   - Evitar cambios inesperados
#
# --------------------------------------------
# Validación básica de instalación
#
#   Se verifica solo la existencia del comando
#
#   Mejora posible:
#   - Validar versiones mínimas requeridas
#   - Comparar contra baseline del proyecto
#
# --------------------------------------------
# Alcance del script
#
#   Pensado para desarrolladores locales
#   No orientado a servidores
#
#   Correcto para el alcance del proyecto
#
# --------------------------------------------------------------