# Support Runbook

Step-by-step procedures for the most common help desk issues in the lab, written from worked tickets.

| Article | Use it when |
| --- | --- |
| [Unlock a Locked-Out Account](01-unlock-account.md) | "My account is locked" |
| [Reset a Forgotten Password](02-reset-password.md) | "I forgot my password" |
| [Onboard a New Hire](03-onboard-user.md) | "New hire starts Monday" |
| [Offboard a Departing Employee](04-offboard-user.md) | "Employee's last day is Friday" |
| [Troubleshoot a GPO That Isn't Applying](05-gpo-not-applying.md) | "My S: drive disappeared" / "My wallpaper is wrong" |
| [Fix "Internet Works but Company Resources Don't"](06-dns-connectivity.md) | "I can browse the web but can't open the shared drive" |
| [Repair a Broken Domain Trust Relationship](07-trust-relationship.md) | "The trust relationship between this workstation and the primary domain failed" |
| [Fix Common Printing Problems](08-printer-issues.md) | "I can't print" |

## Testing

Each article is tested by reverting a VM to an earlier snapshot, causing the problem again, and following the article word for word. Any step that needed guessing gets rewritten.
