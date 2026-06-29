function Test-CuidPresenceDirectory {
    param(
        [string] $cuid,
        [string] $disk 
    )
    $path = "${disk}Users\${cuid}"
    if (-not (Test-Path -Path $path)) {
        Write-Host "Le CUID ${cuid} est introuvable dans le disque ${disk}" -ForegroundColor DarkRed
        Exit
    }
    Read-Host "stop"
}
Export-ModuleMember -Function *