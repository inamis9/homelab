# Help Desk Home Lab

A simulated small-business IT environment built in VirtualBox to practice Tier 1 and Tier 2 help desk work: Active Directory administration, Group Policy, PowerShell automation, ticketing, and support documentation.

> **Status: in progress (started November 2026).** The domain, DNS, DHCP and domain-joined workstations are working. Group Policy, the PowerShell scripts, the ticketing server and the runbook are being built and tested now. The checklist at the bottom tracks what's done.

## Network

| VM | OS | Role | IP |
| --- | --- | --- | --- |
| DC01 | Windows Server 2022 | Domain controller (AD DS, DNS, DHCP), file shares | 10.0.0.10 (static) |
| CLIENT01 | Windows 11 Enterprise | Domain-joined workstation | DHCP (10.0.0.100-200) |
| CLIENT02 | Windows 11 Enterprise | Domain-joined workstation | DHCP (10.0.0.100-200) |
| TICKET01 | Ubuntu Server 22.04 | osTicket help desk (Apache, MariaDB, PHP) | 10.0.0.20 (static) |

All four VMs sit on a private VirtualBox NAT network (`10.0.0.0/24`, gateway `10.0.0.1`) with VirtualBox's DHCP turned off, so DC01 handles addressing the way it would in a real office. The domain is `lab.local`.

<!-- Add screenshots/network-diagram.png here once it's drawn -->

## What's in the lab

**Active Directory.** Department OUs (IT, Sales, HR, Finance) under `LAB Users`, separate OUs for computers, groups and disabled accounts, and one global security group per department (`GG_IT`, `GG_Sales`, and so on). Permissions are assigned to groups, never to individual users.

**File shares.** Department shares on DC01 with NTFS permissions limited to each department's group, so a Sales user can open `\\DC01\Sales` but gets access denied on `\\DC01\HR`.

**Group Policy.** Five GPOs covering password and lockout policy, department drive mapping with item-level targeting, a Control Panel restriction for non-IT staff, a company wallpaper, and a logon banner. Details in [`gpo/gpo-summary.md`](gpo/gpo-summary.md).

**PowerShell automation.** Three scripts in [`scripts/`](scripts/):

| Script | What it does |
| --- | --- |
| `New-LabUser.ps1` | Creates users from a CSV of new hires: unique usernames, temporary passwords, correct OU and group, forced password change, logging. Supports `-WhatIf`. |
| `Remove-LabUser.ps1` | Offboards a user: disables the account, records and removes group memberships, stamps the date and ticket number, moves it to `Disabled Users`. Supports `-WhatIf`. |
| `Get-LabAccountReport.ps1` | Lists locked-out, disabled and password-expired accounts and exports a dated CSV. |

```powershell
.\New-LabUser.ps1 -CsvPath .\new-hires-sample.csv -WhatIf
.\Remove-LabUser.ps1 -SamAccountName dclark -Ticket 104
```

**Ticketing.** osTicket on Ubuntu with help topics, SLA plans (4, 24 and 72 hours), Tier 1 and Tier 2 departments, and canned responses. Each of the ten tickets below is worked end to end: reported by a user, triaged, reproduced in the lab, troubleshot with notes, fixed, and closed.

**Runbook.** Support procedures written from the ticket notes, in [`runbook/`](runbook/).

## Tickets

Planned incidents. Each row gets a screenshot link once the ticket is closed.

| # | Issue | Root cause | Fix |
| --- | --- | --- | --- |
| 1 | Account locked out | 5 bad password attempts | Found source via event ID 4740, unlocked account |
| 2 | Forgotten password | User error | Verified identity, reset, forced change at logon |
| 3 | New hire onboarding | Request | `New-LabUser.ps1` |
| 4 | Employee offboarding | Request | `Remove-LabUser.ps1` |
| 5 | Mapped drive missing | User removed from department group | Diagnosed with `gpresult`, restored membership |
| 6 | Access denied to HR folder | Working as intended | Routed as access request |
| 7 | Can't reach company resources | Client DNS set to public resolver | Reset to DHCP-assigned DNS, flushed cache |
| 8 | Trust relationship failed | Computer account password out of sync | `Test-ComputerSecureChannel -Repair` |
| 9 | Can't print | Print spooler stopped | Restarted service, set to Automatic |
| 10 | Slow PC, disk full | Large temp file | Located with storage tools, removed, Disk Cleanup |

Ticket screenshots go in [`tickets/`](tickets/) as each one is completed.

## Technologies

Windows Server 2022, Active Directory, DNS, DHCP, Group Policy, PowerShell, Windows 11 Enterprise, Ubuntu Server, Apache, MariaDB, osTicket, VirtualBox

## Progress

- [x] VirtualBox lab network and VMs
- [x] Domain controller with AD DS, DNS and DHCP
- [x] Both workstations joined to `lab.local`
- [ ] OUs, groups, users and file shares
- [ ] 5 GPOs configured and verified with `gpresult`
- [ ] PowerShell scripts tested, including `-WhatIf` runs
- [ ] osTicket installed and configured
- [ ] 10 tickets worked and documented
- [ ] Runbook written and tested
- [ ] Network diagram and screenshots

## What I learned

<!-- Fill in 3 to 5 honest bullets as you go: what broke, how you narrowed it down, what fixed it. -->

## Next steps

- Add a second domain controller for redundancy
- Sync the domain to Microsoft Entra ID
- Manage the workstations with Intune
