#!/bin/bash

#  That script allow:
#  create copy base on the same server for tests
#  show backup files in backup directory
#  unpack backup file unpigz
#  restore base from backup file to empty base
#  show postgresql databases on local server
#  rename databases
#  delete unused databases
#  create empty base for future restore from backup file
#  create backup database
#===================================================================================================================
# description for options
COMMON_HELP="\n Скрипт для управления базами данных на сервере $HOSTNAME \n
\n
Введите режим работы: \n
show_db\t\t     отобразить список баз данных на сервере $HOSTNAME \n
create_copy\t\t        создать копию базы данных \n
show_backups\t\t       отобразить список бэкапов \n
unpack_db\t\t        разархивировать бэкап файл \n
empty_db\t\t         создать пустую базу для будущего восстановления \n
drop_db\t\t          удалить базу данных \n
restore_db\t\t       восстановить базу данных из бэкапа \n
rename_db\t\t        переименовать базу данных \n
create_backup\t\t      создать бэкап базы данных \n
backup_remoute\t\t      создать бэкап базы данных на удалнный сервер \n
\n
examples:\n ./manage_bases.sh unpack_base\n bash manage_bases.sh rename_base \n"


#===================================================================================================================
# functions
backup_func() {
sudo mount -t cifs -o username=share //win10/share_win10 /mnt -o credentials=/root/credentials,file_mode=0777,dir_mode=0777 >> /dev/null

if  mount | grep mnt >> /dev/null;
then
  echo "Server backup mounted"
else
  echo "Failed to mount remoute folder"
fi
# start backup for db
#echo "Please input database name for this action"
# ask for base name
read -r -p "Please input database name: " db_name
# mount dir to /mnt and send db to remoute server
/usr/bin/pg_dump -U postgres  $db_name | pigz > /mnt/$(date +"%Y-%m-%d_%H-%M").$db_name.sql.gz


if [ $? = 0 ]
  then
    echo "Succesed backup"
else
  echo "Error backup files!"
fi

sudo umount /mnt

}
#  show help info
if [[ $# -eq 0 ]]; then
        echo -e $COMMON_HELP
fi

#===================================================================================================================
# case and conditionals
case "$1" in
"--help")
        echo -e $COMMON_HELP
;;
"-h")
        echo -e $COMMON_HELP
;;
"show_db")
       psql -U postgres -c '\l+' |  awk '{print $1 "      " $12 $13}' | grep -v "|\|template*\|postgres\|(8" | sed 1,2d; 


#;;
#"show_db_size")
#        psql -U postgres -c '\l+'


;;
"create_copy")
        echo "Input source base name:"
                read srcbase
                        echo "Input destination base name:"
                                read dstbase
                                        echo "Source base name  $srcbase"
                                                echo "Destination base name $dstbase"
                                                        psql -U postgres -c "CREATE DATABASE $dstbase TEMPLATE $srcbase;"
;;

"show_backups")
        echo "Размер | месяц | число | время создания бэкапа | файл бэкапа "
                ls -lh  /backup_disk/backups/ | awk '{print $5 "      " $6 "      " $7 "      " $8 "                  " $9}'
;;

"unpack_db")
        echo "Input file source name: "
                read srcfile
                        echo "Unpack process may take for 15 min"
                                unpigz /backup_disk/backups/$srcfile
                                        echo "File is unpacked! Run again "show_backups" to get new file name"
;;

"empty_db")
        echo "Input name for new empty database: "
                read new_database
                        psql -U  postgres -c "CREATE DATABASE  $new_database;"
                                echo "Empty base has been created with name $new_database"
;;

"rename_db")
        echo "Pleas input database name which one do you want to rename: "
                read old_name
                        echo "Please new name for database"
                                read new_name
                                        psql -U  postgres -c "ALTER DATABASE $old_name RENAME TO $new_name;"
                                                echo "Base has been renamed, please check for new name"
;;
"drop_db")
        echo "Input name database which one do you want to drop: "
                read drop_name
                        psql -U postgres -c "DROP DATABASE $drop_name;"
                                echo "Base with name $drop_name has been dropped"
;;

"restore_db")
        echo "Input backup file name: "
                read file_name
                        echo "Input empty base name: "
                                read empty_base_name
                                        psql -U postgres $empty_base_name < /backup_disk/backups/$file_name
;;

"create_backup")
        echo "Input base name: "
                read file_name
                        pg_dump -U postgres -c $file_name | pigz > /backup_disk/backups/$(date +"%Y-%m-%d_%H-%M").$file_name.sql.gz
                                echo "Backup for base $file_name has been created"
;;
"backup_remoute")
  echo "It will create backup to remoute server"
    backup_func
;;


esac

#===================================================================================================================
# backup to the server backup
