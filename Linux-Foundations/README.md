Linux Permissions Drill: setgid, sticky bit, and layered access control

# Goal

The goal of this lab was to understand how Linux permission bits behave differently for files and directories, and how special permission bits such as setgid and the sticky bit affect shared directories.

The lab also exposed an additional access-control layer: Ubuntu kernel hardening through fs.protected_regular.


## File permissions

Example file mode:

-rw-r--r--

Breakdown:

Regular file

- rw-  owner can read and write
- r--  group can read
- r--  others can read

Numeric mode:

644

For files:

- r = read file contents
- w = modify file contents
- x = execute the file as a program/script


## Directory permissions

Example directory mode:

drwxr-xr-x

Breakdown:

d     directory
rwx   owner can list, create/delete/rename entries, and traverse
r-x   group can list and traverse
r-x   others can list and traverse

Numeric mode:

755

For directories:

r = list names inside the directory
w = create/delete/rename directory entries
x = traverse/access entries inside the directory

### Important distinction:

File permissions control editing file contents.

Directory permissions control creating, deleting, and renaming names inside the directory.



## Special bits
setgid on a directory

When setgid is enabled on a directory, new files created inside the directory inherit the directory's group.

Example:

drwxrwsr-x

The s in the group execute position means:

setgid is active and group execute is present

If shown as uppercase S, setgid is set but group execute is missing.


## Sticky bit on a directory

When the sticky bit is enabled on a directory, users cannot delete or rename files owned by other users, unless they are root or own the directory.

Example:

drwxrwxr-t

The t in the others execute position means:

sticky bit is active and others execute is present

If shown as uppercase T, sticky bit is set but others execute is missing.

Sticky bit affects deletion and renaming. It does not control writing to file contents.



## Lab setup

The shared directory used in this lab was:

/srv/project

The final intended mode was:

3775

Expected permission string:

drwxrwsr-t

Breakdown:

3     setgid(2) + sticky bit(1)
775   owner/group have rwx, others have r-x

The directory group was changed to:

srvgrp

Final expected state:

/srv/project = drwxrwsr-t root srvgrp

![Screenshot of file](/Linux-Foundations/lab_images/Screenshot1.png)


## Expected behavior

With users srvadmin and srvengin both belonging to srvgrp:

New files should inherit the srvgrp group.
Both users should be able to create files.
Both users should be blocked from deleting each other’s files because of the sticky bit.

Files created inside the directory inherited the group correctly:

adminfile.txt = -rw-rw-r-- srvadmin srvgrp
enginfile.txt = -rw-rw-r-- srvengin srvgrp

This confirmed that setgid was working.

Deleting each other’s files failed as expected. This confirmed that the sticky bit was working.

![Screenshot of file](/Linux-Foundations/lab_images/Screenshot3.png)


![Screenshot of file](/Linux-Foundations/lab_images/Screenshot2.png)


## Unexpected failure

Based on the file mode:

-rw-rw-r--

and shared group:

srvgrp

I expected both users to append text to each other’s files.

However, append using shell redirection failed:

echo "linux bash" >> adminfile.txt

The error was:

Permission denied

This happened even though:

the directory permissions allowed access
the file group was correct
the file group had write permission
the ACLs showed no extra restrictions
file attributes did not show immutable flags


## Troubleshooting steps

I checked the directory and file modes:

stat -c "%A %a %U %G %n" /srv/project
stat -c "%A %a %U %G %n" /srv/project/adminfile.txt
stat -c "%A %a %U %G %n" /srv/project/enginfile.txt

I checked ACLs:

getfacl /srv/project
getfacl /srv/project/adminfile.txt
getfacl /srv/project/enginfile.txt

I checked file attributes:

lsattr /srv/project/adminfile.txt /srv/project/enginfile.txt

![Screenshot of file](/Linux-Foundations/lab_images/Screenshot6.png)



I then checked Ubuntu kernel hardening settings:

sysctl fs.protected_regular

The result was:

fs.protected_regular = 2


## Root cause

Ubuntu had fs.protected_regular=2 enabled.

This kernel hardening setting can block certain write/create operations against regular files that the current user does not own inside sticky writable directories.

The shell redirection operator:

">>" is handled by the shell. Bash opens the file for append before running the command.

With fs.protected_regular=2, the kernel blocked the open operation even though normal Unix permission bits appeared to allow it.

Temporarily setting the value to 0 allowed the append test to work:
![Screenshot of file](/Linux-Foundations/lab_images/Screenshot8.png)


sudo sysctl -w fs.protected_regular=0

After testing, the setting should be restored:

sudo sysctl -w fs.protected_regular=2

![Screenshot of file](/Linux-Foundations/lab_images/Screenshot9.png)

This should not be left disabled permanently because it is a security hardening control.



## Key lessons

Linux permissions are layered.

The access decision was not based only on chmod mode bits. The full troubleshooting chain included:

identity
group membership
directory permissions
file permissions
ACLs
file attributes
kernel hardening

The main permission model learned from this lab:

File write permission controls editing file contents.
Directory write + execute controls create/delete/rename operations.
Sticky bit restricts deletion and renaming inside shared directories.
setgid on a directory causes new files to inherit the directory group.
Kernel hardening can still deny access even when normal permissions appear correct.

screenshots to the lab can be found [here](/Linux-Foundations/lab_images/)
