#!/bin/sh

mke2fs -t ext4 /dev/xvdc
echo '/dev/xvdc /vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /vagrant
mount /vagrant

mke2fs -t ext4 /dev/xvdd
echo '/dev/xvdd /data ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /data
mount /data

mke2fs -t ext4 /dev/xvde
echo '/dev/xvdd /project_repos ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /project_repos
mount /project_repos
