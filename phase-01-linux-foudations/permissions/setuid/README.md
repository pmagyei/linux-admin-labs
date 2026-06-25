# setuid

Setuid on a executable file means when the program runs, it runs as the effective UID of the flle owner 


#### Observation:
After setting setuid on the shell script, the script still printed out the UID of the user who executed the script.

![file](/phase-01-linux-foudations/permissions/setuid/lab_images/Screenshot%202026-06-25%20at%2014.14.04.png)


#### Conclusion:
This was not a valid way to prove effective uid because when running the script, linux generally ignores the setuid when running interpreted scripts(bash, python).

To understand setuid better I inspected the /etc/usr/passwd, which is an already present setuid binary.
stat -c "%A %a %U %G %n" /usr/bin/passwd
ls -l  /usr/bin/passwd

![file](/phase-01-linux-foudations/permissions/setuid/lab_images/Screenshot%202026-06-25%20at%2014.16.34.png)


#### Setuid Take aways:
RUID = who started the process/ original identity behind the process
EUID = whose permissions the process uses. Kernel uses the process’s EUID for permission checks

setuid binary = changes EUID to file owner during execution

setuid script = generally ignored on Linux, the kernel ignores the setuid bit on a interpreted script at runtime, so the user is executed the the ruid. It only functions on compiled binary executables.

Setuid may appear as ls(-ld) output but the kernel may not honour it during execution

Setuid should not be group or world writable, this violates least privilege and security as this would allow other users to modify code that executes using the file owner’s UID. If the owner is root, it becomes a privilege escalation path.

![file](/phase-01-linux-foudations/permissions/setuid/lab_images/Screenshot%202026-06-25%20at%2014.03.46.png)
![file](/phase-01-linux-foudations/permissions/setuid/lab_images/Screenshot%202026-06-25%20at%2014.14.32.png)