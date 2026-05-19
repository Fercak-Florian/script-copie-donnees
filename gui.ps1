# Appeler Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Formulaire - Création du canva
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Copie de donnees"
$Form.Width = 800
$Form.Height = 200
$Form.AutoSize = $true

# Texte "Choisir le disque source"
$textDisqueSource = New-Object System.Windows.Forms.Label
$textDisqueSource.Text = "Choisir le disque source :"
$textDisqueSource.Location = New-Object System.Drawing.Point(10,10)
$textDisqueSource.AutoSize = $true
$textDisqueSource.Visible = $true
$Form.Controls.Add($textDisqueSource)

# Liste déroulante pour choisir le disque source
$ComboBoxDisqueSource = New-Object System.Windows.Forms.ComboBox
$ComboBoxDisqueSource.Width = 150
$ComboBoxDisqueSource.Visible = $true
$ComboBoxDisqueSource.Location  = New-Object System.Drawing.Point(10,30)
Get-Volume | Where-Object DriveLetter | ForEach-Object {
    [void]$ComboBoxDisqueSource.Items.Add($_.DriveLetter)
}
$Form.Controls.Add($ComboBoxDisqueSource)

# Texte "Choisir le disque de destination"
$textDisqueDestination = New-Object System.Windows.Forms.Label
$textDisqueDestination.Text = "Choisir le disque de destination :"
$textDisqueDestination.Location = New-Object System.Drawing.Point(300,10)
$textDisqueDestination.AutoSize = $true
$textDisqueDestination.Visible = $true
$Form.Controls.Add($textDisqueDestination)

# Liste déroulante pour choisir le disque de destination
$ComboBoxDisqueDestination = New-Object System.Windows.Forms.ComboBox
$ComboBoxDisqueDestination.Width = 150
$ComboBoxDisqueDestination.Visible = $true
$ComboBoxDisqueDestination.Location  = New-Object System.Drawing.Point(300,30)
Get-Volume | Where-Object DriveLetter | ForEach-Object {
    [void]$ComboBoxDisqueDestination.Items.Add($_.DriveLetter)
}
$Form.Controls.Add($ComboBoxDisqueDestination)

# Texte "Choisir le profil utilisateur (cuid)"
$textCuid = New-Object System.Windows.Forms.Label
$textCuid.Text = "Choisir le profil utilisateur (cuid) :"
$textCuid.Location = New-Object System.Drawing.Point(600,10)
$textCuid.AutoSize = $true
$textCuid.Visible = $true
$Form.Controls.Add($textCuid)

# Liste déroulante pour choisir le profil utilisateur (cuid)
$ComboBoxProfilUtilisateur = New-Object System.Windows.Forms.ComboBox
$ComboBoxProfilUtilisateur.Width = 150
$ComboBoxProfilUtilisateur.Visible = $true
$ComboBoxProfilUtilisateur.Location  = New-Object System.Drawing.Point(600,30)
Get-ChildItem -Path C:\Users | ForEach-Object {
    [void]$ComboBoxProfilUtilisateur.Items.Add($_.Name)
}
$Form.Controls.Add($ComboBoxProfilUtilisateur)

# Creation du boutton OK
$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Location = New-Object System.Drawing.Point(75,120)
$OkButton.Size = New-Object System.Drawing.Size(75,23)
$OkButton.Text = 'OK'
$OkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($OKButton)

# Creation du boutton Annuler
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(175,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Annuler'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.Controls.Add($CancelButton)

switch ($Form.ShowDialog()) {
    'OK'{ 
            Write-Host $ComboBoxDisqueSource.SelectedItem
            Write-Host $ComboBoxDisqueDestination.SelectedItem
            Write-Host $ComboBoxProfilUtilisateur.SelectedItem
            $script:disqueSource = $ComboBoxDisqueSource.SelectedItem
            $script:disqueDestination = $ComboBoxDisqueDestination.SelectedItem
            $script:cuid = $ComboBoxProfilUtilisateur.SelectedItem
        }
    'Cancel' { "Annuler clique" }
    'default' { "Autre action" }
}