#!/bin/bash

set -e
bash /root/ub-base.sh



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
  ftp_conf
}

main
