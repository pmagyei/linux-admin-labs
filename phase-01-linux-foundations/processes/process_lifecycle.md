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

FinallyI terminated the process with:

"kill -TERM 14840"<br>

SIGTERM requests termination, in this lab "sleep" exited. 


## What I expected

## Commands used

## Evidence

## Failure introduced / mistake observed

## Diagnosis

## Fix / correction

## Final mental model

## Relevance to infrastructure/cloud/DevOps