Add-Type -AssemblyName System.Windows.Forms
Import-Module .\TakeDisk.psm1
Import-Module .\CreateFolderSetNTFSrule.psm1
Import-Module .\PublishSharedFolder.psm1

$form = New-Object System.Windows.Forms.Form
$form.Text = "REmoTe folder creAtoR aDm"
$form.Size = New-Object System.Drawing.Size(400, 450)

$labelServer = New-Object System.Windows.Forms.Label
$labelServer.Text = "Server Name:"
$labelServer.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($labelServer)

$textBoxServer = New-Object System.Windows.Forms.TextBox
$textBoxServer.Location = New-Object System.Drawing.Point(150, 15)
$form.Controls.Add($textBoxServer)

$buttonGetDisks = New-Object System.Windows.Forms.Button
$buttonGetDisks.Text = "Get Disk"
$buttonGetDisks.Location = New-Object System.Drawing.Point(280, 15)
$buttonGetDisks.Add_Click({

    $comboBoxDisks.Items.Clear()
    $disks = TakeDisk -server $textBoxServer.Text
    foreach ($disk in $disks) {
        $comboBoxDisks.Items.Add($disk.DeviceID)
    }
    $richTextBox.AppendText("Take info about disko on..." + $textBoxServer.Text + "`r`n" + "`r`n")
})
$form.Controls.Add($buttonGetDisks)

$labelDisks = New-Object System.Windows.Forms.Label
$labelDisks.Text = "Choose disk:"
$labelDisks.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($labelDisks)

$comboBoxDisks = New-Object System.Windows.Forms.ComboBox
$comboBoxDisks.Location = New-Object System.Drawing.Point(150, 55)
$form.Controls.Add($comboBoxDisks)

$labelFolderType = New-Object System.Windows.Forms.Label
$labelFolderType.Text = "Folder type:"
$labelFolderType.Location = New-Object System.Drawing.Point(10, 100)
$form.Controls.Add($labelFolderType)

$comboBoxFolderType = New-Object System.Windows.Forms.ComboBox
$comboBoxFolderType.Location = New-Object System.Drawing.Point(150, 95)

$comboBoxFolderType.Items.Add("UserData")
$comboBoxFolderType.Items.Add("UserData02")
$comboBoxFolderType.Items.Add("UserData03")
$comboBoxFolderType.Items.Add("UserData04")
$comboBoxFolderType.Items.Add("SharedData")
$comboBoxFolderType.Items.Add("SharedData02")
$comboBoxFolderType.Items.Add("SharedData03")
$comboBoxFolderType.Items.Add("SharedData04")

$comboBoxFolderType.SelectedIndex = 0
$form.Controls.Add($comboBoxFolderType)

$labelFolderName = New-Object System.Windows.Forms.Label
$labelFolderName.Text = "Name folder:"
$labelFolderName.Location = New-Object System.Drawing.Point(10, 140)
$form.Controls.Add($labelFolderName)

$textBoxFolderName = New-Object System.Windows.Forms.TextBox
$textBoxFolderName.Location = New-Object System.Drawing.Point(150, 135)
$form.Controls.Add($textBoxFolderName)

$buttonCreateFolder = New-Object System.Windows.Forms.Button
$buttonCreateFolder.Text = "Create folder"
$buttonCreateFolder.Location = New-Object System.Drawing.Point(150, 180)
$buttonCreateFolder.Add_Click({

    CreateFolderSetNTFSrule -RemoteComputer $textBoxServer.Text -PreloadFolder $comboBoxFolderType.Text -DiskName $comboBoxDisks.Text -MyFolder $textBoxFolderName.Text
    $richTextBox.AppendText("Folder on server: " + $textBoxServer.Text + " was created!" +  "`r`n" + "Path on server: " + $comboBoxDisks.Text +"\" + $comboBoxFolderType.Text + "\" + $textBoxFolderName.Text + "`r`n" + "`r`n")
})
$form.Controls.Add($buttonCreateFolder)

$buttonPublishFolder = New-Object System.Windows.Forms.Button
$buttonPublishFolder.Text = "Publish folder"
$buttonPublishFolder.Location = New-Object System.Drawing.Point(150, 210)
$buttonPublishFolder.Add_Click({

    PublishSharedFolder -ServerName $textBoxServer.Text -DiskName $comboBoxDisks.Text -ShareName $comboBoxFolderType.Text
    $richTextBox.AppendText("Folder on server: " + $textBoxServer.Text + " was published!" +  "`r`n" + "SharePath: \\" + $textBoxServer.Text +"\" + $comboBoxFolderType.Text + "`r`n" + "`r`n")
})
$form.Controls.Add($buttonPublishFolder)

$richTextBox = New-Object System.Windows.Forms.RichTextBox
$richTextBox.Location = New-Object System.Drawing.Point(10, 270)
$richTextBox.Size = New-Object System.Drawing.Size(360, 130)
$richTextBox.ReadOnly = $true
$form.Controls.Add($richTextBox)


$form.ShowDialog()
