# Unlock a Locked-Out Account

**Applies to:** All domain users  
**Typical ticket:** "My account is locked"  
**Time to resolve:** About 5 minutes

## Symptoms
The user sees "The referenced account is currently locked out and may not be logged on to."

## Steps
1. On DC01, open PowerShell as an administrator.
2. Confirm the lockout: `Search-ADAccount -LockedOut -UsersOnly`
3. Find which computer caused it: Event Viewer > Windows Logs > Security, filter on event ID 4740. The "Caller Computer Name" field shows the source.
4. Unlock the account: `Unlock-ADAccount -Identity <username>` (or right-click the user in ADUC > Properties > Account > Unlock account).
5. If the user doesn't know their password, follow 02-reset-password.md.

## Verify it worked
Ask the user to sign in. Run `Get-ADUser <username> -Properties LockedOut` and confirm `LockedOut` is False.

## Escalate to Tier 2 if
The account locks again within an hour. A saved bad password on a phone, mapped drive or service is the usual cause.

## Related
[02-reset-password.md](02-reset-password.md)
