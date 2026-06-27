# umask

Umask controls the default permissions of newly created files or directories

default file permissions 666 

default directory permissions 777

Umask removes permission bits from the default permissions at the default creation mode of a file/directory

Example: 
If Umask is currently set to 0002

File permissions at creation would be 664 

directory permissions creation would 775

new file mode = 666 & ~umask 

new directory mode = 777 & ~umask

![ss](/phase-01-linux-foudations/permissions/umask/lab_images/Screenshot%202026-06-19%20at%2015.21.37.png)

### Umask lab

Expectation:
Setting the umask will change the default base permission of new files or directories 

### Set umask to 022

Create file and directory 

New file: 644, why? 666-022 -rw-r--r—

New directory: 755, why? 777-022 drwxr-xr-x

### set umask to 002
Create file and directory 

New file: 664, why? 666-002 -rw-rw-r--

New directory: 775, why? 777-002 drwxrwxr-x


### set umask to 077
Create file and directory 

New file: 600, why? 666-077 -rw-------

New directory: 700, why? 777-077 drwx------

stat -c "%A %a %n" file-* dir-* to confirm permissions/mode



### observations:

Umask removes permission bits(bitmask) from the base defaults. 
By changing the umask, the default base permissions of the newly created files and directories are altered.

Umask can be set to the following, depending on environment and workload criteria:

002 for group shared workloads, group write and read enabled ,allows users the group to write files and access the directory 

027 for secure workloads, group readable, write removed, others blocked, user can read file/access directories 

077 private environment only user/owner can access
![ss](/phase-01-linux-foudations/permissions/umask/lab_images/Screenshot%202026-06-19%20at%2015.24.54.png)

![ss](/phase-01-linux-foudations/permissions/umask/lab_images/Screenshot%202026-06-19%20at%2015.23.24.png)