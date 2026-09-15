# Default ACLs and Inheritance

lab environment: 

`~/acl-lab/shared`

an access ACL on `shared/` would be insufficient to grant Carol a standard extended ACL entry because an ACL entry is not recursive, it only applies to the current object

a default access acl entry needs to present at the parent folder

a default ACL is associated with a directory, it is used to determine the ACL of a new object, the new object inherits the default ACL of the parent directory as its access ACL

If no default ACL is associated with a directory: the file creation mask(umask) is used to determine the ACL of the new object

A new created file and subdirectory will not inherit identical effective permissions depending on the base default traditional permission

## default access ACL


Baseline access ACL:

#file: shared/
#owner: lfcs-admin
#group: lfcs-admin
user::rwx
group::rwx
other::r-x

Proposed default ACL entry for Carol:  user:carol:rw-

Command I intend to use: `setfacl -m -default:carol:rw shared/`

Predicted `getfacl` output after the change:

default:user::rwx
default:user:carol:rw-
default:group::rwx
default:mask::rwx
default:other::r-x

### observed behaviour

the default access ACL is reconstructed using the traditional permission mode. Although the mask is `rwx` Carol's effective right are `rw-`

`getfacl shared/`

user::rwx
group::rwx
other::r-x
default:user::rwx
lfcs-admin@ubuntu-node-1:~$ cd acl-lab/                                                                    default:user:carol:rw-          #effective:rw-
lfcs-admin@ubuntu-node-1:~/acl-lab$ ls -l shared/                                                          default:group::rwx              #effective:rwx
default:mask::rwx
default:other::r-x

![](./lab_images/setfacl_-m-shared-directory.png)

### inheritance 

I will test how default access ACL's affect newly created files and directories

I predict the following:

new regular file:
user::rw-
user:carol:rw-
group::rw-
mask::rw-
other::rw-

new subdirectory:
user::rwx
user:carol:rw-
group::rwx
mask::rwx
other::r-x