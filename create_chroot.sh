#!/bin/sh

if [ -z "$1" ] ; then
  echo "ERROR: Parameter missing. Did you forget the username?"
  echo "-------------------------------------------------------------"
  echo "USAGE:"
  echo "Create new chrooted user"
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

SHELL="/bin/chroot-shell"

TARFILE="/home/admin/jail.tar.gz"

#Create jail strucutre
if [ ! -d "$JAILROOT" ]; then
    mkdir $JAILROOT
fi

if [ ! -d "$JAILPATH" ]; then
    mkdir $JAILPATH
    if [ -d "$JAILPATH" ]; then
        #Extract jail structure
        if [  -f "$TARFILE" ]; then
            cd $JAILPATH; tar -xzf $TARFILE;
            
            mount -o bind /usr/lib $JAILPATH/usr/lib
            mount -o bind /lib $JAILPATH/lib
            mount -o bind /usr/lib64 $JAILPATH/usr/lib64
            mount -o bind /lib64 $JAILPATH/lib64
            #mount -o bind /usr/libexec $JAILPATH/usr/libexec
            mount -o bind /usr/include $JAILPATH/usr/include
            mount -o bind /usr/local/include $JAILPATH/usr/local/include

            #Create tempdir
            mkdir $JAILPATH/tmp
            chmod 777 $JAILPATH/tmp

            #Add user to system
            if ( ! id $CHROOT_USERNAME > /dev/null 2>&1 ) ; then 
                echo "Adding User \"$CHROOT_USERNAME\" to system"
                #saR91KK14eDFY =>  perl -e 'print crypt("nodeci", "salt"),"\n"'
                useradd -m -d "$HOMEDIR" -s "$SHELL" -p "saR91KK14eDFY" $CHROOT_USERNAME && chmod 700 "$HOMEDIR"
                
                #Modifying /etc/sudoers
                echo "$CHROOT_USERNAME       ALL=NOPASSWD: `which chroot`, /bin/su - $CHROOT_USERNAME" >> /etc/sudoers

                # Create /usr/bin/groups in the jail
                echo "#!/bin/bash" > usr/bin/groups
                echo "id -Gn" >> usr/bin/groups
                chmod 755 usr/bin/groups

                # Add users to etc/passwd
                #
                # check if file exists (ie we are not called for the first time)
                # if yes skip root's entry and do not overwrite the file
                if [ ! -f etc/passwd ] ; then
                     grep /etc/passwd -e "^root" > ${JAILPATH}/etc/passwd
                fi
                if [ ! -f etc/group ] ; then
                    grep /etc/group -e "^root" > ${JAILPATH}/etc/group
                    # add the group for all users to etc/group (otherwise there is a nasty error
                    # message and probably because of that changing directories doesn't work with
                    # winSCP)
                    grep /etc/group -e "^users" >> ${JAILPATH}/etc/group
                fi

                # grep the username which was given to us from /etc/passwd and add it
                # to ./etc/passwd replacing the $HOME with the directory as it will then 
                # appear in the jail
                echo "Adding User $CHROOT_USERNAME to jail"
                grep -e "^$CHROOT_USERNAME:" /etc/passwd | \
                 sed -e "s#$JAILPATH##"      \
                     -e "s#$SHELL#/bin/bash#"  >> ${JAILPATH}/etc/passwd

                # if the system uses one account/one group we write the
                # account's group to etc/group
                grep -e "^$CHROOT_USERNAME:" /etc/group >> ${JAILPATH}/etc/group

                # write the user's line from /etc/shadow to /home/jail/etc/shadow
                grep -e "^$CHROOT_USERNAME:" /etc/shadow >> ${JAILPATH}/etc/shadow
                chmod 600 ${JAILPATH}/etc/shadow
            fi
        fi
    fi
fi
