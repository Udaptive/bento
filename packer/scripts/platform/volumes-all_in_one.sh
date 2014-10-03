#!/bin/sh

echo "Current filesystem"
df -h

echo "Available block devices"
ls -alhF /dev/xv*

# Platform
if [[ -e /dev/xvdj ]] ; then
    mke2fs -t ext4 /dev/xvdj
    echo '/dev/xvdj /vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
    mkdir /vagrant
    mount /vagrant
fi

# Mongo
if [[ -e /dev/xvdk ]] ; then
    mke2fs -t ext4 /dev/xvdk
    echo '/dev/xvdk /data ext4 defaults,noatime 0 2' >> /etc/fstab
    mkdir /data
    mount /data
fi

# Project Repos
if [[ -e /dev/xvdl ]] ; then
    mke2fs -t ext4 /dev/xvdl
    echo '/dev/xvdl /project_repos ext4 defaults,noatime 0 2' >> /etc/fstab
    mkdir /project_repos
    mount /project_repos
fi

# Log Files
if [[ -e /dev/xvdm ]] ; then
    mke2fs -t ext4 /dev/xvdm
    echo '/dev/xvdm /var/log/vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
    mkdir /var/log/vagrant
    mount /var/log/vagrant
fi
