function TakeDisk {
    param (
        [string]$server
    )
    $disks = Get-WMIObject Win32_LogicalDisk -ComputerName $server -filter "DriveType=3 `
        and DeviceID!='H:' `
        and DeviceID!='L:' `
        and DeviceID!='T:' `
        and DeviceID!='C:' `
        and VolumeName!='Staging'" | Select-Object DeviceID
    return $disks

}