#!/bin/sh


# install apache and related modules
cat <<EOF | xargs yum install -y
httpd
httpd-devel
mod_ssl
mod_xsendfile
EOF


# install mysql latest
pushd /tmp
if [[ ! -e /etc/yum.repos.d/mysql-community.repo ]] ; then
    wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    rpm -Uvh mysql-community-release-el6-5.noarch.rpm
    rm -f mysql-community-release-el6-5.noarch.rpm
fi
yum install -y mysql-community-server mysql-community-devel
# do not start until configured by bootstrap
chkconfig mysqld off
popd


# install mongodb 2.6.4
MONGO_VERSION=`mongod --version | grep "db version"`
if [[ "$MONGO_VERSION" != "db version v2.6.4" ]] ; then
    cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
    yum install mongodb-org-2.6.4 -y
    # do not start until configured by bootstrap
    chkconfig mongod off
fi


# install rabbitmq-server
if [[ ! `chkconfig | grep rabbitmq` ]] ; then
    yum -y install rabbitmq-server
    # do not start until configured by bootstrap
    chkconfig rabbitmq-server off
fi


# install nodejs 0.10.32
NODE_VERSION=`node --version`
if [[ "$NODE_VERSION" != "v0.10.32" ]] ; then
    pushd /tmp
    wget http://nodejs.org/dist/v0.10.32/node-v0.10.32.tar.gz
    tar xvf node-v0.10.32.tar.gz
    pushd node-v0.10.32
    ./configure --prefix=/usr/local
    make
    make install
    popd
    rm -rf node-v0.10.32
    rm -rf node-v0.10.32.tar.gz
    popd
fi


# install mod_wsgi 3.5
if [[ ! -e /etc/httpd/modules/mod_wsgi.so ]] ; then
    pushd /tmp
    wget https://github.com/GrahamDumpleton/mod_wsgi/archive/3.5.tar.gz
    mv 3.5.tar.gz mod_wsgi-3.5.tar.gz
    tar zxvf mod_wsgi-3.5.tar.gz
    pushd mod_wsgi-3.5
    ./configure --with-python=/usr/local/bin/python2.7
    make
    make install
    popd
    rm -rf mod_wsgi-3.5 mod_wsgi-3.5.tar.gz
    # do not start until configured by bootstrap
    chkconfig httpd off
    popd
fi


# reboot so that new kernel takes effect
reboot
sleep 30
