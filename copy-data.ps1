# Récupération et affectation des arguments passés en ligne de commande
param(
    [Parameter(Position = 0)]
    [string]$disqueSource,
    [Parameter(Position = 1)]
    [string]$disqueDestination,
    [Parameter(Position = 2)]
    [string]$cuid
)

Remove-Module *
Import-Module "$PSScriptRoot\Test-PathExists.psm1"
Import-Module "$PSScriptRoot\DisplayUser.psm1"
# Import-Module "$PSScriptRoot\Check-InputParameters.psm1"
Import-Module "$PSScriptRoot\ConvertTo-DriveRoot.psm1"


$robocopyOptions = @(
    # '/e',
    '/copyall',
    '/w:3',
    '/r:3',
    '/mt:16'
)

function Copy-User-Data {
    param (
        [Parameter(Position = 0)]
        [string]$disqueSource,
        [Parameter(Position = 1)]
        [string]$disqueDestination,
        [Parameter(Position = 2)]
        [string]$cuid
    )
    Write-Host "---- Debut de la copie des donnees Utilisateur ----" -ForegroundColor green
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
}

function Copy-App-Data {
    param (
        [Parameter(Position = 0)]
        [string]$disqueSource,
        [Parameter(Position = 1)]
        [string]$disqueDestination,
        [Parameter(Position = 2)]
        [string]$cuid
    )
    Write-Host "---- Debut de la copie des donnees des applications ----" -ForegroundColor Yellow

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

    foreach ($element in $data) {
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
    Write-Host "---- Fin de la copie des donnees des applications ----" -ForegroundColor green
}

# Etape 1 : Vérifier les paramètres entrants
if ([string]::IsNullOrEmpty($disqueSource) -or [string]::IsNullOrEmpty($disqueDestination) -or [string]::IsNullOrEmpty($cuid)) {
    DisplayUserHelp
}

# Etape 2 : Convertir les lettre du lecteur en chemin d'acces
$sourceDisk = ConvertTo-DriveRoot $disqueSource
$targetDisk = ConvertTo-DriveRoot $disqueDestination

# Etape 3 : Tester que les chemins source et destination sont accessibles
if ((Test-PathExists $sourceDisk) -and (Test-PathExists $targetDisk)) {
    # Etape 4 : Alerter avant la copie
    DisplayUserAlert $sourceDisk $targetDisk $cuid
    
    # Etape 5 : Lancer la copie
    Write-Host "---- Copie de C:\Applications et C:\My Program Files ----"
    robocopy "${sourceDisk}Applications" "${targetDisk}Applications" @robocopyOptions
    robocopy "${sourceDisk}My Program Files" "${targetDisk}My Program Files" @robocopyOptions

    Copy-User-Data $sourceDisk $targetDisk $cuid
    Copy-App-Data $sourceDisk $targetDisk $cuid

    Write-Host "La copie des donnees est terminee" -ForegroundColor Green
}
else {
    Write-Host "something goes wrong"
}

function main {
    # Etape 1 : Vérifier les paramètres entrants
    # Etape 2 : Convertir les lettre du lecteur en chemin d'acces
    # Etape 3 : Tester que les chemins source et destination sont accessibles
    # Etape 4 : Alerter avant la copie
    # Etape 5 : Lancer la copie
}