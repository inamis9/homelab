<#
.SYNOPSIS
    Creates Active Directory users from a CSV of new hires.
.DESCRIPTION
    Reads FirstName, LastName, Department and Title from a CSV, builds a unique
    username (first initial + last name, numbered if taken), creates the account
    in the matching department OU with a temporary password, forces a password
    change at first logon, adds the user to the department group, and logs results.
.EXAMPLE
    .\New-LabUser.ps1 -CsvPath .\new-hires-sample.csv -WhatIf
.EXAMPLE
    .\New-LabUser.ps1 -CsvPath .\new-hires-sample.csv
.NOTES
    The log file contains temporary passwords. It is excluded by .gitignore.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$CsvPath,
    [string]$LogPath = ".\onboarding-log.csv"
)

Import-Module ActiveDirectory
$domain   = Get-ADDomain
$domainDN = $domain.DistinguishedName
$results  = @()

foreach ($row in Import-Csv $CsvPath) {
    $first = $row.FirstName.Trim()
    $last  = $row.LastName.Trim()
    $dept  = $row.Department.Trim()

    # Skip anyone who already has an account with the same display name
    if (Get-ADUser -Filter "DisplayName -eq '$first $last'") {
        $results += [pscustomobject]@{
            Date = Get-Date -Format s; User = "$first $last"; Department = $dept
            Status = "Skipped: display name already exists"; TempPassword = ""
        }
        continue
    }

    # Build a unique username like mlopez, mlopez2, mlopez3
    $base = (($first.Substring(0,1) + $last).ToLower()) -replace '[^a-z0-9]', ''
    $sam  = $base
    $n    = 1
    while (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
        $n++
        $sam = "$base$n"
    }

    $ou    = "OU=$dept,OU=LAB Users,$domainDN"
    $group = "GG_$dept"

    # Temporary password: random letters and numbers plus a fixed digit and symbol for complexity
    $chars    = (65..90) + (97..122) + (48..57) | ForEach-Object { [char]$_ }
    $tempPass = "Tmp-" + (-join ($chars | Get-Random -Count 10)) + "9!"

    try {
        if ($PSCmdlet.ShouldProcess($sam, "Create user in $ou and add to $group")) {
            New-ADUser -Name "$first $last" -GivenName $first -Surname $last `
                -SamAccountName $sam -UserPrincipalName "$sam@$($domain.DNSRoot)" `
                -DisplayName "$first $last" -Department $dept -Title $row.Title `
                -Path $ou -Enabled $true -ChangePasswordAtLogon $true `
                -AccountPassword (ConvertTo-SecureString $tempPass -AsPlainText -Force) `
                -ErrorAction Stop
            Add-ADGroupMember -Identity $group -Members $sam -ErrorAction Stop
            $status = "Created"
        } else {
            $status = "WhatIf"
        }
    } catch {
        $status = "Failed: $($_.Exception.Message)"
    }

    $results += [pscustomobject]@{
        Date         = Get-Date -Format s
        User         = $sam
        Department   = $dept
        Status       = $status
        TempPassword = $tempPass
    }
}

$results | Export-Csv $LogPath -NoTypeInformation -Append
$results | Format-Table User, Department, Status -AutoSize
