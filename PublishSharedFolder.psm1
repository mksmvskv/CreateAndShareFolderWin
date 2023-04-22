function PublishSharedFolder {
    param (
        [string]$ServerName,
        [string]$DiskName,
        [string]$ShareName
    )
    Invoke-Command -ComputerName $ServerName -ScriptBlock {
        param (
            [string]$RemoteDiskName,
            [string]$RemoteShareName
        )
        $SharedFolderPath = $RemoteDiskName + "\" + $RemoteShareName
        New-SmbShare -Name $RemoteShareName -Path $SharedFolderPath -FullAccess "Everyone" -Confirm:$false
        Set-SmbShare -Name $RemoteShareName -FolderEnumerationMode AccessBased -CachingMode None -Confirm:$false
    } -ArgumentList @($DiskName,$ShareName)
    

}
