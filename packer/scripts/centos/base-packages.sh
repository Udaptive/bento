#!/bin/sh

# update YUM before anything else
yum clean all
yum upgrade -y yum yum-plugin-fastestmirror

# enable EPEL repositories
if [[ ! -e /etc/yum.repos.d/epel.repo ]] ; then
    pushd /tmp
    yum install wget -y
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    rpm -Uvh epel-release-6*.rpm
    rm -f epel-release-6*.rpm
    popd
fi
yum makecache -y

# upgrade existing packages
yum upgrade -y

# install development tools
yum groupinstall "Development tools" -y

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
lynx
man
mlocate
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
telnet
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


# install git 2.1.1
GIT_VERSION=`git --version`
if [[ "$GIT_VERSION" != "git version 2.1.1" ]] ; then
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
if [[ "$PYTHON_VERSION" != "Python 2.7.8" ]] ; then
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
    rm -f setuptools-*.zip
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    /usr/local/bin/python2.7 get-pip.py
    rm -f get-pip.py
    popd
fi


# add /usr/local/bin to system path
if [[ ! -e "/etc/profile.d/local_path.sh" ]] ; then
    echo 'pathmunge /usr/local/bin' > /etc/profile.d/local_path.sh
    chmod 644 /etc/profile.d/local_path.sh
fi


# disable MTA, we use SES for outbound mail
postfix stop
chkconfig postfix off
