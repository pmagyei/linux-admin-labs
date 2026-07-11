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

#### Live logs

To view live logs from the ssh service I ran: `journalctl -u ssh.service -f`, it shows previous events as well as live events. 

I ssh into the same VM from another terminal window, two events occured:

`Accepted publickey for lfcs-admin` and `pam_unix(sshd:session): session opened`

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot5.png)

I then performed `sudo systemctl reload ssh.service` 

this runs the unit's ExecReload actions:
1. /usr/sbin/sshd -t, this validates ssh daemon configuration.
2. kill -HUP $MAINPID sends SIGHUP to the main sshd process. Causing sshd to reload configuration without a full service restart.


![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot7.png)


I then ran `sudo systemctl restart ssh.service`:

The logs showed a different lifecycle:

- sshd received signal 15 / SIGTERM
- ssh.service deactivated successfully
- ssh.service stopped
- ssh.service started again
- sshd began listening on port 22 again for IPv4 and IPv6

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot8.png)


I checked the service status:

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot9.png)

The ExecStartPre validation process was PID 25363<br>
The MAIN PID was 25365<br>
The previous MAIN PID was 885

`reload` and `restart` behave differently: 

`reload` keeps the daemon running and reloads the configuration, it avoids stopping and replacing the main daemon process. It did not disconnect the session because it signalled the main sshd listener to reload configuration without replacing the session process.

`restart` stops and starts the service creating a new MAIN PID, this creates a higher lockout risk, especially if the new configuration is broken or remote access depends on the service coming back cleanly; in this lab `restart` did not disconnect my existing SSH session because sshd session child processes can remain separate from the main listener, and this unit uses behaviour that does not necessarily kill every existing session. 
