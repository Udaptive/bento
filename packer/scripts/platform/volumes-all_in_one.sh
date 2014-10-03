#!/bin/sh

mke4fs -t ext4 /dev/sdc
echo '/dev/xvdc /vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /vagrant
mount /vagrant

mke4fs -t ext4 /dev/sdd
echo '/dev/xvdd /data ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /data
mount /data

mke4fs -t ext4 /dev/sde
echo '/dev/xvdd /project_repos ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /project_repos
mount /project_repos
