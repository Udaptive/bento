#!/bin/sh

PACKER_VERSION=$(packer --version)
if [[ "$PACKER_VERSION" != "Packer v0.7.1" ]] ; then
    if [[ -d /usr/local/packer ]] ; then
        rm -rf /usr/local/packer
        rm -f /usr/local/bin/packer*
    fi
    pushd /tmp
    wget https://dl.bintray.com/mitchellh/packer/packer_0.7.1_linux_amd64.zip
    unzip packer_0.7.1_linux_amd64.zip -d /usr/local/packer
    for i in $(ls /usr/local/packer) ; do
        ln -s /usr/local/packer/$i /usr/local/bin/$i
    done
    rm -f packer_0.7.1_linux_amd64.zip
    popd /tmp
fi
