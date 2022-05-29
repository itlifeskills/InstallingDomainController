#Get-ComputerInfo

$mycomputer = Get-ComputerInfo | select CsName, CsNumberOfProcessors, CsNumberOfLogicalProcessors, CsProcessors, OsVersion, OsTotalVisibleMemorySize, OsPagingFiles, OsSizeStoredInPagingFiles,OsFreeSpaceInPagingFiles

if ($mycomputer.CsDNSHostName -ne "Server044"){

    Rename-Computer -NewName "Server044" -DomainCredential Domain01\Admin01 -Restart

}

#Disable IPv6

Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object {$_.Enabled -eq $true} | Disable-NetAdapterBinding  -ComponentID ms_tcpip6

#Set IPv4

Get-NetIPAddress | Where-Object {$_.InterfaceIndex -eq 9}

New-NetIPAddress –InterfaceAlias “Wired Ethernet Connection” –IPv4Address “192.168.0.1” –PrefixLength 24 -DefaultGateway 192.168.0.254
Set-DnsClientServerAddress -InterfaceAlias “Wired Ethernet Connection” -ServerAddresses 192.168.0.1, 192.168.0.2


#---------Setting PageFile: https://www.tutorialspoint.com/how-to-change-pagefile-settings-using-powershell---------------------
#Get the installed RAM size
$physicalmem=get-wmiobject  Win32_ComputerSystem | % {$_.TotalPhysicalMemory}

#Get the RAM size in MB
$ramsize=[math]::Round($physicalmem / 1048576)

$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges

if ($pagefile.AutomaticManagedPagefile -eq $true){
    $pagefile.AutomaticManagedPagefile = $false
    $pagefile.put() | Out-Null
}

$pagefilesize= 1.5*$ramsize

$pagefileset = Get-WmiObject Win32_pagefilesetting
$pagefileset.InitialSize = $pagefilesize
$pagefileset.MaximumSize = $pagefilesize
$pagefileset.Put() | Out-Null

Gwmi win32_Pagefilesetting | Select Name, InitialSize, MaximumSize




