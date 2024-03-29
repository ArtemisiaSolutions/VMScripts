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

if [ -d "/media/internalStorage" ]; then
    JAILROOT="/media/internalStorage"
fi

JAILPATH="$JAILROOT/$CHROOT_USERNAME"
HOMEDIR="$JAILPATH/home/$CHROOT_USERNAME"

mkdir $HOMEDIR/.ssh
cp /home/admin/.ssh/authorized_keys $HOMEDIR/.ssh
chown -R $1:$1 $HOMEDIR/.ssh
chmod 700 $HOMEDIR/.ssh
chmod 600 $HOMEDIR/.ssh/*
cat <<EOF >$HOMEDIR/.ssh/config
Host github.com
    StrictHostKeyChecking no
Host bitbucket.org
    StrictHostKeyChecking no
EOF
chown -R $1:$1 $HOMEDIR/.ssh
exit
