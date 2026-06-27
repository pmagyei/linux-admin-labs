### stat

stat displays file or file system status

%i shows the inode number. 
An inode stores metadata about a file or directory, it contains everything except the name and the data content itself. It references the dta blocks.

if two fileanames have the same inode number, they are hardlinks to the same inode.

%h showws the number of hard links. A hard link is directory entry that points directly to the physical data(inode) on a storage device
 
stat file vs stat -L

stat file  shows metada about the symlink itself

stat -L file follows/dereferences the syling and shows metadata about the target

stat exposes inode metada as well as permissions

### Hard links
 changes made to one filename are reflected to the other. if the original is deleted, data will still exist in the secondary hard link. Data will only be removed when all links to the data have been removed. 

Limitations:
Can only be created for regular files. 
Only works for new hard links on the same filesystem as the orignal.

### Soft links(symbolic links)
soft links link regular and non-regular files together, it is a separate file containing a path to another file. Soft links can span multiple filesystens. Use absolute path if file paths are in different directories. Use relative paths if the directory is the same.

Limitations:
if the original file is deleted, the soft link is broken, if a new file appears later at the same path, the symlink will work again.



### Key take aways:
A hard link is an additional directory entry pointing to the same inode. Removing one entry does not remove the file data while another hard link still exists.

A symbolic link is a separate file with its own inode that stores a path to another file. If the target path disappears, the symbolic link becomes dangling.


![file](/phase-01-linux-foudations/stat-links/lab_images/Screenshot%202026-06-26%20at%2017.23.51.png)

### timestamps

chmod chnags file metadata, so the ctime chnages

append changes the mtime and ctime. 

appending text changes file contents (mtime changes)
inode metada/status such as size affects the timestamp (ctime changes)

mtime = file contents changed
ctime = inode metadata/status changed
atime = file was read/accessed
birth = file creation time
directory mtime/ctime = directory entries changed
link count = number of directory entries pointing to the inode

stat commands:

%i = inode number, 
%h = hard link count,
%A = symbolic permissions,
%a = numeric mode,
%U = owner name,
%G = group name,
%n = file name
%s = size in bytes,
%x = time of last access, atime
%y = time of last data modification, mtime
%z = time of last status change, ctime



1. cat file

   → atime, subject to relatime/noatime behavior


2. echo "hello" >> file

   → file mtime + file ctime

3. chmod 600 file

   → file ctime

4. chown root:root file

   → file ctime

5. mv file renamed-file

   → file ctime + parent directory mtime/ctime

6. ln renamed-file hardlink

   → link count increases + file ctime + parent directory mtime/ctime

7. rm hardlink

   → link count decreases + file ctime + parent directory mtime/ctime

## stat/timestamp lab

![ss](/phase-01-linux-foudations/stat-links/lab_images/Screenshot%202026-06-27%20at%2001.35.49.png)


Goal: 

Understand and prove whichtimestamps changed and why.

created directory stat-time-lab
created file within the directory stat-time-lab
![ss](/phase-01-linux-foudations/stat-links/lab_images/Screenshot1.png)


confirmed the timestamps for both the file and the parent firectory
![ss](/phase-01-linux-foudations/stat-links/lab_images/Screenshot2.png)


renamed the file to renamed-file
confirmed and validated the new timestamps
![ss](/phase-01-linux-foudations/stat-links/lab_images/Screenshot3.png)

### Observations


File:
The file contents did not change so mtime stayed the same 

the file was not read, so atime stayed the same

only the ctime changed becasue the inode meatadata/status chnaged. rename updates inode chnage time stamp, hence only %z shows a different value once the file was renmaed

Parent directory:
atime chnaged becasue it was read/accessed using the ls commands
mtime changed because the contentriesents within the directory were chnaged(the file was renamed)
ctime changed because the directory inode metadata/status changed when its entries were updated.

hence %x %y %z shows different values after the contents within the directry were changed

### key take away:

file ctime chnaged becasue its file inode status chnaged.

the directory ctime chnaged becasue its inode (metadata) status chnaged

the directory's atime also chnaged because it accessed/read, thid was triggered the ls and ls -l commands within the directory when validating the file witin the directory


%x = time of last access,
%y = time of last data modification,
%z = time of last status change
%n = file name


### Takeaways
