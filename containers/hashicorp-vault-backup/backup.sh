#!/bin/bash
set -e
source log.sh

# Backup of the integrated storage
# Data is already encrypted at rest, so this is using borg in plaintext
# https://learn.hashicorp.com/tutorials/vault/sop-backup?in=vault/standard-procedures

logline "Starting backup"

# Get secrets
source "$ENV_FILE"

# Mount the remote backup directory
logline "Mounting $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH at /tmp/remote."
sshfs -o StrictHostKeyChecking=no -p 23 "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" /tmp/remote

# Get the token
SERIVCE_ACCOUNT_TOKEN="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

# Create a new vault token
export VAULT_TOKEN=$(vault write -field=token auth/kubernetes/login jwt=$SERIVCE_ACCOUNT_TOKEN role=backup);

# Create the snapshot file
logline "Creating a new snapshot '/tmp/backup/backup-raft-snapshot'"
vault operator raft snapshot save /tmp/backup/backup-raft-snapshot

# Create a new backup
logline "Creating a new backup"
borg create --stats /tmp/remote::hashicorp-vault-raft-snapshot-{now} "/tmp/backup/backup-raft-snapshot"

# Delete temp snapshot
rm /tmp/backup/backup-raft-snapshot

# Prune repo, backup runs once a day
# Keep:
#   daily: 30
#   weekly: 16
#   monthly: 24
logline "Pruning backups"
borgbackup prune -v --keep-daily=30 --keep-weekly=16 --keep-monthly=24 /mnt/remote

# Unmount remote host
logline "Unmount /mnt/remote."
umount /mnt/remote

# Send notification
/notify.sh
