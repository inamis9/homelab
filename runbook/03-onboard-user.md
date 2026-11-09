# Onboard a New Hire

**Applies to:** IT staff  
**Typical ticket:** "New hire starts Monday"  
**Time to resolve:** About 10 minutes

## Symptoms
HR or a manager requests an account for a new employee.

## Steps
1. Get first name, last name, department and title from the ticket.
2. Add a row to a new CSV in the format of `scripts/new-hires-sample.csv`. The department must be IT, Sales, HR or Finance.
3. Dry run: `.\New-LabUser.ps1 -CsvPath .\new-hires.csv -WhatIf`
4. Real run: `.\New-LabUser.ps1 -CsvPath .\new-hires.csv`
5. Open `onboarding-log.csv` for the username and temporary password. Check the status says "Created."
6. Deliver credentials to the manager through a verified channel.

## Verify it worked
Sign in on a client as the new user. Confirm the password-change prompt, the department drive and the wallpaper.

## Escalate to Tier 2 if
The status says "Failed" (usually an unknown department) or the department needs a new OU or group.

## Related
[04-offboard-user.md](04-offboard-user.md)
