function CreateFolderSetNTFSrule {
    param (
        [string]$RemoteComputer,
        [string]$PreloadFolder,
        [string]$DiskName,
        [string]$MyFolder,
        [string]$ModuleName = "NTFSSecurity"
    )

    $ShareModulePath = "\\WIN1\Share\NTFSSecurity"
    $RemoteModulePath = "\\$RemoteComputer\C$\Program Files\WindowsPowerShell\Modules\$ModuleName"
    $LocalModulePath = "\\$RemoteComputer\C$\Program Files\WindowsPowerShell\Modules\"

    if (-not (Test-Path $RemoteModulePath)) {
        Write-Host "No Module. Module copy has been started"
        Copy-Item -Path $ShareModulePath -Destination $LocalModulePath -Recurse -Force
    }

    Invoke-Command -ComputerName $RemoteComputer -ScriptBlock {
        param (
            [string]$RemotePreloadFolder,
            [string]$RemoteDiskName,
            [string]$RemoteMyFolder,
            [string]$RemoteRemoteComputer
        )
        Import-Module -Name "NTFSSecurity"
        $RemotePathShort = $RemoteDiskName + "\" + $RemotePreloadFolder
        if(-not(Test-Path $RemotePathShort)){
            New-Item -ItemType Directory -Path $RemotePathShort -Force
            Disable-NTFSAccessInheritance -Path $RemotePathShort
            $ShortRights = Get-NTFSAccess -Path $RemotePathShort

            foreach ($ShortRight in $ShortRights){
                if($ShortRight.Account -ne "BUILTIN\Administrators"){
                    if($ShortRight.Account -eq "BUILTIN\Users"){
                        
                        Remove-NTFSAccess -Path $RemotePathShort -Account "BUILTIN\Users" -AccessRights $ShortRight.AccessRights;
                        Add-NTFSAccess -Path $RemotePathShort -Account "BUILTIN\Users" -AppliesTo "ThisFolderSubfoldersAndFiles" -AccessRights "ReadAndExecute, Synchronize"
                    }
                    Else {
                        Remove-NTFSAccess -Path $RemotePathShort -Account $ShortRight.Account -AccessRights $ShortRight.AccessRights;
                    }
                }
            }
        }
        $RemotePath = $RemoteDiskName + "\" + $RemotePreloadFolder + "\" + $RemoteMyFolder
        if(-not(Test-Path $RemotePath)){
            New-Item -ItemType Directory -Path $RemotePath -Force
            Disable-NTFSAccessInheritance -Path $RemotePath
            $Rights = Get-NTFSAccess -Path $RemotePath


            foreach ($Right in $Rights){
                if($Right.Account -ne "BUILTIN\Administrators"){
                    # Write-Host $Right.Account
                    # Write-Host $Right.AccessRights
                    Remove-NTFSAccess -Path $RemotePath -Account $Right.Account -AccessRights $Right.AccessRights;
                }
            }

            Add-NTFSAccess -Path $RemotePath -Account "BUILTIN\Users" -AppliesTo "ThisFolderOnly" -AccessRights "ReadAndExecute, Synchronize"
        }
    
    } -ArgumentList @($PreloadFolder,$DiskName,$MyFolder,$RemoteComputer)

}
