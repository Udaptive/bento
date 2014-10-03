#!/bin/sh

echo "Current filesystem"
df -h

echo "Available block devices"
ls -alhF /dev/xv*

# Platform
mke2fs -t ext4 /dev/xvdj
echo '/dev/xvdj /vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /vagrant
mount /vagrant

# Mongo
mke2fs -t ext4 /dev/xvdk
echo '/dev/xvdk /data ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /data
mount /data

# Project Repos
mke2fs -t ext4 /dev/xvdl
echo '/dev/xvdl /project_repos ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /project_repos
mount /project_repos

# Log Files
mke2fs -t ext4 /dev/xvdm
echo '/dev/xvdm /var/log/vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /var/log/vagrant
mount /var/log/vagrant
