# Solicitar el nombre del usuario de Active Directory
Write-Host "Ingrese el nombre del usuario de Active Directory " -ForegroundColor DarkRed -NoNewline; Write-Host "(en formato SAMACCOUNTNAME o nombre de NETBIOS)" -ForegroundColor DarkGray -NoNewline; Write-Host ":" -ForegroundColor DarkRed -NoNewline; $UserName = Read-Host

# Solicitar la dirección de correo electrónico
$EmailToCheck = $(Write-Host "Desea habilitar el reenvio de correos? " -ForegroundColor DARKRED -NoNewLine)

# Obtener el usuario de Active Directory
$User = Get-ADUser -Identity $UserName -Property proxyAddresses

# Verificar si el correo está en las direcciones proxy
if ($User.proxyAddresses -contains $EmailToCheck -or $User.proxyAddresses -contains "smtp:$EmailToCheck") {
    Write-Host "El usuario $UserName ya recibe correos desde la direccion $EmailToCheck." -ForegroundColor Green
} else {
    Write-Host "El usuario $UserName no recibe correos desde la direccion $EmailToCheck." -ForegroundColor Red
}