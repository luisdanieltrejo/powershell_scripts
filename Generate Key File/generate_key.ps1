# Función para mostrar el menú
function Show-Menu {
    Clear-Host
    Write-Host -ForegroundColor DarkRed "¿Qué key desea generar?"
    Write-Host ""
    Write-Host -ForegroundColor White "1. Tenant"
    Write-Host -ForegroundColor White "2. Forti"
    Write-Host -ForegroundColor White "3. VCenter"
    Write-Host -ForegroundColor White "4. VCenter (Nuevo)"
    Write-Host -ForegroundColor White "Otro para salir"
    Write-Host ""
}

# Función para generar la ruta de destino de las keys según el usuario. Util si diferentes usuarios tienen clonado el repo en diferentes directorios.
function Get-KeyFilePath {
    $CurrentUser = $env:UserName.ToLower()
    $BasePath = Join-Path $env:UserProfile "Documents"

    switch ($CurrentUser) {
        "user1"     { $GitFolder = "GIT" }
        "user2"     { $GitFolder = "DevopsTools" }
        "user3"     { $GitFolder = "Tools" }
        default       {
            Write-Host -ForegroundColor DarkYellow "Usuario no reconocido: $CurrentUser"
            return $null
        }
    }

    # Ruta completa
    return Join-Path -Path $BasePath -ChildPath "$GitFolder\Tools\Key\$CurrentUser"
}

# Función para procesar la opción seleccionada
function Process-Option {
    param (
        [string]$Option,
        [string]$KeyFileName
    )

    switch ($Option.ToLower()) {
        "1" { Generate-Key "Servicio 1" "$KeyFileName.servicio1.key" }
        "2" { Generate-Key "Servicio 2" "$KeyFileName.servicio2.key" }
        "3" { Generate-Key "Servicio 3" "$KeyFileName.servicio3.key" }
        "4" { Generate-Key "Servicio 4" "$KeyFileName.servicio4.key" $true }
        default {
            Write-Host -ForegroundColor DarkYellow "Opción no válida. Saliendo..."
            return
        }
    }
}

# Función para generar las keys
function Generate-Key {
    param (
        [string]$KeyType,
        [string]$KeyPath,
        [bool]$UseExportXml = $false
    )

    Write-Host -ForegroundColor DarkGreen "Generando key para $KeyType..."
    $credential = Get-Credential

    # Guarda la clave y la ofusca
    if ($UseExportXml) {
        $credential | Export-Clixml -Path $KeyPath
    } else {
        $credential.Password | ConvertFrom-SecureString | Set-Content -Path $KeyPath
    }

    Write-Host -ForegroundColor DarkGreen "Key generada en: $KeyPath"
}

# Script principal
function Main {
    $KeyFilePath = Get-KeyFilePath

    if (-not $KeyFilePath) {
        Write-Host -ForegroundColor Red "Error: No se pudo determinar la ruta de las keys."
        return
    }

    # Mostrar menú y procesar opción
    do {
        Show-Menu
        $Option = Read-Host "Seleccione una opción (escriba 1, 2, 3, 4 o cualquier otra para salir)"
        Process-Option -Option $Option -KeyFileName $KeyFilePath
    } while ($Option -match "^[1-4]$")
}

# Ejecutar el script principal
Main