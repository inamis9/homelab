# Troubleshoot a GPO That Isn't Applying

**Applies to:** Domain workstations  
**Typical ticket:** "My S: drive disappeared" / "My wallpaper is wrong"  
**Time to resolve:** 10 to 20 minutes

## Symptoms
A setting that should come from Group Policy is missing.

## Steps
1. On the client, run `gpupdate /force`, then sign out and back in.
2. Run `gpresult /r`. Check whether the GPO is listed under Applied or Filtered Out.
3. On DC01, check the user or computer is in the OU the GPO links to. User policies only apply to users; computer policies only apply to computers.
4. For drive maps, check group membership: `Get-ADPrincipalGroupMembership <username> | Select Name`
5. Fix the OU placement or group membership, then repeat step 1.

## Verify it worked
`gpresult /r` lists the GPO as applied and the setting is visible.

## Escalate to Tier 2 if
The GPO is applied but the setting still doesn't take effect.

## Related
[06-dns-connectivity.md](06-dns-connectivity.md)
