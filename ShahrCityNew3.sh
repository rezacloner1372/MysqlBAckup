
##########please make these directory#############
#mkdir last					 #	
#mkdir Backup-last				 #
#mkdir Backup-old				 #
#mkdir /BACKUP_old/weekly 			 #
#mkdir /BACKUP_old/monthly			 #
##################################################

#!/bin/bash
BACKUP_last="/Backup-last"
BACKUP_old="/Backup-old"
TODAY=$(date +"%Y-%m-%d")
MYSQL_USER="root"
MYSQL_PASSWORD="YOUR PASSWORD"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
DAILY_DELETE_NAME="daily-"`date +"%Y-%m-%d" --date '7 days ago'`
WEEKLY_DELETE_NAME="weekly-"`date +"%Y-%m-%d" --date '4 weeks ago'`
MONTHLY_DELETE_NAME="monthly-"`date +"%Y-%m-%d" --date '12 months ago'`
DB="YOUR DATABASE NAME"

# redirect stdout/stderr to a file
exec &> /var/log/logfile.log

mv -v $BACKUP_last/* $BACKUP_old

# run dump
echo " ***running dump*** "

if [ -f "$BACKUP_old/$DAILY_DELETE_NAME.sql" ]; then
    echo " moving weekly files "
    mv -v $BACKUP_old/$DAILY_DELETE_NAME.sql $BACKUP_old/weekly 
    mv -v $BACKUP_old/$DAILY_DELETE_NAME.txt $BACKUP_old/weekly 
  fi
if [ -f "$BACKUP_old/$MONTHLY_DELETE_NAME.sql" ]; then
    echo " moving monthly files "
    mv -v $BACKUP_old/$MONTHLY_DELETE_NAME.sql $BACKUP_old/monthly
    mv -v $BACKUP_old/$MONTHLY_DELETE_NAME.txt $BACKUP_old/monthly
  fi

mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD --single-transaction --quick --lock-tables=false $DB > $BACKUP_last/daily-$TODAY.sql
echo "daily-$TODAY.sql has been created"

#create HASH
md5sum $BACKUP_last/daily-$TODAY.sql > $BACKUP_last/daily-$TODAY.txt
echo "Hash $BACKUP_last/daily-$TODAY.txt has been created"  

