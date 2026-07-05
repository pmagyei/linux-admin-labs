# Process vs Service

### Process lab
"sleep 500 &" starts a sleep process in the background and prints the pid, in this case 36562


![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot01.png)

the signal numbering for SIGTOP is 19: <br>
"kill -s 19 36562" or "kill -STOP 36562"
stops the process

the signal numbering for SIGCONT is 18: <br>
"kill -s 18 36562" or "kill -CONT 36562"
resumes the process

the default signal for kill is SIGTERM:<br>
the signal numbering for SIGTERM is 15 <br>
"kill 36562" or "kill -TERM 36562"
terminates the process

in commands and documentation is better to use the signal names because they are clearer than the signal numbers

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot1.png)


Difference between stopping a process and a systemd service?<br>

Because a process is directly managed by its PID whereas a systemd service is controld through a unit.

when running the command "kill PID", you are directly talking to the PID.

when running "systemctl stop ssh", you are asking systemd to stop the service unit.

### Systemd lab

I chose ssh.service as the unit name to check out:

"systemctl status ssh.service" to identify:

unit name: ssh.service
Status: active (running)
main pid: 3264
process ID: (sshd)

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot2.png)

verify the pid:

"ps -o pid,ppid,stat,cmd -p 3264"
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot3.png)

PPID 1 means that systemd is the parent
PID(process ID) 3264 is the sshd listener process, if the unit restarts the PID may change

this proves that systemd is managing the ssh service listener process.

I initially ran "journalctl --user-unit=sshd", this is the wrong filter. Journactl returned no entries because I queries the wrong journal scope and unit name.

--user-unit shows user systemd journal messages not the system service journal, I used --user-unit=sshd, but SSH is a system unit named ssh.service not a process named sshd.
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot4.png)

the correct command:
journalctl -u ssh.service -n 20 --no-pager or journalctl -t sshd -n 20 --no-pager (using process identifier)
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot5.png)

Journalctl shows logs associated to the ssh .service unit, the output shows SSH authentication and session events.<br>
"Accepted publickey" shows successful key-based authentication.<br>
"pam_unix(sshd:session): session opened" shows that PAM opened a login session for the user.

The different sshd[PID] values show that separate sshd child processes handled different connections/sessions. The main ssh.service PID remains the listener process unless the service itself restarts.

### Key takeaways

difference between the unit name and the process PID:<br>

a systemd unit name identifies a managed systemd object such as ssh.service

The PID identifies a process.

a systemd unit manages a service unit. A process is started by that service unit.

enabled/disabled show wether the unit is configured to start automatically at boot
active/inactive wether the service is currently running 
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot6.png)
ssh.service was disabled, active(running) and TriggeredBy: ssh.socket, this means that the ssh.service was triggered by the ssh.socket

### the concetual model:<br>
service = systemd unit<br>
Main PID = process<br>
[PID] in logs = process that emitted that log line<br>
changing log PIDs = child processes<br>
service lifecycle logs = start/stop/restart/unit state changes


## Process tree lab

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot8.png)

New SSH connections are handled/processed and accepted by the sshd listener

sshd creates child porcesses to handle the connections

In this lab"
3264 is the PID listener 
48349 is the child process for lfcs-admin
48429 is the user/session sshd process attached to pts/3 

3264 > 48349 > 48429

Killing the listener should not terminate the existing ssh connections because they've already been passed/handled to the child process.

nothing, existing ssh session will remain
if you kill the listener, depending on the policies for the service unit, it might restart the session to allow new ssh;
How ever new ssh connections require a listener of the listener has. not been started new ssh conections will fail.
If systemd or ssh.socket restarts/activates the service, new connecvtions may work again

### Unit configuration inspection

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot7.png)

The service unit configuration determines how systemd starts, stops, reloads and manages a service.

ssh.service configuration file:

ExecStartPre=/usr/sbin/sshd -t, this tests the sshd confirguration file, if it is invalid, the service should fail starting the daemon
services often validate config before startup <br>
ExecStart=/usr/sbin/sshd -D $SSHD_OPTS, this starts the main process(ssh) to start foreground allowing systemd totack the process directly <br>
ExecReload=/usr/sbin/sshd -t, tests the configuration before reloading it <br>
ExecReload=/bin/kill -HUP $MAINPID, sends SIGHUP to the main($MAINPID) SSH listener process <br>
KillMode=process, only terminates the main process when stopping the service. this explains why a process does not terminate existing child/session processes when the listener is stopped or killed <br>
Restart=on-failure, systemd restarts the service if it is terminated unexpectedly.
running "systemctl stop ssh.service" is an admin-requested stop, not a failure. "Restart=on-failure" should not restart from that command.<br>

RestartPreventExitStatus=255, if there is an exit code of 255, the service should not restart the listener

in the "systemctl status ssh.service" output there was a "TriggereBy ssh.socket"
this mean:
the socket listens for incoming conections events, when the connection arrives, systemd activates the service(ssh.service)