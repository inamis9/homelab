# Reset a Forgotten Password

**Applies to:** All domain users  
**Typical ticket:** "I forgot my password"  
**Time to resolve:** About 5 minutes

## Symptoms
The user can't sign in and doesn't know their current password.

## Steps
1. Verify the user's identity (employee ID or confirmation from their manager). Never reset a password based on a name alone.
2. On DC01: `Set-ADAccountPassword -Identity <username> -Reset -NewPassword (Read-Host -AsSecureString "Temp password")`
3. Force a change at next sign-in: `Set-ADUser -Identity <username> -ChangePasswordAtLogon $true`
4. If the account is also locked, run `Unlock-ADAccount -Identity <username>`.
5. Give the temporary password to the user through a verified channel, not in the ticket.

## Verify it worked
The user signs in with the temporary password and is prompted to set a new one.

## Escalate to Tier 2 if
Identity can't be verified, or the account belongs to an administrator.

## Related
[01-unlock-account.md](01-unlock-account.md)
