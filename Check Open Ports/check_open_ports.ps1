# Obtener nombre de VM
$RemoteServer = $(Write-Host "Ingrese el nombre de servidor: " -ForegroundColor DarkCyan -NoNewLine; Read-Host)
if ($RemoteServer -eq "") {
  Write-Host -ForegroundColor DarkYellow -BackgroundColor Black "Por favor ingrese un nombre valido."
  exit
}

# Obtener numero de puerto
$RemotePort = $(Write-Host "Ingrese el numero de puerto: " -ForegroundColor DarkMagenta -NoNewLine; Read-Host)
if ($RemotePort -eq "") {
  Write-Host -ForegroundColor DarkYellow -BackgroundColor Black "Por favor ingrese un nombre valido."
  exit
}

# Resultado
$result = Test-NetConnection -ComputerName $RemoteServer -Port $RemotePort

if ($result.TcpTestSucceeded) {
    Write-Host "El puerto $RemotePort está abierto en el servidor $RemoteServer." -ForegroundColor DarkGreen -NoNewLine
} else {
    Write-Host "El puerto $RemotePort está cerrado en el servidor $RemoteServer." -ForegroundColor DarkRed -NoNewLine