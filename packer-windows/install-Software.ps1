Write-Host "Installing choco..."
if ((Test-Path "$env:windir\explorer.exe") -ne 'True' ) {
    $env:chocolateyUseWindowsCompression = 'false'
}
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

Write-Host "Checking choco version..."
choco --version

Write-Host "Installing software with choco..."
choco install 7zip git googlechrome firefox notepadplusplus sourcetree powershell putty visualstudiocode winscp windirstat --confirm --allow-empty-checksums --execution-timeout=0
choco install classic-shell -installArgs ADDLOCAL=ClassicStartMenu --confirm --allow-empty-checksums
