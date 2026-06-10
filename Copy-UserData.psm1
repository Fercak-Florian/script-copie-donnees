function Copy-UserData {
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
Export-ModuleMember -Function Copy-UserData