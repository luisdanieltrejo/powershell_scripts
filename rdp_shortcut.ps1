# Ruta al escritorio del usuario actual
$DesktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"))
# Crear objeto de acceso directo
$Shortcut = New-Object -ComObject WScript.Shell
$ShortcutPath = [System.IO.Path]::Combine($DesktopPath, "Remote Desktop Connection.lnk")
$ShortcutFile = $Shortcut.CreateShortcut($ShortcutPath)
# Configurar propiedades del acceso directo
$ShortcutFile.TargetPath = "C:\Windows\System32\mstsc.exe" # Ruta al ejecutable de Remote Desktop
$ShortcutFile.WorkingDirectory = "C:\Windows\System32"
$ShortcutFile.WindowStyle = 1  # 1 para ventana normal
$ShortcutFile.Description = "Remote Desktop Connection"
$ShortcutFile.Save()
