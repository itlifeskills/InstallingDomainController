$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$Name = "AutoAdminLogon"
$User = "DefaultUserName"
$value = "0"
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Force | Out-Null
Remove-ItemProperty -Path $registryPath -Name $User


