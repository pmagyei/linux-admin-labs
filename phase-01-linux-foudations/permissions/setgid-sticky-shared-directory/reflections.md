# Reflections

This lab exposed a gap in my understanding of Linux permissions. I initially treated permissions as if they were controlled only by chmod, ownership, and group membership. The lab showed that Linux access control is layered, and that kernel hardening settings can affect behaviour even when normal Unix permission bits appear to allow access.

## What I learned

sysctl is used to view and configure kernel parameters at runtime.

One of the parameters I encountered was:

fs.protected_regular

On this Ubuntu system, the value was:

fs.protected_regular = 2

This is a kernel hardening setting. In this lab, it prevented users from appending to regular files they did not own inside a sticky group-writable directory.

## Original expectation

The shared directory was intended to use:

/srv/project = drwxrwsr-t root srvgrp

Numeric mode:

3775

This means:

setgid enabled
sticky bit enabled
owner has rwx
group has rwx
others have r-x

Files created inside the directory inherited the shared group:

adminfile.txt = -rw-rw-r-- srvadmin srvgrp
enginfile.txt = -rw-rw-r-- srvengin srvgrp

Based on the normal Unix permission model, I expected users in srvgrp to be able to append to each other’s files because the files had group write permission.

## Actual behaviour

Deleting each other’s files failed as expected. This confirmed that the sticky bit was working.

However, appending to each other’s files using shell redirection failed when the directory was 3775 and fs.protected_regular=2 was enabled.


Example:

echo "text" >> adminfile.txt

The error was:

Permission denied

This happened even though:

the file group was srvgrp
the file mode was -rw-rw-r--
the users were members of srvgrp
ACLs did not show extra restrictions
file attributes did not show immutable flags
Accidental discovery

Later, I accidentally changed the directory mode from:

3775
drwxrwsr-t

to:

3755
drwxr-sr-t

![](/phase-01-linux-foudations/permissions/setgid-sticky-shared-directory/lab_images/Screenshot12.png)

After removing group write permission from the directory, users could append to each other’s existing files.

This created a paradox:

Less directory write permission → lower-risk context → append allowed
More directory write permission → higher-risk shared writable context → append denied
Why this happened

Removing group write from the directory changed the behaviour.

With 3755:

group members can list and traverse the directory
group members cannot create new files
group members can append to existing group-writable files
the directory is sticky but not group-writable

With 3775:

group members can list, traverse, and create files
the directory is sticky and group-writable
fs.protected_regular=2 treats this as a protected shared writable context
cross-user appending a file using shell redirection is denied

The important lesson is that adding group write permission did not directly block editing. Instead, adding group write made the directory a sticky group-writable directory, which triggered an additional kernel hardening rule.

## The model

Appending to a file depends on more than just file write permission.

Append requires:

execute permission on parent directories
write permission on the target file
valid group or ACL access
file attributes allowing modification
kernel hardening policy allowing the open operation

Deleting a file is different.

Delete requires:

write + execute permission on the parent directory
sticky-bit ownership rules allowing deletion
Key takeaway

This lab showed that Linux permissions are not a single layer.

The access decision involved:

identity
group membership
directory permissions
file permissions
ACLs
file attributes
kernel hardening

The main lesson:

chmod can appear to allow access, but the kernel can still deny the operation because of another security layer.