Import-Module "$PSScriptRoot\DisplayUser.psm1"

function Test-InputParameters {
    param (
        [string] $sourceLetter,
        [string] $targetLetter,
        [string] $cuid
    )
    if ([string]::IsNullOrEmpty($sourceLetter) -or [string]::IsNullOrEmpty($targetLetter) -or [string]::IsNullOrEmpty($cuid)) {
        DisplayUserHelp
    }
}
Export-ModuleMember -Function Test-InputParameters