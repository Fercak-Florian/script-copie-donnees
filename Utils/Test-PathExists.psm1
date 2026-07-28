function Test-PathExists {
    param (
        [string] $path
    )
    try {
        $exist = Test-Path $path
        return $exist
    }
    catch {
        return $false
    }
}

function Test-SourceAndTargetPath {
    param(
        [string] $sourceDisk,
        [string] $targetDisk
    ) 
    if ((Test-PathExists $sourceDisk) -and (Test-PathExists $targetDisk)) {
        Write-Host "Les disques ${sourceDisk} et ${targetDisk} sont accessibles"
    } else {
        Write-Host "Disque(s) inaccessible(s)"
        Exit
    }
}
Export-ModuleMember -Function *