Logs & journalctl

#### Service status vs Journal logs

I used "ssh.service" was used because the system already had SSH activity

confirmed state and logs using `systemctl status ssh.service --no pager`<br>

output showed:
the service state was active(running), the main PID: 885, which is the main ssh listener tracked by systemd 


logs of recent journal entries related to the unit including: <br>
`Accepted publickey for lfcs-admin`<br>
`pam_unix(sshd:session): session opened`

these are SSH authentication and PAM session events, the list does not prove that there is still active ssh sessions. The logs show events proving that it happened.

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot1.png)

I then ran `journalctl -u ssh.service -n 20`

This showed recent(last 20) journal entries associated to `ssh.service` 

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot2.png)


the difference between the two queries is that

`sysetmtctl status ssh.service` shows the current unit state and recent related logs

`journalctl -u ssh.service` shows journal entries specific to that unit

#### wrong filter applied

I intentionally ran:
"journalctl --user-unit=sshd"<br>

this returned `No entries`
![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot3.png)

this filter is wrong because:
`--user-unit=sshd` searches user-scoped systemd units. SSH is running as a system service unit, not as a user session unit.

I then ran:

`journalctl -u ssh.service`<br>
this returned  SSH authentication and session logs.

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot4.png)

The difference is:

`ssh.service` is the sytemd unit name

`sshd` is the daemom/process name

`--user-unit` searches user-scoped units<br>
`-u ssh.service` filters journal entries for the system service unit.
