# Disable UAC
Set-ItemProperty -Path "registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

# Enable WinRM in Firewall for any remote address
Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"
Get-NetFirewallRule -DisplayGroup "Windows Remote Management" | Get-NetFirewallAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress Any

# Set WinRM Config
winrm quickconfig -q

winrm set winrm/config '@{MaxTimeoutms="1800000"}'

winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/winrs '@{MaxShellsPerUser="30"}'
winrm set winrm/config/winrs '@{MaxConcurrentUsers="30"}'
winrm set winrm/config/winrs '@{MaxProcessesPerShell="30"}'

# Restart WinRM service
Stop-Service -Name "winrm"
Set-Service -Name "winrm" -StartupType "Automatic"
Start-Service -Name "winrm"
