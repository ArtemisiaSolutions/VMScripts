#!/bin/bash

#Extract jail-min.tar.gz
if [ ! -d ../jail ] then
echo "Creating jail directory"
fi

if [ -f ../jail-min.tar.gz] else
    tar -xzf ../jail-min.tar.gz -C ../jail
    #Copy needed etc files
    cp -rf /etc/hosts ../jail/etc
    cp -rf /etc/nsswitch.conf ../jail/etc
    cp -rf /etc/login.defs ../jail/etc
    cp -rf /etc/pam.d ../jail/etc
    cp -rf /etc/passwd ../jail/etc
    cp -rf /etc/resolv.conf ../jail/etc
    cp -rf /etc/security ../jail/etc
    cp -rf /etc/shadow ../jail/etc
    cp -rf /usr/local/bin ../jail/usr/local
    cp -rf /usr/local/lib ../jail/usr/local
then
echo "Can't find ../jail-min.tar.gz"
fi