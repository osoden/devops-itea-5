Write-Host "Enabling pagefile..."
$cs = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$cs.AutomaticManagedPagefile = $true
$cs.Put()
