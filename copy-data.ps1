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

# Remove-Module *
# Import-Module ./Read-ValidPath.psm1

Write-Host "DANS COPY.PS1" -ForegroundColor Green
Write-Host "valeur de disqueSource :" $disqueSource
Write-Host "valeur de disqueDestination :"$disqueDestination
Write-Host "valeur de cuid :"$cuid

$repertoireTest = "test-46"

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
if ($testMode) {
    # robocopy "${disqueSource}Applications" "${disqueDestination}test-robocopy\destination\${repertoireTest}\Applications" @robocopyOptions
    # robocopy "${disqueSource}My Program Files" "${disqueDestination}test-robocopy\destination\${repertoireTest}\My Program Files" @robocopyOptions
} else {
    robocopy "${disqueSource}Applications" "${disqueDestination}Applications" @robocopyOptions
    robocopy "${disqueSource}My Program Files" "${disqueDestination}My Program Files" @robocopyOptions
}

Write-Host "---- Copie des donnees Utilisateur ----"

if ($testMode) {
    # test mode
    Get-ChildItem -Path ${disqueSource}Users\${cuid} | Where-Object {
        $_.Name -notin @("!!!SvgClesZC!!!", "AppData", "Documents") -and
        $_.Name -notlike "OneDrive*"
    } | ForEach-Object {
        # Write-Host $_.Name
        $source = "${disqueSource}Users\${cuid}\$_"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\$_"
        robocopy $source $destination @robocopyOptions
    }
} else {
    # prod mode
    Get-ChildItem -Path ${disqueSource}Users\${cuid} | Where-Object {
        $_.Name -notin @("!!!SvgClesZC!!!", "AppData", "Documents") -and
        $_.Name -notlike "OneDrive*"
    } | ForEach-Object {
        # Write-Host $_.Name
        $source = "${disqueSource}Users\${cuid}\$_"
        $destination = "${disqueDestination}Users\${cuid}\$_"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host "---- Copie des archives Outlook presentes dans CUID\Documents\Outlook (.pst) ----"
if ($testMode) {
    Get-ChildItem -Path "${disqueSource}Users\${cuid}\Documents\Outlook" |
        Where-Object {
            $_.Extension -ne ".ost"
        } | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\Documents\Outlook"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\Outlook"
        robocopy $source $destination $_.Name @robocopyOptions
    }
} else {
        Get-ChildItem -Path "${disqueSource}Users\${cuid}\Documents\Outlook" |
        Where-Object {
            $_.Extension -ne ".ost"
        } | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\Documents\Outlook"
        $destination = "${disqueDestination}Users\${cuid}\Outlook"
        robocopy $source $destination $_.Name @robocopyOptions
    }
}

Write-Host "---- Copie des archives Outlook presentes dans CUID\Outlook (.pst) ----"
if ($testMode) {
    Get-ChildItem -Path "${disqueSource}Users\${cuid}\Outlook" |
        Where-Object {
            $_.Extension -ne ".ost"
        } | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\Outlook"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\Outlook"
        robocopy $source $destination $_.Name @robocopyOptions
    }
} else {
        Get-ChildItem -Path "${disqueSource}Users\${cuid}\Outlook" |
        Where-Object {
            $_.Extension -ne ".ost"
        } | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\Outlook"
        $destination = "${disqueDestination}Users\${cuid}\Outlook"
        robocopy $source $destination $_.Name @robocopyOptions
    }
}

Write-Host "---- Copie du repertoire Documents ----"
if ($testMode) {
    $source = "${disqueSource}Users\EFFI8230\Documents"
    $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\Documents"
    robocopy $source $destination /xd Outlook @robocopyOptions
} else {
    $source = "${disqueSource}Users\${cuid}\Documents"
    $destination = "${disqueDestination}Users\${cuid}\Documents"
    robocopy $source $destination /xd Outlook @robocopyOptions
}


