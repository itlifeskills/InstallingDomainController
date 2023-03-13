#Get the installed RAM size
$physicalmem=get-wmiobject  Win32_ComputerSystem | % {$_.TotalPhysicalMemory}

#Get the RAM size in MB
$ramsize=[math]::Round($physicalmem / 1048576)

#Check if the page file is managed by the Operating System
$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges 

#if Yes, set it to Manual
if ($pagefile.AutomaticManagedPagefile -eq $true){
    $pagefile.AutomaticManagedPagefile = $false
    $pagefile.put() | Out-Null
}

#Delete the current pagefile
$pagefileset = Get-WmiObject Win32_pagefilesetting
$pagefileset.delete()

#Assign pagefilesize variable equal to 1.5 times of the installed memory size
$pagefilesize= 1.5*$ramsize

#Move the pagefile to D drive and set the intial and maximum to 1.5 times ramsize
Set-WMIInstance -Class Win32_PageFileSetting -Arguments @{name="P:\pagefile.sys";` 
            InitialSize = $pagefilesize; MaximumSize = $pagefilesize}


#Verify the pagefile settings
Gwmi win32_Pagefilesetting | Select Name, InitialSize, MaximumSize 



 

