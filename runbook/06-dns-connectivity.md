# Fix "Internet Works but Company Resources Don't"

**Applies to:** Domain workstations  
**Typical ticket:** "I can browse the web but can't open the shared drive"  
**Time to resolve:** About 10 minutes

## Symptoms
Public websites load, but domain sign-in, shares or other company resources fail.

## Steps
1. Run `ipconfig /all` and check the DNS server. It should be 10.0.0.10.
2. Run `nslookup lab.local`. If it fails, DNS is the problem.
3. Reset the adapter to automatic: Settings > Network > adapter > DNS server assignment > Automatic (DHCP).
4. Run `ipconfig /flushdns`, then `ipconfig /renew`.

## Verify it worked
`nslookup lab.local` returns 10.0.0.10 and `\\DC01\Sales` opens.

## Escalate to Tier 2 if
DNS is correct but resolution still fails, which may mean a problem on DC01 itself.

## Related
[05-gpo-not-applying.md](05-gpo-not-applying.md)
