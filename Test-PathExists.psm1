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
Export-ModuleMember -Function Test-PathExists