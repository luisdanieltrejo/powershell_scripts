# Solicitar el nombre del usuario de Active Directory
$UserName = Read-Host "Ingrese el nombre del usuario de Active Directory (SAMAccountName): "

# Solicitar la dirección de correo electrónico
$EmailToCheck = Read-Host "Ingrese la dirección de correo electrónico que desea verificar: "

# Obtener el usuario de Active Directory
$User = Get-ADUser -Identity $UserName -Property proxyAddresses

# Verificar si el correo está en las direcciones proxy
if ($User.proxyAddresses -contains $EmailToCheck -or $User.proxyAddresses -contains "smtp:$EmailToCheck") {
    Write-Host "El usuario $UserName ya recibe correos desde la direccion $EmailToCheck." -ForegroundColor Green
} else {
    Write-Host "El usuario $UserName no recibe correos desde la direccion $EmailToCheck." -ForegroundColor Red
}