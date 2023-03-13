$serverName = (Get-ComputerInfo | Select CsDNSHostName).CsDNSHostName


if ($serverName -ne "CHIPVDC01"){
    Rename-Computer -NewName "CHIPVDC01“ -Restart 
} 
