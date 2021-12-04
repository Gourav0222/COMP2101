get-ciminstance win32_networkadapterconfiguration | Where-Object { $_.ipenabled -eq 'True' } | 
Format-Table index, ipaddress, Description, subnet, dnsdomain, dnsserversearchorder