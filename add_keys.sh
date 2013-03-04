#!/bin/sh

if [ -z "$1" ] ; then
  echo "ERROR: Parameter missing. Did you forget the username?"
  echo "-------------------------------------------------------------"
  echo "USAGE:"
  echo "Add key to chrooted user"
  echo "-> $0 username"
  echo
  exit
fi

CHROOT_USERNAME=$1
JAILROOT="/jail"

if [ -d "/media/ephemeral0" ]; then
    JAILROOT="/media/ephemeral0"
fi

JAILPATH="$JAILROOT/$CHROOT_USERNAME"
HOMEDIR="$JAILPATH/home/$CHROOT_USERNAME"

mkdir $HOMEDIR/.ssh
cp /home/admin/.ssh/authorized_keys $HOMEDIR/.ssh
chown -R $1:$1 $HOMEDIR/.ssh
chmod 700 $HOMEDIR/.ssh
chmod 600 $HOMEDIR/.ssh/*
exit
