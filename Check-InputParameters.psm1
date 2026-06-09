Remove-Module *
Import-Module -Name .\DisplayUser.psm1

function Check-InputParameters {
    param (
        [string] $sourceLetter,
        [string] $targetLetter,
        [string] $cuid
    )
    
    if ([string]::IsNullOrEmpty($sourceLetter) -or [string]::IsNullOrEmpty($targetLetter) -or [string]::IsNullOrEmpty($cuid)) {
        DisplayUserHelp
    }
}
Export-ModuleMember -Function Check-InputParameters