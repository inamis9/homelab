# Offboard a Departing Employee

**Applies to:** IT staff  
**Typical ticket:** "Employee's last day is Friday"  
**Time to resolve:** About 5 minutes

## Symptoms
HR or a manager reports an employee is leaving.

## Steps
1. Confirm the request came from HR or the employee's manager.
2. Dry run: `.\Remove-LabUser.ps1 -SamAccountName <username> -Ticket <number> -WhatIf`
3. Run it for real at the agreed time (end of last day, or immediately for an involuntary departure).
4. Note the removed groups from the output in the ticket.

## Verify it worked
In ADUC the account is disabled, sits in Disabled Users, and its description shows the date and ticket. A sign-in attempt fails.

## Escalate to Tier 2 if
The user owns shared files or mailboxes that need to be handed to someone else.

## Related
[03-onboard-user.md](03-onboard-user.md)
