function Copy-AppData {
    param (
        [Parameter(Position = 0)]
        [string]$disqueSource,
        [Parameter(Position = 1)]
        [string]$disqueDestination,
        [Parameter(Position = 2)]
        [string]$cuid,
        [Parameter(Position = 3)]
        [array]$robocopyOptions 
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
Export-ModuleMember -Function Copy-AppData