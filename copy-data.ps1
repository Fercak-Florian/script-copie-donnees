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
Import-Module "$PSScriptRoot\Utils\Test-PathExists.psm1"
Import-Module "$PSScriptRoot\DisplayUser.psm1"
Import-Module "$PSScriptRoot\Utils\Test-InputParameters.psm1"
Import-Module "$PSScriptRoot\Utils\ConvertTo-DriveRoot.psm1"
Import-Module "$PSScriptRoot\Copy-UserData.psm1"
Import-Module "$PSScriptRoot\Copy-AppData.psm1"

$robocopyOptions = @(
    '/e',
    '/copyall',
    '/w:3',
    '/r:3',
    '/mt:16'
)

function main {
    param(
        [string] $sourceLetter,
        [string] $targetLetter,
        [string] $cuid,
        [array]  $robocopyOptions
    )
    # Read-Host "stop"
    # Etape 1 : Vérifier les paramètres entrants
    Test-InputParameters $disqueSource $disqueDestination $cuid
    # Etape 2 : Convertir les lettre du lecteur en chemin d'acces
    $sourceDisk = ConvertTo-DriveRoot $sourceLetter
    $targetDisk = ConvertTo-DriveRoot $targetLetter
    # Etape 3 : Tester que les chemins source et destination sont accessibles
    Test-SourceAndTargetPath $sourceDisk $targetDisk
    # Etape 4 : Alerter avant la copie
    DisplayUserAlert $sourceDisk $targetDisk $cuid
    # Etape 5 : Lancer la copie
    Write-Host "---- Copie de C:\Applications et C:\My Program Files ----"
    # robocopy "${sourceDisk}Applications" "${targetDisk}Applications" @robocopyOptions
    # robocopy "${sourceDisk}My Program Files" "${targetDisk}My Program Files" @robocopyOptions
    Copy-UserData $sourceDisk $targetDisk $cuid $robocopyOptions
    Copy-AppData $sourceDisk $targetDisk $cuid $robocopyOptions
    Write-Host "La copie des donnees est terminee" -ForegroundColor Green

    # Appel du script d'ajout de l'imprimante lexmark
    Write-Host "Pour installer l'imprimante Lexmark et l'ajouter par defaut appuyer sur une touche :" -ForegroundColor Yellow
    $location = Get-Location | Select-Object -expand Path
    Invoke-Expression "$location\add-lexmark-printer.ps1"
}

main $disqueSource $disqueDestination $cuid