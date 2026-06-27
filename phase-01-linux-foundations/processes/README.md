# Process vs Service

### Process lab
"sleep 500 &" starts a sleep process in the background and prints the pid, in this case 36562

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

