#!/bin/bash
source /home/private/Projects/laptop_backup_script

# Get the current connected SSID
CURRENT_SSID=$(iwgetid -r)
if [ "$CURRENT_SSID" != "$HOME_SSID" ]; then
    echo "-----NOT AT HOME. STOPPING SCRIPT @ $(date)-----" >> $LOG_FILE
    exit 0
fi

echo "-----STARTING BACKUP @ $(date)-----" >> $LOG_FILE

echo "-----BACKING UP INSTALLED PACKAGES LIST @ $(date)-----" >> $LOG_FILE
rsync -avz -e "ssh -p $SSH_PORT" --progress "$(dpkg --get-selections)" $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH/installed-packages.txt >> $RSYNC_LOG_FILE

echo "-----BACKING UP /etc @ $(date)-----" >> $LOG_FILE
rsync -avz -e "ssh -p $SSH_PORT" --progress /etc $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $RSYNC_LOG_FILE

# private
echo "-----BACKING UP DOCUMENTS @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/private/Documents $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $RSYNC_LOG_FILE
echo "-----BACKING UP SCHOOL @ $(date)-----" >> $LOG_FILE
rsync -avz --delete --exclude={"MDN","w3schools_offline","node_modules"} -e "ssh -p $SSH_PORT" --progress /home/private/School $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $RSYNC_LOG_FILE
echo "-----BACKING UP BOOKS @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/private/Books $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $RSYNC_LOG_FILE
echo "-----BACKING UP PICTURES @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/private/Pictures $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH >> $RSYNC_LOG_FILE

# work
echo "-----BACKING UP WORK PROJECTS @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/lucas/Projects $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH/monocode/ >> $RSYNC_LOG_FILE
echo "-----BACKING UP WORK DOCUMENTS @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/lucas/Documents $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH/monocode/ >> $RSYNC_LOG_FILE
echo "-----BACKING UP WORK PICTURES @ $(date)-----" >> $LOG_FILE
rsync -avz --delete -e "ssh -p $SSH_PORT" --progress /home/lucas/Pictures $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_PATH/monocode/ >> $RSYNC_LOG_FILE

echo "-----BACKUP COMPLETED @ $(date)-----" >> $LOG_FILE
