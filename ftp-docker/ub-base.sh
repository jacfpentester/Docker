#!/bin/bash
set -e

newUser(){
    useradd -rm -d /home/"${USUARIO}" -s /bin/bash "${USUARIO}" 
    echo "root:${PASSWD}" | chpasswd
    echo "${USUARIO}:${PASSWD}" | chpasswd
}

newUserNoDir(){
     useradd -d /home/"${USUARIO}" -s /bin/bash "${USUARIO}" 
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

main(){
    if [ ! -d "/home/${USUARIO}" ]; then
     newUser
     config_Sudoers
     config_ssh
    fi
      if id "${USUARIO}" &> /dev/null; then
      echo " EL Usuario Existe"
      else
      newUserNoDir
      config_Sudoers
      /etc/init.d/ssh start
     fi
}

main
