#!/bin/bash

if [ $# -lt 2 ]
then
 echo "usage: $0 <jail-folder> <binary> [<binary> ...]" >&2
 exit 1
fi

TARGETDIR="$1"
if [ ! -d "$TARGETDIR" ]
then
 echo "target folder $TARGETDIR does not exist" >&2
 exit 1
fi

shift 1

if [ -z "$KEEP_LINKS" ]
then
 CPIO_ARGS="-L"
else
 CPIO_ARGS=""
fi

transfer()
{
 echo "$1" | cpio -p --preserve-modification-time --make-directories $CPIO_ARGS "$TARGETDIR" &>/dev/null
 if [ $? -ne 0 ]
 then
  echo "failed" >&2
  exit 2
 else
  echo "ok" >&2
 fi
}

qualifyLink()
{
 DEREF=`readlink "$1"`
 DIRNAME=`dirname "$1"`

 echo "$DIRNAME/$DEREF"
}

transferLL()
{
 for LIBRARY in `ldd "$1" | grep -e '(0x' | awk '{if($2=="=>")print $3;else print $1}'`
 do
  echo -n "$2 - depends on $LIBRARY ... " >&2
  transfer "$LIBRARY"

  if [ -n "$KEEP_LINKS" ]
  then
   LINKED="$LIBRARY"
   while [ -L "$LINKED" ]
   do
    LINKED=`qualifyLink "$LINKED"`
    echo -n "$2    - linked with $LINKED ... " >&2
    transfer "$LINKED"
   done
  fi

  if [ -L "$LIBRARY" ]
  then
   LIBRARY=`qualifyLink "$LIBRARY"`
  fi

  transferLL "$LIBRARY" "$2   "
 done
}

HAS_BINARY=0

for NAME in "$@"
do
 if [ "${NAME#*/}" = "$NAME" -a "${NAME%/*}" = "$NAME" ]
 then
  TYPE="binary"
  REALPATH=`which "$NAME" 2>/dev/null`
 elif [ ! -e "$NAME" ]
 then
  echo "ignoring $NAME - not found" >&2
  continue
 else
  REALPATH="$NAME"

  file "$NAME" 2>/dev/null | grep " ELF " &>/dev/null
  if [ $? -eq 0 ]
  then
   TYPE="binary"
  elif [ -d "$NAME" ]
  then
   TYPE="folder"
  elif [ -b "$NAME" -o -c "$NAME" ]
  then
   TYPE="device"
  elif [ -S "$NAME" ]
  then
   TYPE="socket"
  else
   TYPE="file"
  fi
 fi

 echo -n "processing $TYPE $REALPATH ... " >&2
 transfer "$REALPATH"

 if [ "$TYPE" = "binary" ]
 then
  HAS_BINARY=1
  transferLL "$REALPATH"
 fi
done

if [ $HAS_BINARY -ne 0 ]
then
 echo -n "integrating ld cache ... "
 transfer /etc/ld.so.cache
 echo -n "integrating ld configuration ... "
 transfer /etc/ld.so.conf
fi