Write-Host "Disabling pagefile..."
$cs = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$cs.AutomaticManagedPagefile = $false
$cs.Put()

$pg = Get-WmiObject Win32_PagefileSetting -EnableAllPrivileges
$pg.Delete()
