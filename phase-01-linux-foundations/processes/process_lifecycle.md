# Process Lifecycle Lab 

## Goal: understand process identity, parent/child relationsip, process state, signals and job control.

### Background Process and PID

Started a long-running process in the background <br>
PID assigned was 14253
it's ppid is 13990, this identifies the parent process that started the sleep process

STAT shows S which means interruptible sleep. The sleep process is waiting for the timer to elapse or for a signal to arrive. Sleep is S because its job is to wait.

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot9.png)

#### SIGSTOP AND SIGCONT
SIGSTOP signal was sent:

"kill -STOP 14253"<br>
The Sleep process state was chnaged to T, T indicates the the porcess was stopped, this does not terminate the process. It remained in the process table.

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot10.png)


SIGCONT signal was sent:

"kill -CONT 14253"<br>
The sleep process resumed to S
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot11.png)


SIGTERM signal was sent:

"kill -TERM 14253"<br>

SIGTERM requests termination, PID,PPID do not show in the ps output. 
A process can handle or ignore SIGTERM, in this lab "sleep" exited. 

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot12.png)


#### SIGKILL and why it is different
SIGKILL cannot be caught, blocked, or ignored. Termination is forced.
SIGKILL is risky in production because a process cannot clean up, finish writes or shut down safely.

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot13.png)
 
### Shell Job control

Started a sleep process running in the background.<br>
The shell returned: <br>
[1] 14840. [1] is shell job number. 14840 is the process ID.

I used "jobs" to view the shell's job table.
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot14.png)

"fg %1" moves the job foreground. The shell waits for the foreground job. No prompts return while "sleep 500" runs.

cntrl+z sends the "SIGTSTP" signal to the forground job, this stopped the job. SIGTSTP sends stop signal from the terminal, the process is able handle/ignore it. 

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot14.1.png)


I confirmed the state of the process was T, T indicates the the porcess was stopped and not terminated.
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot15.png)


"bg %1" resumes the job in the background.

Finally terminated the process with:

"kill -TERM 14840"<br>

SIGTERM requests termination, in this lab "sleep" exited. 
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot16.png)



#### parent/child model

Started by confirming the current shell pid<br>
"echo $$" 15159

Started a sleep process running in the background, the shell returned its pid: 15303 <br>
the sleeps PPID is 15159

The sleep ppid matches the shell's pid, this means that the current shell started the sleep process

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot17.png)

Another observation, using a separte shell window, for example in tmux, each session/window/pane will have a different shell pid number, however these shell sessions will share the same ppid.

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot18.png)
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot19.png)
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot20.png)
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot21.png)


#### Orphan Process

I confirmed the current shell process being used using "$$"<br>
PID of the shell: 18199<br>
I started a sleep process in the background, the shell returned the processe PID: 18205

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot22.png)


I confirmed the sleep process PID, its PPID was the same as the current shell's PID
![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot23.png)

exited the current shell and inspected the sleep process ps attributes in another shell:

after the parent shell exited, the sleep process ppid changed to 1. On this systemd, PID 1 belongs to systemd; systemd adopted the orphaned procees.

The child process does not exit when the parent exits, if the child keeps running after the parent exits. It becomes orphaned and is adopted by anothe process, usually PID 1/systemd.

![ss](/phase-01-linux-foundations/processes/lap_images/Screenshot24.png)