Write-Host "---- Fin de Copie des donnees Utilisateur ----" -ForegroundColor green
if ($testMode) {
    Read-Host "Pour commencer la copie des donnees en cache appuyer sur Entree"
}

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
    if ($testMode) {
        Write-Host $element
        $source = "${disqueSource}Users\EFFI8230\AppData\Roaming\Microsoft\$($element)"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\\AppData\Roaming\Microsoft\$($element)"
        robocopy $source $destination @robocopyOptions
    } else {
        $source = "${disqueSource}Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
        $destination = "${disqueDestination}Users\${cuid}\AppData\Roaming\Microsoft\$($element)"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host "---- Copie des donnees en cache dans AppData\Roaming ----" 
if ($testMode) {
    $source = "${disqueSource}Users\EFFI8230\AppData\Roaming"
    $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Roaming"
    robocopy $source $destination @robocopyOptions `
    /xd com.adobe.dunamis connecteddevicesplatform ICAClient Microsoft packages "PRIM'X" vlc Xerox ZoneCentral
} else {
    $source = "${disqueSource}Users\${cuid}\AppData\Roaming"
    $destination = "${disqueDestination}Users\${cuid}\AppData\Roaming"
    robocopy $source $destination @robocopyOptions `
    /xd com.adobe.dunamis connecteddevicesplatform ICAClient Microsoft packages "PRIM'X" vlc Xerox ZoneCentral
}



Write-Host "---- Copie de StickyNotes et PowerBI ----"
$apps = @("*StickyNotes*", "*PowerBI*")

Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Packages" -Directory |
Where-Object {
    $name = $_.Name
    $apps | Where-Object { $name -like $_ }
} |
ForEach-Object {
    Write-Host "Trouvé :" $PSItem
    # Read-Host "Appuyez sur Entrée pour continuer"

    if ($testMode) {
        $source = "${disqueSource}Users\EFFI8230\AppData\Local\Packages\$($PSItem)"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Local\Packages\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
    else {
        $source = "${disqueSource}Users\${cuid}\AppData\Local\Packages\$($PSItem)"
        $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Packages\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}

# Dans AppData\Local\Microsoft copie de tous les repertoires Edge, IE, OneNote, Outlook, Teams

Write-Host "---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Edge ----"
if ($testMode) {
        Get-ChildItem "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Edge*" | ForEach-Object {
        $source = "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
} else {
    Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Edge*" | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host "---- Copie des donnees Microsoft en cache dans AppData\Local\Microsoft\Internet Explorer ----"

if ($testMode) {
    Get-ChildItem "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Internet Explorer" |
    ForEach-Object {
        $source = $_.FullName
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Local\Microsoft\$($_.Name)"
        robocopy $source $destination @robocopyOptions
    }

}
else {
    Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Internet Explorer" |
    ForEach-Object {
        $source = $_.FullName
        $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($_.Name)"
        robocopy $source $destination @robocopyOptions
    }
}

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\OneNote ----"
if ($testMode) {
    robocopy "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft\OneNote" "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Local\Microsoft\OneNote" @robocopyOptions
    robocopy "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft\Outlook" "${disqueDestination}Users\EFFI8230\AppData\Local\Microsoft\Outlook" @robocopyOptions
} else {
    robocopy "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\OneNote" "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\OneNote" @robocopyOptions
    robocopy "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\Outlook" "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\Outlook" @robocopyOptions
}

Write-Host "---- Copie des donnees Microsoft en cache dans .\AppData\Local\Microsoft\Teams ----"
if ($testMode) {
        Get-ChildItem "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft" -Directory -Filter "Teams*" | ForEach-Object {
        $source = "${disqueSource}Users\EFFI8230\AppData\Local\Microsoft\$($PSItem.Name)"
        $destination = "${disqueDestination}test-robocopy\destination\${repertoireTest}\EFFI8230\AppData\Local\Microsoft\$($PSItem.Name)"
        robocopy $source $destination @robocopyOptions 
    }
    } else {
    Get-ChildItem "${disqueSource}Users\${cuid}\AppData\Local\Microsoft" -Directory -Filter "Teams*" | ForEach-Object {
        $source = "${disqueSource}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        $destination = "${disqueDestination}Users\${cuid}\AppData\Local\Microsoft\$($PSItem)"
        robocopy $source $destination @robocopyOptions
    }
}