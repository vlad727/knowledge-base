#!/bin/bash
#-x


# ls -l /dev/sd* | awk '{print $10}' | grep -v sda
# ls -l /dev/sd* | awk '{print $10}' | grep -v sda | grep [0-9]
echo "Script to create partitions and logical volumes for disks"
echo
echo "========================================================="
for DISK in /dev/sd{b,c,d}
do
  echo "Stage with parted begining"
  /usr/sbin/parted -s $DISK mklabel gpt mkpart primary 1MiB 400MiB mkpart primary 401MiB 801MiB
if [ $? = 0 ]
then
  echo "All partitions has been created successful"
else
  echo "Error creating partitions"
fi
done
echo "========================================================="
echo "Creating PV's stage"
echo
#DISKS=$(ls -l /dev/sd* | awk '{print $10}' | grep -v sda | grep [0-9])
for DISK in $(ls -l /dev/sd* | awk '{print $10}' | grep -v sda | grep [0-9])
do
  echo "Creating PV's for disk"
  /usr/sbin/pvcreate $DISK
if [ $? = 0 ]
then
  echo "PV's creating is successful"
else
  echo "PV's creating failed"
fi
done
echo
echo "========================================================="
echo "Creating volume groups"
echo
# vgcreate vgscript /dev/sdb1 /dev/sdb2
# vgcreate my_vg /dev/sd{b,c,d}{1,2}

vgcreate vgscript /dev/sd{b,c,d}{1,2}
echo
echo "Logical volume creating"
echo
#lvcreate lvscript{1,2,3}
for i in 1 2 3
do
lvcreate vgscript -n lvscript$i -L 500M
done

