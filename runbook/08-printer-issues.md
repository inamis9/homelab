# Fix Common Printing Problems

**Applies to:** Domain workstations  
**Typical ticket:** "I can't print"  
**Time to resolve:** About 10 minutes

## Symptoms
Jobs don't print, sit in the queue, or the printer shows offline.

## Steps
1. Check the spooler: `Get-Service Spooler`
2. If stopped: `Start-Service Spooler` and `Set-Service Spooler -StartupType Automatic`
3. If jobs are stuck: stop the spooler, clear `C:\Windows\System32\spool\PRINTERS`, start the spooler.
4. Remove and re-add the printer if it still shows offline.
5. Send a test page.

## Verify it worked
A test page prints and the queue is empty.

## Escalate to Tier 2 if
The printer itself reports a hardware error, or every client fails (a print server problem).

## Related
[01-unlock-account.md](01-unlock-account.md)
