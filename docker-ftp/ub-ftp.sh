#!/bin/bash

set -e


newUser(){
     useradd -rm -d /home/"${USUARIO}" -s /bin/bash "${USUARIO}" 
     echo "root:${PASSWD}" | chpasswd
     echo "${USUARIO}:${PASSWD}" | chpasswd
 }

config_Sudoers(){
     echo "${USUARIO} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
 }

config_ssh(){
     sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
     sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
     if [ ! -d /home/${USUARIO}/.ssh ]
     then
         mkdir /home/${USUARIO}/.ssh
         cat /root/id_rsa.pub >> /home/${USUARIO}/.ssh/authorized_keys
     fi
    /etc/init.d/ssh start
 }




ftp_conf(){
cd /etc/proftpd/
sed -i "s/^ServerName .*$/ServerName ${SERVERNAME}/" proftpd.conf
sed -i "s/^ServerType .*$/ServerType ${SERVERTYPE}/" proftpd.conf
sed -i "s/^ShowSymlinks .*$/ShowSymlinks ${SHOWSYMLINKS}/" proftpd.conf
sed -i "s/^TimeoutIdle .*$/TimeoutIdle ${TIMEOUTIDLE}/" proftpd.conf
sed -i "s/^Port .*$/Port ${PORTFTP}/" proftpd.conf
sed -i "s/^MaxInstances .*$/MaxInstances ${MAXINSTANCES}/" proftpd.conf
sed -i "s/^Umask .*$/Umask ${UMASK}/" proftpd.conf
sed -i "s/^User .*$/User ${USERFTPDEF}/" proftpd.conf
sed -i "s/^Group .*$/Group ${GROUPFTPDEF}/" proftpd.conf
sed -i "/DefaultRoot/c DefaultRoot ${DEFAULTROOT}" proftpd.conf
service proftpd stop
service proftpd start
tail -f >/dev/null
}

main(){
if [ ! -d "/home/${USUARIO}" ]
  then
  newUser
  config_Sudoers
  config_ssh
fi
  ftp_conf
}

main
