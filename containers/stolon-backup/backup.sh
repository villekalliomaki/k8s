#!/bin/bash

# Get secrets
source "$SOURCE_ENV_FILE"

# Mount the remote backup directory
sshfs -p 23 "$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_PATH" /mnt/remote -o IdentityFile=/vault/secrets/id_rsa

# Dump all databases and roles
PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -U "$POSTGRES_USER" -h "$POSTGRES_HOST" > /tmp/backup/stolon_pg_dumpall.out

# Create a new backup
borg create --stats /mnt/remote::stolon-dumpall-{now}

# Delete temporary file
rm /tmp/backup/stolon_pg_dumpall.out

# Prune old backups
borgbackup prune -v --keep-daily=14 --keep-weekly=8 --keep-monthly=12 /mnt/remote

# Unmount remote host
umount /mnt/remote
