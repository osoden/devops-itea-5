Write-Host "Installing .Net 3.5..."
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\Sources\sxs /Quiet

Write-Host "Installing Telnet client..."
Install-WindowsFeature -Name telnet-client

Write-Host "Uninstalling Windows Defender for Windows 2016..."
$OSVersion = (([environment]::OSVersion.Version).Major)
$DefenderStatus = ((Get-WindowsFeature -Name "Windows-Defender-Features").Installed)

if (($OSVersion -eq '10') -and ($DefenderStatus -eq 'True')) {
    Set-MpPreference -DisableRealtimeMonitoring $true
    Dism.exe /online /Disable-Feature /FeatureName:Windows-Defender /Remove /NoRestart /quiet
    exit 0
}
