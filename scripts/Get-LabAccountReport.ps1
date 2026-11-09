<#
.SYNOPSIS
    Daily account health report: locked-out, disabled and password-expired users.
.EXAMPLE
    .\Get-LabAccountReport.ps1
#>
Import-Module ActiveDirectory
$report = @()

Search-ADAccount -LockedOut -UsersOnly | ForEach-Object {
    $report += [pscustomobject]@{ Issue = "Locked out"; User = $_.SamAccountName }
}
Search-ADAccount -AccountDisabled -UsersOnly | ForEach-Object {
    $report += [pscustomobject]@{ Issue = "Disabled"; User = $_.SamAccountName }
}
Search-ADAccount -PasswordExpired -UsersOnly | ForEach-Object {
    $report += [pscustomobject]@{ Issue = "Password expired"; User = $_.SamAccountName }
}

$report | Sort-Object Issue | Format-Table -AutoSize
$report | Export-Csv ".\account-report-$(Get-Date -Format yyyy-MM-dd).csv" -NoTypeInformation
