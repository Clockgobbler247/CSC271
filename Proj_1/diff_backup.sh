#!/bin/bash
####################################
#
# Backup to /dev/sdc 75GB Backup Drive mounted to /backups
#
####################################

# What to backup. 

backup_files="/"

# Where to backup to

dest="/backups/sys_backup/diff_backup/"


# Create archive filename

day=$(date +%m_%d_%Y)


hostname=$(hostname -s)


archive_file="$hostname-$day-diff"

full_backup="/backups/sys_backup/full_backup/new/Team-A-Full_sys_backup"


# Print variable values for debugging

echo "dest: $dest"


echo "archive_file: $archive_file"


#Create Directory for backup
sudo mkdir $dest/$archive_file


# Print start status message.

echo "Backing up $backup_files to $dest/$archive_file"

date

echo

# Backup the files using tar.
#tar czf $dest/$archive_file $backup_files

sudo rsync -aAXHv --link-dest=$full_backup --delete --exclude=/etc/scripts/* --exclude=/dev/* --exclude=/proc/* --exclude=/backups/* --exclude=/home/* --exclude=/sys/* --exclude=/tmp/* --exclude=/run/* --exclude=/mnt/* --exclude=/media/* --exclude="swapfile" --exclude="lost+found" --exclude=".cache" --exclude="Downloads" --exclude=".VirtualBoxVMs" --exclude=".ecryptfs" $backup_files $dest/$archive_file

echo

echo "Backup finished"

date

# Long listing of files in $dest to check file sizes.

ls -lh $dest
