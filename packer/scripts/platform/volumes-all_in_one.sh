#!/bin/sh

for i in $(curl -s http://169.254.169.254/latest/meta-data/block-device-mapping/) ; do echo $(curl -s http://169.254.169.254/latest/meta-data/block-device-mapping/$i); done

mke2fs -t ext4 /dev/xvdf
echo '/dev/xvdf /vagrant ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /vagrant
mount /vagrant

mke2fs -t ext4 /dev/xvdg
echo '/dev/xvdg /data ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /data
mount /data

mke2fs -t ext4 /dev/xvdh
echo '/dev/xvdh /project_repos ext4 defaults,noatime 0 2' >> /etc/fstab
mkdir /project_repos
mount /project_repos
