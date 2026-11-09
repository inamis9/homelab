# Repair a Broken Domain Trust Relationship

**Applies to:** Domain workstations  
**Typical ticket:** "The trust relationship between this workstation and the primary domain failed"  
**Time to resolve:** About 10 minutes

## Symptoms
Domain users can't sign in on one computer and see the trust relationship error.

## Steps
1. Sign in with the local admin account (`.\localadmin`).
2. Open PowerShell as administrator and run `Test-ComputerSecureChannel` to confirm it returns False.
3. Repair: `Test-ComputerSecureChannel -Repair -Credential LAB\Administrator`
4. Restart the computer.

## Verify it worked
A domain user can sign in, and `Test-ComputerSecureChannel` returns True.

## Escalate to Tier 2 if
The repair fails. Remove the computer from the domain and rejoin it.

## Related
[06-dns-connectivity.md](06-dns-connectivity.md)
