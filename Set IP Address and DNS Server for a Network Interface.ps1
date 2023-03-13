#Get the IP information and filter for the interfaces connected to the network
Get-NetIPAddress | 
Where-Object {$_.InterfaceAlias.StartsWith("Ethernet")}|
Select InterfaceAlias, IPAddress, PrefixLength, PrefixOrigin

$intefacealias = "Ethernet1"
#Set the IPv4 address and default gateway
New-NetIPAddress –InterfaceAlias $intefacealias –IPAddress “10.0.0.10"`
                 -PrefixLength "23" -DefaultGateway "10.0.0.2"

#Set DNS Server information
Set-DnsClientServerAddress -InterfaceAlias $intefacealias -ServerAddresses “10.0.0.10” 
