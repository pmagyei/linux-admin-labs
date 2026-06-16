# This Repository wll track my linux mastery journey

## Phase 1
navigation
files/directories
permissions
processes
services
logs
environment
man-page fluency

## Phase 2

topics:
storage
mounts
LVM
networking
SSH
firewall
cron/timers
packages
backup/restore

Hands on :
Proxmox VM with extra virtual disks
mount/fstab labs
SSH hardening
basic firewall rules
backup scripts

Terraform - Aws integration:
Deploy EC2 Linux instance
harden SSH
attach EBS volume
mount persistently via /etc/fstab
ship logs to CloudWatch 

Terraform creates EC2 + security group + EBS volume
manual Linux configuration first
then automate later


## Phase 3 - LFCS Prep

weekly objective blocks
daily task drills
mock exams
failure scenarios

Target:
perform tasks from memory
verify with man pages
recover from mistakes

## Phase 4 RHCSA Prep

Focus:

dnf
firewalld
SELinux
nmcli
systemd
storage/LVM
boot troubleshooting
users/groups
containers if required by objectives

Hands-on:

Rocky Linux VM on Proxmox
Red Hat-style task drills

## Phase 5 RHCE Prep

Focus:

Ansible inventory
playbooks
roles
variables
templates
handlers
conditionals
loops
idempotence
troubleshooting

Infrastructure:

1 control node
2–3 managed nodes
GitHub repo
CI syntax checks
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

design
build steps
failure introduced
diagnosis
repair
lessons learned
commands used
screenshots/output