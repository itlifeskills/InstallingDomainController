$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$Name = "AutoAdminLogon"
$value = "0"
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Force | Out-Null

