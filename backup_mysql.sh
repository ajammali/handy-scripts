#!/bin/bash

# Configuration de base: datestamp e.g. YYYYMMDD

DATE=$(date +"%Y%m%a%H%M")

# Dossier où sauvegarder les backups (créez le d'abord!)

BACKUP_DIR="/root/backup/mysql"

# Identifiants MySQL

MYSQL_USER="root"
MYSQL_PASSWORD="wessa0412"

# Commandes MySQL (aucune raison de modifier ceci)

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
DB_NAME=xtream_iptvpro
# Bases de données MySQL à ignorer

SKIPDATABASES="Database|information_schema|performance_schema|mysql"

# Nombre de jours à garder les dossiers (seront effacés après X jours)

RETENTION=1

# ---- NE RIEN MODIFIER SOUS CETTE LIGNE ------------------------------------------
#
# Create a new directory into backup directory location for this date

mkdir -p $BACKUP_DIR
rm $BACKUP_DIR/*

# Retrieve a list of all databases

#databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Dumb the databases in seperate names and gzip the .sql file

## Cleanup unnecessary tables before backup
mysql -u root -p$MYSQL_PASSWORD -h localhost xtream_iptvpro -e "truncate table \`xtream_iptvpro\`.\`client_logs\`"
mysql -u root -p$MYSQL_PASSWORD -h localhost xtream_iptvpro -e "truncate table \`xtream_iptvpro\`.\`stream_logs\`"
mysql -u root -p$MYSQL_PASSWORD -h localhost xtream_iptvpro -e "truncate table \`xtream_iptvpro\`.\`user_activity\`"
#for db in $databases; do
#echo $db
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --events --databases $DB_NAME > "$BACKUP_DIR/$db_$DATE.sql"
#done

# Remove files older than X days

#find $BACKUP_DIR/* -mtime +$RETENTION -delete

sshpass -p "ADtrGjFcyaw9NfXW" scp $BACKUP_DIR/$db_$DATE.sql root@212.8.253.238:/root/ 
