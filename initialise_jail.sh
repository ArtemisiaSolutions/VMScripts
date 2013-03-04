#!/bin/bash

  #Extract jail-min.tar.gz
  if [ ! -d /home/admin/jail ]; then
  echo "Creating jail directory";
  fi

  if [ -f ./jail-min.tar.gz ]; then
      tar -xzf ./jail-min.tar.gz -C /home/admin/jail;
      #Copy needed etc files
      cp -rf /etc/hosts /home/admin/jail/etc;
      cp -rf /etc/nsswitch.conf /home/admin/jail/etc;
      cp -rf /etc/login.defs /home/admin/jail/etc;
      cp -rf /etc/pam.d /home/admin/jail/etc;
      cp -rf /etc/passwd /home/admin/jail/etc;
      cp -rf /etc/resolv.conf /home/admin/jail/etc;
      cp -rf /etc/security /home/admin/jail/etc;
      cp -rf /etc/shadow /home/admin/jail/etc;
      cp -rf /usr/local/bin /home/admin/jail/usr/local;
      cp -rf /usr/local/lib /home/admin/jail/usr/local;
  else
  echo "Can't find ./jail-min.tar.gz";
  fi
