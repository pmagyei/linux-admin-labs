# Linux-Admin-Labs repository 

## Phase 1
navigation <br>
files/directories <br>
text processing & pipes <br>
[permissions](/phase-01-linux-foundations/permissions/) <br>
[processes](/phase-01-linux-foundations/processes/) <br>
[systemd & services](/phase-01-linux-foundations/systemd/) <br>
[logs & journalctl](/phase-01-linux-foundations/journalctl-logs/) <br>
environment <br>
networking <br>
package management <br>
man-page fluency

## Phase 2

storage<br>
mounts<br>
LVM<br>
networking<br>
SSH<br>
firewall<br>
cron/timers<br>
packages<br>
backup/restore<br>

Hands on : <br>
Proxmox VM with extra virtual disks <br>
mount/fstab labs <br>
SSH hardening <br>
basic firewall rules <br>
backup scripts <br>

Terraform - Aws integration: <br>
Deploy EC2 Linux instance <br>
harden SSH <br>
attach EBS volume<br>
mount persistently via /etc/fstab <br>
ship logs to CloudWatch <br>

Terraform creates EC2 + security group + EBS volume <br>
manual Linux configuration first
then automate later


## Phase 3 - LFCS Prep

weekly objective blocks <br>
daily task drills<br>
mock exams<br>
failure scenarios<br>

Target:<br>
perform tasks from memory <br>
verify with man pages <br>
recover from mistakes

## Phase 4 RHCSA Prep

Focus:

dnf<br>
firewalld<br>
SELinux<br>
nmcli<br>
systemd<br>
storage/LVM<br>
boot troubleshooting<br>
users/groups
<br>
containers if required by objectives

Hands-on:

Rocky Linux VM on Proxmox <br>
Red Hat-style task drills<br>

## Phase 5 RHCE Prep

Focus:

Ansible inventory <br>
playbooks <br>
roles<br>
variables<br>
templates<br>
handlers<br>
conditionals<br>
loops<br>
idempotence<br>
troubleshooting<br>

Infrastructure:

1 control node<br>
2–3 managed nodes<br>
GitHub repo<br>
CI syntax checks<br>
Terraform-provisioned AWS test hosts later

## Phase 6 - Portofolio Porojects deliverables

1. Linux server hardening
2. SSH hardening and audit
3. Centralised logging
4. Backup and restore workflow
5. User/group access management
6. Web service deployment
7. Monitoring with Prometheus/Grafana
8. Ansible configuration management
9. Incident write-ups

EVERY PROJECT TO INCLUDE:

design<br>
build steps<br>
failure introduced<br>
diagnosis<br>
repair<br>
lessons learned<br>
commands used<br>
screenshots/output<br>