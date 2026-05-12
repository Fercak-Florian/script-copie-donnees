# # Appeler Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Formulaire - Création du canva
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Copie de donnees"
$Form.Width = 1000
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
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

# Afficher la GUI
$Form.ShowDialog()