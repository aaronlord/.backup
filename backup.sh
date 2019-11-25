#!/bin/bash

USER=$1
UUID=$2
EXCLUDE=$3

if [[ -n "$USER" && -n "$UUID" ]]; then
    # mount the drive by uuid
    sudo -i -u $USER udisksctl mount --block-device /dev/disk/by-uuid/$UUID > /dev/null 2>&1

    # check if the device is mounted
    MOUNTPOINT=$(lsblk -o UUID,MOUNTPOINT | awk -v u="$UUID" '$1 == u {print $2}')

    if [[ -n $MOUNTPOINT ]]; then
        SRC=$(sudo -i -u $USER echo \$HOME)/
        DEST=$MOUNTPOINT/Backups/$HOSTNAME/
        DATE=`date +%Y-%m-%d`

        # create the destination folder and exclude-file
        mkdir -p $DEST$DATE

        # rsync
        /usr/bin/rsync -vaH --delete \
            --exclude-from=$EXCLUDE \
            $SRC $DEST$DATE \
            > $DEST/$DATE.log 2>&1

        # move the log into the backup directory
        mv $DEST/$DATE.log $DEST$DATE/backup.log

        # cleanup old directories
        ls -d $DEST*/ \
            | grep -P "\d{4}-\d{2}-\d{2}" \
            | sort -r \
            | tail -n +8 \
            | xargs rm -rf
    fi
fi
