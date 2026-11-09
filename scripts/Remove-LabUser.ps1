<#
.SYNOPSIS
    Offboards a user: disables the account, removes group access, archives it.
.DESCRIPTION
    Disables the account, records and removes every group membership, stamps the
    description with the date and ticket number, and moves the account to the
    Disabled Users OU. Accounts are disabled rather than deleted so they can be
    restored and audited.
.EXAMPLE
    .\Remove-LabUser.ps1 -SamAccountName dclark -Ticket 104 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$SamAccountName,
    [string]$Ticket = "none",
    [string]$LogPath = ".\offboarding-log.csv"
)

Import-Module ActiveDirectory
$domainDN   = (Get-ADDomain).DistinguishedName
$disabledOU = "OU=Disabled Users,$domainDN"

try {
    $user = Get-ADUser $SamAccountName -Properties MemberOf -ErrorAction Stop
} catch {
    Write-Error "User $SamAccountName not found."
    return
}

$groupNames = $user.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }

if ($PSCmdlet.ShouldProcess($SamAccountName, "Disable, remove groups, move to Disabled Users")) {
    Disable-ADAccount -Identity $user
    foreach ($g in $user.MemberOf) {
        Remove-ADGroupMember -Identity $g -Members $user -Confirm:$false
    }
    Set-ADUser -Identity $user -Description "Disabled $(Get-Date -Format yyyy-MM-dd), ticket $Ticket"
    Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU
    Write-Output "$SamAccountName offboarded. Removed from: $($groupNames -join ', ')"

    [pscustomobject]@{
        Date          = Get-Date -Format s
        User          = $SamAccountName
        Ticket        = $Ticket
        RemovedGroups = $groupNames -join ';'
    } | Export-Csv $LogPath -NoTypeInformation -Append
}
