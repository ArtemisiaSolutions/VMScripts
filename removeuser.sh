#!/bin/sh

if [ -z "$1" ] ; then
  echo "ERROR: Parameter missing. Did you forget the username?"
  echo "-------------------------------------------------------------"
  echo "USAGE:"
  echo "Delete chrooted user"
  echo "-> $0 username"
  echo
  exit
fi

CHROOT_USERNAME=$1
JAILROOT="/jail"

if [ -d "/media/internalStorage" ]; then
    JAILROOT="/media/internalStorage"
fi

JAILPATH="$JAILROOT/$CHROOT_USERNAME"
HOMEDIR="$JAILPATH/home/$CHROOT_USERNAME"

LEN=$(echo ${#CHROOT_USERNAME})

if [ $LEN -gt 31 ]; then
    pkill -u $CHROOT_USERNAME

    #Unmount all folder
    echo "Unmounting folder"
    umount $JAILPATH/usr/lib
    umount $JAILPATH/lib
    umount $JAILPATH/usr/lib64
    umount $JAILPATH/lib64
    #umount $JAILPATH/usr/libexec
    umount $JAILPATH/usr/include
    umount $JAILPATH/usr/local/include

    #Deleting user from system
    echo "Deleting user from system"
    userdel $CHROOT_USERNAME

    #Removing entry from sudoers
    echo "Deleting user from jail"
    rm -rf /tmp/sed_sudoers
    sed "/$CHROOT_USERNAME       ALL=NOPASSWD: \/usr\/sbin\/chroot, \/bin\/su - $CHROOT_USERNAME/d" /etc/sudoers  >> /tmp/sed_sudoers
    cp -rf /tmp/sed_sudoers /etc/sudoers

    sleep 2
    #Removing jail
    echo "Removing jail"
    if [ "$(ls -A $JAILPATH/usr/lib)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
        exit
    else
        if [ "$(ls -A $JAILPATH/lib)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
    exit
    else
        if [ "$(ls -A $JAILPATH/usr/lib64)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
    exit
    else
        if [ "$(ls -A $JAILPATH/lib64)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
    exit
    else
        if [ "$(ls -A $JAILPATH/usr/libexec)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
    exit
    else
        if [ "$(ls -A $JAILPATH/usr/include)" ]; then
        echo "Mounted folders are not empty. Can't delete jail"
    exit
    else
        rm -rf $JAILPATH
        echo "Empty"    
    fi
    fi
    fi
    fi
    fi
    fi
fi
