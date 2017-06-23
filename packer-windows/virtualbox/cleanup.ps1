Write-Host "Cleaning SxS dir..."
try {
    DISM /online /Cleanup-Image /StartComponentCleanup /ResetBase /Quiet
} catch {
    DISM /online /Cleanup-Image /StartComponentCleanup /ResetBase /Quiet
} finally {
    exit 0
}

Write-Host "Removing temporary data..."
$Acl = Get-Acl -Path "C:\Windows\WinSxS\ManifestCache"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($accessRule)
Set-Acl -Path "C:\Windows\WinSxS\ManifestCache" -AclObject $Acl

Remove-Item -Path "$env:windir\WinSxS\ManifestCache\*" -Recurse -Force
Remove-Item -Path "$env:localappdata\Nuget\Cache\*" -Recurse -Force
Remove-Item -Path "$env:localappdata\Temp\*" -Recurse -Force
Remove-Item -Path "$env:windir\Panther\*" -Recurse -Force
Remove-Item -Exclude "vmware-*" -Path "$env:windir\Temp\*" -Recurse -Force

# Don't execute inside VMware since vmware-vdiskmanager cares about it
if (((Get-WmiObject -Class Win32_ComputerSystem).Manufacturer) -like '*VMware*') {
    Write-Host "Skipping defragmentation for VMware..."
} else {
    Write-Host "Defragging disk C..."
    Optimize-Volume -DriveLetter C
}

# Forked from mwrock/packer-templates
Write-Host "0ing empty space..."
$FilePath="c:\zero.tmp"
$Volume = Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'"
$ArraySize= 64kb
$SpaceToLeave= $Volume.Size * 0.05
$FileSize= $Volume.FreeSpace - $SpacetoLeave
$ZeroArray= new-object byte[]($ArraySize)
 
$Stream= [io.File]::OpenWrite($FilePath)
try {
   $CurFileSize = 0
    while($CurFileSize -lt $FileSize) {
        $Stream.Write($ZeroArray,0, $ZeroArray.Length)
        $CurFileSize +=$ZeroArray.Length
    }
}
finally {
    if($Stream) {
        $Stream.Close()
    }
}
 
Del $FilePath
