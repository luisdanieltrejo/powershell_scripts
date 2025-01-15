# URL del archivo MSI
$url = "https://app.action1.com/agent/37b37274-b964-11ef-ac6b-ebcdad67ee5c/Windows/agent(Company).msi"

# Ruta de destino para el archivo MSI
$outputPath = "C:\Temp\action1_agent_Company.msi"

# Crear el directorio de destino si no existe
if (-Not (Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
}

# Descargar el archivo MSI
try {
    Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
    Write-Output "Descarga completada: $outputPath"
} catch {
    Write-Output "Error: No se pudo descargar el archivo MSI. Detalles: $_"
    exit 1
}

# Verificar si el archivo MSI existe
if (Test-Path -Path $outputPath) {
    Write-Output "Iniciando la instalación del agente..."

    # Instalar el agente MSI
    try {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$outputPath`" /quiet" -Wait -NoNewWindow
        Write-Output "Instalación completada correctamente."
    } catch {
        Write-Output "Error durante la instalación: $_"
        exit 1
    }
} else {
    Write-Output "Error: El archivo MSI no existe en la ruta: $outputPath"
    exit 1
}