#!/bin/sh

CHROOT_DIR=/home/admin/jail

REQUIRED_CHROOT_FILES="/bin/bash\
                       /bin/cat\
                       /bin/chmod\
                       /bin/chown\
                       /bin/cp\
                       /bin/grep\
                       /bin/gzip\
                       /bin/ls\
                       /bin/mkdir\
                       /bin/mv\
                       /bin/ping\
                       /bin/rm\
                       /bin/rmdir\
                       /bin/sed\
                       /bin/sh\
                       /bin/su\
                       /bin/tar\
                       /bin/touch\
                       /usr/bin/ar\
                       /usr/bin/as\
                       /usr/bin/dircolors\
                       /usr/bin/dirname\
                       /usr/bin/env\
                       /usr/bin/find\
                       /usr/bin/flock\
                       /usr/bin/g++\
                       /usr/bin/gcc\
                       /usr/bin/git\
                       /usr/bin/groups\
                       /usr/bin/id\
                       /usr/bin/ld\
                       /usr/bin/make\
                       /usr/bin/gmake\
                       /usr/bin/openssl\
                       /usr/bin/printf\
                       /usr/bin/python\
                       /usr/bin/rsync\
                       /usr/bin/scp\
                       /usr/bin/ssh\
                       /usr/bin/unlink\
                       /usr/bin/xargs"

cd $CHROOT_DIR

# Copy $REQUIRED_CHROOT_FILES and shared library dependencies
# to chroot environment

for FILE in $REQUIRED_CHROOT_FILES
do
   DIR=`dirname $FILE | cut -c2-`
   [ ! -d $DIR ] && mkdir -p $DIR
   cp $FILE `echo $FILE | cut -c2-`
   for SHARED_LIBRARY in `ldd $FILE | awk '{print $NF}'`
   do
      DIR=`dirname $SHARED_LIBRARY | cut -c2-`
      [ ! -d $DIR ] && mkdir -p $DIR
      [ ! -s "`echo $SHARED_LIBRARY | cut -c2-`" ] && \
      cp $SHARED_LIBRARY `echo $SHARED_LIBRARY | cut -c2-`
   done
done