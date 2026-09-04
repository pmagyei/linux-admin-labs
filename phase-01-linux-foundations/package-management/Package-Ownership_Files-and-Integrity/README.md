# Package Ownership, Files, and Integrity


## package state and ownership


### predictions

A file owned by debian package allows dpkg to recognise it as installed on the system


`/usr/sbin/sshd`, does not prove tat openssh-server owns it rather it proves that the shell can resolve and execute the package by command look up, evidence that the package is installed.

`dpkg -S /usr/sbin/sshd` would establish that the package owns that directory