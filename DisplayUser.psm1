# Affiche une aide à l'utilisateur #
function DisplayUserHelp {
    Write-Host "--------------------------------------------------------------------------" 
    Write-Host "-------------------------- Aide sur la commande --------------------------" 
    Write-Host "Une erreur est survenue lors du lancement de la commande." -ForegroundColor Blue
    Write-Host "Veuillez resaisir la commande avec les bons parametres."
    Write-Host "Par exemple copy-data.ps1 <disque source> <disque destination> <cuid>"
    Write-Host "Exemple : .\copy-data.ps1 D C ABCD1234" -ForegroundColor Green
    Write-Host "--------------------------------------------------------------------------" 
    Exit
}

# Affiche un message récapitulatif à l'utilisateur #
function DisplayUserAlert {
    param (
        [string] $disqueSource,
        [string] $disqueDestination,
        [string] $cuid
    )
    # Clear-Host
    Write-Host "ATTENTION !!" -ForegroundColor yellow
    Write-Host "Vous etes sur le point de lancer la copie des donnees du disque " -NoNewline
    Write-Host $disqueSource -ForegroundColor green -NoNewline
    Write-Host " vers le disque " -NoNewline
    Write-Host $disqueDestination -ForegroundColor green -NoNewline
    Write-Host " pour l'utilisateur " -NoNewline
    Write-Host $cuid -ForegroundColor green
    Read-Host "Pour continuer appuyer sur Entree"
}

Export-ModuleMember -Function DisplayUserHelp, DisplayUserAlert