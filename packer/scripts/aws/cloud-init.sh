#!/bin/sh

# install cloud-init from epel
yum install cloud-init -y

# create cloud-user account
sudo useradd -m -U -G wheel cloud-user

# add cloud-user to sudoers
tee -a /etc/sudoers.d/cloud-user << EOF
cloud-user ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/cloud-user
