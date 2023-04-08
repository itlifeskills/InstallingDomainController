#Get all network adapter bindings enabled with IPv6 then disable them

Get-NetAdapterBinding -ComponentID ms_tcpip6 | Select Enabled
Where-Object {$_.Enabled -eq $true} | 
Disable-NetAdapterBinding  -ComponentID ms_tcpip6
