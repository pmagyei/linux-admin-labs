Logs & journalctl

ssh.service will be used

confirmed state and logs using "systemctl status ssh.service"<br>
the service state was active(running), the main PID: 885

the recent logs show by systemctl were:
timestamped activities and child processes pid, the events were public key authorization and confirmation off opening sessions, this prooves there was an active ssh connection. 

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot1.png)

for journalctl logs"

"journalctl -u ssh.service"

the last 20 logs od the service unit were shown, exact logs format as systectl status command, however, journalctl onlky shows logs where as systemctl shows both state and logs

![ss](/phase-01-linux-foundations/journalctl-logs/lab_images/Screenshot2.png)

The logs type are ssh login and session logs.
