# upgrade existing packages
yum upgrade -y

# install development tools
yum groupinstall "Development tools" -y

# enable EPEL repositories
if [[ ! -e /etc/yum.repos.d/epel.repo ]] ; then
    pushd /tmp
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    rpm -Uvh epel-release-6*.rpm
    rm -f epel-release-6*.rpm
    yum check-update -y
    popd
fi

# install individual packages
cat <<EOF | xargs yum install -y
asciidoc
autoconf
bind-utils
bzip2
bzip2-devel
curl
curl-devel
db4-devel
dos2unix
expat-devel
expect
gcc-c++
gdbm-devel
glibc-devel
gmp-devel
httpd
httpd-devel
libevent
libffi-devel
libGL-devel
libjpeg-turbo
libjpeg-turbo-devel
libtiff-devel
libX11-devel
libxml2
libxml2-devel
libxml2-python
libxslt
libxslt-devel
libxslt-python
libzip-devel
man
mlocate
mod_ssl
mod_xsendfile
ncurses-devel
net-tools
ntp
ntpdate
openssl-devel
perl-ExtUtils-MakeMaker
perl-XML-XPath
perl-XML-DOM-XPath
pkgconfig
python-devel
readline-devel
screen
sqlite-devel
sysstat
tar
tcl-devel
tix
tix-devel
tk
tk-devel
tmux
traceroute
unix2dos
unzip
valgrind-devel
vim
wget
xmlto
yum-security
zlib-devel
EOF


# install mysql latest
pushd /tmp
if [[ ! -e /etc/yum.repos.d/mysql-community.repo ]] ; then
    wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    rpm -Uvh mysql-community-release-el6-5.noarch.rpm
    rm -f mysql-community-release-el6-5.noarch.rpm
    yum check-update -y
fi
yum install -y mysql-community-server mysql-community-devel
# do not start until configured by bootstrap
chkconfig mysqld off
popd


# install mongodb 2.6.4
MONGO_VERSION=`mongod --version | grep "db version"`
if [ "$MONGO_VERSION" != "db version v2.6.4" ] ; then
    cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
    yum check-update -y
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


# install git 2.1.1
GIT_VERSION=`git --version`
if [ "$GIT_VERSION" != "git version 2.1.1" ] ; then
    pushd /tmp
    git clone git://github.com/git/git
    cd git
    git checkout v2.1.1
    make configure
    ./configure --prefix=/usr/local
    make all
    make install
    cd ..
    rm -rf git
    popd
fi


# install python 2.7.8
PYTHON_VERSION=`python -V 2>&1`
if [ "$PYTHON_VERSION" != "Python 2.7.8" ] ; then
    pushd /tmp
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
    tar xfz Python-2.7.8.tgz
    pushd Python-2.7.8
    ./configure --enable-shared --with-threads
    make
    make install
    echo "/usr/local/lib" | tee -a /etc/ld.so.conf.d/python2.7.conf
    ldconfig
    popd
    rm -rf Python-2.7.8 Python-2.7.8.tgz
    popd

    # install easy_install and pip
    pushd /tmp
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
    /usr/local/bin/python2.7 ez_setup.py
    rm -f ez_setup.py
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    /usr/local/bin/python2.7 get-pip.py
    rm -f get-pip.py
    popd
fi


# install nodejs 0.10.32
NODE_VERSION=`node --version`
if [ "$NODE_VERSION" != "v0.10.32" ] ; then
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
