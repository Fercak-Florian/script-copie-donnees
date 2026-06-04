$printerDriverLocation = "\\srv-imp.si.francetelecom.fr\IMP_LEXMARK"

# Installation des pilotes de l'imprimante
Add-Printer -ConnectionName $printerDriverLocation

# Recuperation de l'imprimante 
$printerInstalled = Get-CimInstance -ClassName Win32_Printer |
    Where-Object Name -eq $printerDriverLocation

if ($printerInstalled) {
    $result = Invoke-CimMethod -InputObject $printerInstalled -MethodName SetDefaultPrinter
    if ($result.ReturnValue -eq 0) {
        Write-Host "Imprimante Lexmark definie par defaut avec succes." -ForegroundColor Green
    } else {
        Write-Host "Echec de la definition de l'imprimante par defaut. Code : $($result.ReturnValue)" -ForegroundColor Red
    }
}