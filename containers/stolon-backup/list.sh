#!/bin/bash

# Get secrets
source "$SOURCE_ENV_FILE"

# Mount the remote backup directory
sshfs -p 23 "$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_PATH" /mnt/remote -o IdentityFile=/vault/secrets/id_rsa

# List repository stats
borg list /mnt/remote

# Unmount remote host
umount /mnt/remote