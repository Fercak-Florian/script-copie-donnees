# Récupération et affectation des arguments passés en ligne de commande
param(
    [Parameter(Position=0)]
    [string]$disqueSource,
    [Parameter(Position=1)]
    [string]$disqueDestination,
    [Parameter(Position=2)]
    [string]$cuid
)

# ---------- TO DO ----------
# Afficher une aide s'il manque un des paramètres #
if([string]::IsNullOrEmpty($disqueSource) -or [string]::IsNullOrEmpty($disqueDestination) -or [string]::IsNullOrEmpty($cuid)) {
    # Affichage de l'aide
    Write-Host "" 
    Write-Host "----------------------- Aide sur la commande -----------------------------" 
    Write-Host "Une erreur est survenue lors du lancement de la commande." -ForegroundColor Blue
    Write-Host "Veuillez resaisir la commande avec les bon parametres."
    Write-Host "Par exemple copy-data.ps1 <disque source> <disque destination> <cuid>"
    Write-Host "Exemple .\copy-data.ps1 D C ABCD1234" -ForegroundColor Green
    Write-Host "" 

    Exit
}

$robocopyOptions = @(
    # '/e',
    '/copyall',
    '/w:3',
    '/r:3',
    '/mt:16'
    )

$disqueSource = "$disqueSource`:\"
$disqueDestination = "$disqueDestination`:\"

Clear-Host
Write-Host "ATTENTION !!" -ForegroundColor yellow
Write-Host "Vous etes sur le point de lancer la copie des donnees du disque " -NoNewline
Write-Host $disqueSource -ForegroundColor green -NoNewline
Write-Host " vers le disque " -NoNewline
Write-Host $disqueDestination -ForegroundColor green -NoNewline
Write-Host " pour l'utilisateur " -NoNewline
Write-Host $cuid -ForegroundColor green
Read-Host "Pour continuer appuyer sur Entree"

# ---------- TO DO ----------
# Réfléchir à l'utilisation de la fonction Read-ValidPath

# Write-Host "ETAPE 1 : Choix du disque source"
# $disqueSource = Read-ValidPath

# Write-Host "ETAPE 2 : Choix du disque de destination"
# $disqueDestination = Read-ValidPath

# Write-Host "ETAPE 3 : Saisi du CUID utilisateur"
# $cuid = Read-Host "Veuillez saisir le CUID en majuscule, par exemple ABCD1234"
# Write-Host CUID saisi : $cuid

# Write-Host "Vous etes sur le point de lancer la copie des donnees" 
# Read-Host "Appuyer sur un touche pour continuer"

Write-Host "---- Copie de C:\Applications et C:\My Program Files ----"
robocopy "${disqueSource}Applications" "${disqueDestination}Applications" @robocopyOptions
robocopy "${disqueSource}My Program Files" "${disqueDestination}My Program Files" @robocopyOptions

Write-Host "---- Copie des donnees Utilisateur ----"
Get-ChildItem -Path ${disqueSource}Users\${cuid} | Where-Object {
    $_.Name -notin @("!!!SvgClesZC!!!", "AppData", "Documents", "outlook") -and
    $_.Name -notlike "OneDrive*"
    } | ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\$_"
    $destination = "${disqueDestination}Users\${cuid}\$_"
    robocopy $source $destination @robocopyOptions
}

Write-Host "---- Copie du repertoire Outlook presentes dans CUID\Documents\Outlook ----"
Get-ChildItem -Path "${disqueSource}Users\${cuid}\Documents\Outlook" |
    Where-Object {
        $_.Name -notlike "*.com.ost" -and $_.Name -notlike "*.ost"
    } | ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\Documents\Outlook"
    $destination = "${disqueDestination}Users\${cuid}\Outlook"
    robocopy $source $destination $_.Name
}

Write-Host "---- Copie du repertoire Outlook presentes dans CUID\Outlook ----"
Get-ChildItem -Path "${disqueSource}Users\${cuid}\Outlook" |
    Where-Object {
        $_.Name -notlike "*.com.ost" -and $_.Name -notlike "*.ost"
    } | ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\Outlook"
    $destination = "${disqueDestination}Users\${cuid}\Outlook"
    robocopy $source $destination $_.Name
}

Write-Host "---- Copie du repertoire Documents ----"
$source = "${disqueSource}Users\${cuid}\Documents"
$destination = "${disqueDestination}Users\${cuid}\Documents"
robocopy $source $destination /xd Outlook @robocopyOptions

Write-Host "---- Fin de Copie des donnees Utilisateur ----" -ForegroundColor green

Write-Host "---- Copie des donnees dans AppData\Roaming\Microsoft ----"
$data = @(
    'Excel',
    'Internet Explorer',
    'OneNote',
    'Outlook',
    'Signatures',
    'Teams',
    'Templates',
    'Word')

foreach ($element in $data)
{
    $source = "${disqueSource}Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
    $destination = "${disqueDestination}Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
    robocopy $source $destination @robocopyOptions
}

Write-Host "---- Copie des donnees en cache dans AppData\Roaming ----" 
$source = "${disqueSource}Users\${cuid}\AppData\Roaming"
$destination = "${disqueDestination}Users\${cuid}\AppData\Roaming"
robocopy $source $destination @robocopyOptions `
/xd com.adobe.dunamis connecteddevicesplatform ICAClient Microsoft packages "PRIM'X" vlc Xerox ZoneCentral

Write-Host "---- Copie de StickyNotes et PowerBI ----"
$apps = @("*StickyNotes*", "*PowerBI*")

Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Packages" -Directory |
Where-Object {
    $name = $_.Name
    $apps | Where-Object { $name -like $_ }
} |
ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\AppData\Local\Packages\$($PSItem)"
    $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Packages\$($PSItem)"
    robocopy $source $destination @robocopyOptions
}

# Dans AppData\Local\Microsoft copie de tous les repertoires Edge, IE, OneNote, Outlook, Teams

Write-Host "---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Edge ----"
Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Edge*" | ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
    $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
    robocopy $source $destination @robocopyOptions
}

Write-Host "---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Internet Explorer ----"
Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Internet Explorer" |
ForEach-Object {
    $source = $_.FullName
    $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($_.Name)"
    robocopy $source $destination @robocopyOptions
}

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\OneNote ----"
robocopy "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\OneNote" "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\OneNote" @robocopyOptions
robocopy "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\Outlook" "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\Outlook" @robocopyOptions

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\Teams ----"
Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Teams*" | ForEach-Object {
    $source = "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
    $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
    robocopy $source $destination @robocopyOptions
}

Write-Host "La copie des donnees est terminee" -ForegroundColor Green