# Récupération et affectation des arguments passés en ligne de commande
param(
    [string]$disqueSource,
    [string]$disqueDestination
)

Write-Host $disqueSource
Write-Host $disqueDestination

$test = "test-34"

############################## TEST MODE ##############################
$testMode =  $true
############################## TEST MODE ##############################

$robocopyOptions = @(
    '/e',
    '/copyall',
    '/w:3',
    '/r:3',
    '/mt:16'
    )

Clear-Host
$disqueSource = Read-Host "Veuillez saisir la lettre du disque source en majuscule"
Write-Host Disque source choisi : $disqueSource
$disqueDestination = Read-Host "Veuillez saisir la lettre du disque de destination en majuscule"
Write-Host Disque source choisi : $disqueDestination
$cuid = Read-Host "Veuillez saisir le CUID en majuscule"
Write-Host CUID choisi : $cuid
Read-Host "Appuyer sur un touche pour continuer"

# Write-Host ---- Copie de C:\Applications et C:\My Program Files ----


Write-Host "---- Copie des donnees Utilisateur ----"

Write-Host ---- Copie des donnees utilisateurs .git .vscode .symfony ----
Get-ChildItem "${disqueSource}:\Users\${cuid}\" -Directory -Filter ".*" -Force | ForEach-Object {
    if ($testMode) {
        robocopy "${disqueSource}:\Users\EFFI8230\$($PSItem)" "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\$($PSItem)" @robocopyOptions
        # Read-Host "Appuyer sur un touche pour continuer"
    } else {
        robocopy "${disqueSource}:\Users\${cuid}\$($PSItem)" "${disqueDestination}:\Users\${cuid}\$($PSItem)" @robocopyOptions
    }
}

$donneesUtilisateurs = @(
    'Videos',
    'Downloads',
    'Searches',
    'Saved Games',
    'outlook',
    'Music',
    'Links',
    'Fichiers en local',
    'Favorites',
    'Contacts'
    )

foreach ($element in $donneesUtilisateurs)
{
    if ($testMode) {
        Write-Host $element
        $source = "${disqueSource}:\Users\EFFI8230\$($element)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\$($element)"
        robocopy $source $destination @robocopyOptions
    } else {
        Write-Host $element
        $source = "${disqueSource}:\Users\${cuid}\$($element)"
        $destination = "${disqueDestination}:\Users\${cuid}\$($element)"
        robocopy $source $destination @robocopyOptions
    }
}

# Copie des archives Outlook .pst .ost
if ($testMode) {
    $source = "${disqueSource}:\Users\EFFI8230\Documents\Outlook"
    $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\Outlook"
    robocopy $source $destination @robocopyOptions
} else {
    $source = "${disqueSource}:\Users\${cuid}\Documents\Outlook"
    $destination = "${disqueDestination}:\Users\${cuid}\outlook"
    robocopy $source $destination @robocopyOptions
}
# Copie de Documents 
if ($testMode) {
    $source = "${disqueSource}:\Users\EFFI8230\Documents"
    $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\Documents"
    robocopy $source $destination /xd Outlook @robocopyOptions
} else {
    $source = "${disqueSource}:\Users\${cuid}\Documents"
    $destination = "${disqueDestination}:\Users\${cuid}\Documents"
    robocopy $source $destination /xd Outlook @robocopyOptions
}


Write-Host ---- Fin de Copie des donnees Utilisateur ----


Write-Host ---- Copie des donnees Microsoft en cache dans AppData\Roaming ----
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
    if ($testMode) {
        Write-Host $element
        $source = "${disqueSource}:\Users\EFFI8230\AppData\Roaming\Microsoft\$($element)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\\AppData\Roaming\Microsoft\$($element)"
        robocopy $source $destination @robocopyOptions
    } else {
        $source = "${disqueSource}:\Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
        $destination = "${disqueDestination}:\Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host ---- Copie des donnees en cache dans AppData\Roaming ---- 
if ($testMode) {
    $source = "${disqueSource}:\Users\EFFI8230\AppData\Roaming"
    $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Roaming"
    robocopy $source $destination @robocopyOptions `
    /xd com.adobe.dunamis connecteddevicesplatform ICAClient Microsoft packages "PRIM'X" vlc Xerox ZoneCentral
} else {
    $source = "${disqueSource}:\Users\${cuid}\AppData\Roaming"
    $destination = "${disqueDestination}:\Users\${cuid}\AppData\Roaming"
    robocopy $source $destination @robocopyOptions `
    /xd com.adobe.dunamis connecteddevicesplatform ICAClient Microsoft packages "PRIM'X" vlc Xerox ZoneCentral
}



Write-Host StickyNotes a affiner - nom du repertoire doit contenir StickyNotes
Get-ChildItem "C:\Users\EFFI8230\AppData\Local\Packages" -Directory |
Where-Object { $_.Name -like "*StickyNotes*" } |
ForEach-Object {

    Write-Host "Trouvé :" $PSItem
    Read-Host "Appuyez sur Entrée pour continuer"

    if ($testMode) {
        $source = "${disqueSource}:\Users\EFFI8230\AppData\Local\Packages\$($PSItem)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Local\Packages\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
    else {
        $source = "${disqueSource}:\Users\${cuid}\AppData\Local\Packages\$($PSItem)"
        $destination = "${disqueDestination}:\Users\${cuid}\AppData\Local\Packages\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}

# Dans AppData\Local\Microsoft prendre tous les Edge, IE, OneNote, Outlook, tous les Teams

Write-Host ---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Edge ----
if ($testMode) {
        Get-ChildItem "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Edge*" | ForEach-Object {
        $source = "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
} else {
    Get-ChildItem "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Edge*" | ForEach-Object {
        $source = "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host ---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Internet Explorer ----
if ($testMode) {
    Get-ChildItem "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Internet Explorer" | ForEach-Object {
        $source = "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    } else {
        Get-ChildItem "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Internet Explorer" | ForEach-Object {
            $source = "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
            $destination = "${disqueDestination}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
            robocopy $source $destination @robocopyOptions
        }
    }
}

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\OneNote ----"
if ($testMode) {
    robocopy "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft\OneNote" "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Local\Microsoft\OneNote" @robocopyOptions
    robocopy "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft\Outlook" "${disqueDestination}:\Users\EFFI8230\AppData\Local\Microsoft\Outlook" @robocopyOptions
} else {
    robocopy "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft\OneNote" "${disqueDestination}:\Users\${cuid}\AppData\Local\Microsoft\OneNote" @robocopyOptions
    robocopy "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft\Outlook" "${disqueDestination}:\Users\${cuid}\AppData\Local\Microsoft\Outlook" @robocopyOptions
}

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\Teams ----"
if ($testMode) {
        Get-ChildItem "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Teams*" | ForEach-Object {
        $source = "${disqueSource}:\Users\EFFI8230\AppData\Local\Microsoft\$($PSItem.Name)"
        $destination = "${disqueDestination}:\test-robocopy\destination\${test}\EFFI8230\AppData\Local\Microsoft\$($PSItem.Name)"
        robocopy $source $destination @robocopyOptions 
    }
    } else {
    Get-ChildItem "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Teams*" | ForEach-Object {
        $source = "${disqueSource}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}:\Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}
