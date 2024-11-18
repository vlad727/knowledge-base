#!/bin/bash

# delete partitions on sdb disks
PARTITIONS=$(ls -l  /dev/ | grep sdb | awk '{print $10}' | tail -n +2 |  sed -e 's/^sdb//')
MOUNTED=$(mount | grep sdb | awk '{print $1}')

# need to add while for cicle
# umount devices 
for i in $MOUNTED;
do umount $MOUNTED
done 

# remove partitions
for i in $PARTITIONS;
do  mount | parted -s /dev/sdb rm $i 
done

