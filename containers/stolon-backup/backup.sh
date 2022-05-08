#!/bin/bash
set -e

echo "Starting backup (${SOURCE_ENV_FILE} as environment)."

# Get secrets
source "$SOURCE_ENV_FILE"

# Mount the remote backup directory
echo "Mounting ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH} at /mnt/remote."
sshfs -p 23 "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}" /mnt/remote

# Dump all databases and roles
echo "Dumping Stolon databases."
PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -U "$POSTGRES_USER" -h "$POSTGRES_HOST" > /tmp/backup/stolon_pg_dumpall.out

# Create a new backup
echo "Creating backup of the dump."
borg create --stats /mnt/remote::stolon-dumpall-{now} "/tmp/backup/stolon_pg_dumpall.out"

# Delete temporary file
rm /tmp/backup/stolon_pg_dumpall.out

# Prune old backups
echo "Pruning existing backups."
borgbackup prune -v --keep-daily=14 --keep-weekly=8 --keep-monthly=12 /mnt/remote

# Unmount remote host
echo "Unmount /mnt/remote."
umount /mnt/remote
