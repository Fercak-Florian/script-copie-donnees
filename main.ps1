# Etape 1 : Lancement de la GUI
. "$PSScriptRoot\gui.ps1"
# Etape 2 : Fermeture de la GUI

# Etape 3 : Lancement de copy
& "$PSScriptRoot\copy-data.ps1" `
    -disqueSource $disqueSource `
    -disqueDestination $disqueDestination `
    -cuid $cuid