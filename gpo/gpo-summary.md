# Group Policy Summary

| GPO | Linked to | Type | What it does |
| --- | --- | --- | --- |
| Default Domain Policy | lab.local | Computer | 12-character minimum, complexity on, 90-day max age; lockout after 5 bad attempts for 15 minutes |
| USR - Drive Maps | LAB Users | User | Maps S:, H: and F: to department shares, targeted by security group |
| USR - Restrict Control Panel | Sales, HR, Finance OUs | User | Blocks Control Panel and PC settings for non-IT staff |
| USR - Desktop Wallpaper | LAB Users | User | Sets the company wallpaper from `\\DC01\Public\wallpaper.jpg` |
| CMP - Logon Banner | LAB Computers | Computer | Shows an authorized-use notice before sign-in |

## Naming

`USR -` policies hold user settings and link to user OUs. `CMP -` policies hold computer settings and link to the computer OU. Keeping them separate makes it obvious why a policy isn't applying: a user policy linked to a computer OU (or the reverse) does nothing.

## Verification

On a client: `gpupdate /force`, sign out and back in, then `gpresult /r` and `gpresult /h C:\gpreport.html`.

| GPO | Test | Expected |
| --- | --- | --- |
| Password and lockout | Wrong password 5 times | Account locked out |
| Drive maps | Log in as a Sales user | S: appears, H: and F: do not |
| Restrict Control Panel | Open Control Panel as Sales user | Blocked |
| Restrict Control Panel | Open Control Panel as IT user | Opens normally |
| Wallpaper | Log in as any user | Company wallpaper set |
| Logon banner | Restart client | Banner before sign-in |
