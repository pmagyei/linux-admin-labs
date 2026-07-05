Commands I ran:

sudo chmod g+x /srv/project/ to give group execute permissions
sudo chmod g+s /srv/project/ to activate setgid bit allow files to inherit the directory's group

sudo chmod o+x /srv/project/ to give others execute permissions
sudo chmod +t /srv/project/ to activate sticky-bit prevents users from deleting each other's files



## stat 

to display file or file system status

%A     permission bits and file type
%a     permission bits in octal
%U     user name of owner
%G     group name of owner
%n     file name


stat -c "%A %a %n" /srv/project
stat -c "%A %a %U %G %n" /srv/project/adminfile.txt
stat -c "%A %a %U %G %n" /srv/project/enginfile.txt

I proved that the directory and files had the intended permissions and bits 

![file](/phase-01-linux-foundations/permissions/setgid-sticky-shared-directory/lab_images/Screenshot10.png)


## getfacl 

To display each file's name, owner, the group, and the Access Control List

getfacl /srv/project
getfacl /srv/project/adminfile.txt
getfacl /srv/project/enginfile.txt

This proved that there were no active access controls on the files or directory. getfacl also confirmed that the setgid and sticky-bit were active.(#flags)

##  lsattr

List the file attributes

lsattr /srv/project/adminfile.txt /srv/project/enginfile.txt

Confirmed that all positional flags are clear and no other attributes such a(append) or i(immutable) were set apart from the extent attribute by default.

![Screenshot of file](/phase-01-linux-foundations/permissions/setgid-sticky-shared-directory/lab_images/Screenshot6.png)


## sysctl

configures kernel parameters

fs.protected_regular blocks writing to another user's regular file inside a sticky shared directory

sudo sysctl -w fs.protected_regular=0
0 = allowed appending to the file

sudo sysctl -w fs.protected_regular=2 
2 = appending to another user's file fails