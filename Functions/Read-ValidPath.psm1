Export-ModuleMember -Function Read-ValidPath
function Read-ValidPath {
    do {
        $path = Read-Host "Veuillez saisir la lettre du disque en majuscule, par exemple E"
        $exist = Test-Path -path $path
        if (-not $exist) {
            Write-Host "Erreur : le chemin '$path' est inaccessible. Veuillez reessayer." -ForegroundColor Red
        }
        
    } until ($exist<# Condition that stops the loop if it returns true #>)
    Write-Host "Chemin valide : $path" -ForegroundColor Green
    return $path
}