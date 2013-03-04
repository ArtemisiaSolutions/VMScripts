#!/bin/sh

CHROOT_DIR=/home/admin/jail

REQUIRED_CHROOT_FILES=" "

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

cp /usr/lib/ld.so.1 usr/lib