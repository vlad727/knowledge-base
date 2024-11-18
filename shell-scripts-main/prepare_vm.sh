#!/bin/bash 

# $1 username 
# $2 password
# $3 hostname

# check if user already exist
# set password for user
# add user to group wheel
if [[ $1 -eq "vlad" ]]
then echo -n "$1 already exist
Please use another name"
else useradd $1 && echo "$1:$2" | sudo chpasswd  && usermod -a -G wheel $1
fi



# set no_passwd
#cat /etc/sudoers | grep "# %wheel" | sed -e 's/# %wheel/ %vlad/g' >  /etc/sudoers.d/no_passwd
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

# set hostname
hostnamectl set-hostname $3
echo "New hostname for this sever is $3"

# install software
yum install epel-release net-tools git vim -y

# generate keys
#ssh-keygen
