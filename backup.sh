#!/bin/bash

WORK_DIR=/home/private/Projects/laptop_backup_script

source $WORK_DIR/.env

# Get the current connected SSID
CURRENT_SSID=$(iwgetid -r)
if [ "$CURRENT_SSID" != "$HOME_SSID" ]; then
    echo "-----NOT AT HOME. STOPPING SCRIPT @ $(date)-----" >> $LOG_FILE
    exit 0
fi

echo "-----STARTING BACKUP @ $(date)-----" >> $LOG_FILE

# Backup installed packages list
dpkg --get-selections > $WORK_DIR/installed_packages.txt
rsync -avz -e "ssh -p $SSH_PORT" --progress $WORK_DIR/installed_packages.txt $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $LOG_FILE

# Backup local files
for dir in ${LOCAL_TO_BE_BACKED_UP[@]}; do
    echo "Backing up $dir @ $(date)" >> $LOG_FILE
    rsync -avz --delete -e "ssh -p $SSH_PORT" --progress $dir $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $LOG_FILE
    echo "Backup of $dir completed @ $(date)" >> $LOG_FILE
done

echo "-----BACKUP COMPLETED @ $(date)-----" >> $LOG_FILE
