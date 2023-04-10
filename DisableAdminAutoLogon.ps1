$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$Name = "AutoAdminLogon"
$DefaultPassword = "DisableAdminAutoLogon"
$value = "0"
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Force | Out-Null
Set-ItemProperty $RegPath "DefaultPassword" -Value $DefaultPassword -type String


