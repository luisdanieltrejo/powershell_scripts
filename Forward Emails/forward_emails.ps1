#Control de Versión de Powershell
IF ($psversiontable.PSVersion.Major -ne 5) 
{
	Write-Host -Foregroundcolor RED -BackgroundColor RED "ERROR: This Tool should be run in Powershell Version 5 Only - Current Version is" $psversiontable.PSVersion.Major
	RETURN
}Write-Host -Foregroundcolor DARKCYAN "Para mayor compatibilidad ejecute con powershell classic."

# Pregunta el nombre de usuario
$ADuser = $(Write-Host "Ingrese el nombre de usuario " -ForegroundColor DARKRED -NoNewLine) + $(Write-Host "(en formato SAMACCOUNTNAME o nombre de NETBIOS) " -ForegroundColor DARKGRAY -NoNewLine; Read-Host)
$FullUserName = ($ADuser.ToLower() +"@tqcorp.com")

# Pregunta si se desea habilitar el reenvío de correos
$AskForwarding = $(Write-Host "Desea habilitar el reenvio de correos? " -ForegroundColor DARKRED -NoNewLine) + $(Write-Host "(Si/No) " -ForegroundColor RED -NoNewLine; Read-Host)
Write-Host ""
Write-Host -Foregroundcolor DARKYELLOW "IMPORTANTE: El usuario debe estar dado de baja para poder realizar el desvio de correos"
Write-Host ""

if ($AskForwarding -in "si", "s", "y", "yes") {
    # Solicita la dirección de correo a la que se deben reenviar los correos
    $UserToReceipt = $(Write-Host "Por favor, ingrese el usuario al que se deben reenviar los correos " -ForegroundColor DARKRED -NoNewLine) + $(Write-Host "(ejemplo usuario@dominio.com): " -ForegroundColor DARKGRAY -NoNewLine; Read-Host)
    # Configurar el desvío de correos entrantes para el usuario
    Set-ADUser $UserToReceipt -add @{ProxyAddresses="smtp:$FullUserName"}
    Write-Host ""
    (Write-Host  -ForegroundColor DARKGREEN -NoNewLine "Configurando desvio de correos entrantes del usuario ") + $(Write-Host -ForegroundColor darkgray -NoNewLine "$FullUsername" ) + $(Write-Host -ForegroundColor darkgreen -NoNewLine " a el usuario " ) + $(Write-Host -ForegroundColor darkgray -NoNewLine "$UserToReceipt" ) + (Write-Host  -ForegroundColor darkgreen -NoNewLine "...")
    Write-Host ""    
} else {
    Write-Host -Foregroundcolor DARKCYAN "No se configura el desvio de correos"
}

# Verificacion de usuario en proxyaddress
$Usertocheckproxyaddress = Get-ADUser -Identity $UserToReceipt -Property proxyAddresses

if ($Usertocheckproxyaddress.proxyAddresses -contains $FullUserName -or $Usertocheckproxyaddress.proxyAddresses -contains "smtp:$FullUserName") {
    (Write-Host  -ForegroundColor DARKGREEN -NoNewLine "Se ha configurado y verificado que los correos entrantes del usuario ") + $(Write-Host -ForegroundColor darkgray -NoNewLine "$ADuser " ) + $(Write-Host -ForegroundColor darkgreen -NoNewLine "se recibirán en el usuario " ) + $(Write-Host -ForegroundColor darkgray -NoNewLine "$UserToReceipt " ) + (Write-Host  -ForegroundColor darkgreen -NoNewLine ".")
} else {
    Write-Host -ForegroundColor RED "Los correos del usuario $FullUsername no se han derivado al usuario $UserToReceipt. Por favor verifique."
}