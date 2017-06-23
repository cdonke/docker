Write-Host "Default Port= $env:PORT"

Import-module IISAdministration; 
New-IISSite -Name Site -PhysicalPath "C:\\site" -BindingInformation "*:$($env:PORT):"
Start-Process "C:\\ServiceMonitor.exe" -ArgumentList "w3svc" -Wait