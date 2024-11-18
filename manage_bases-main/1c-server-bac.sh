#!/bin/sh

#set -x

### determine which on base we will backup ###
for i in $@
do
	echo "Backup for base with name $i will be created"
done


### place for backups ###
BAC_DIR=/backup_disk/backups


### redirect output to log file ###
echo "-------------------------------------------" | tee -a $BAC_DIR/backup.log


### redirect output with timestamp to log file ###
echo "`date +"%d-%m-%Y_%H-%M-%S"` Start backup" | tee -a  $BAC_DIR/backup.log


### determine the oldest file in dir backup ###
#OLD_FILE=$(ls -lt $BAC_DIR | grep $@ | awk  '{print $9}' | tail -1)


### show oldets files ###
#echo "$OLD_FILE file will be removed"  >> $BAC_DIR/backup.log


### remove oldes file ###
for i in $@ 
do
	OLD_FILE=$(ls -lt $BAC_DIR | tail -1 | grep $i | awk '{print $9}')
	find $BAC_DIR -type f -name $OLD_FILE | xargs rm -f
done


### do dackup files to place for backups ###
for i in $@
do
	/usr/bin/pg_dump -U postgres $i | pigz > $BAC_DIR/$(date +"%d-%m-%Y_%H-%M").$i.sql.gz
done


# message to backup.log about finish ###
echo "`date +"%d-%m-%Y_%H-%M-%S"` Finish  backup" | tee -a  $BAC_DIR/backup.log
