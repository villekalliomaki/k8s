#!/bin/bash
source log.sh

# Backup of the integrated storage
# Data is already encrypted at rest, so this is using borg in plaintext
# https://learn.hashicorp.com/tutorials/vault/sop-backup?in=vault/standard-procedures

logline "Starting backup"

# 

# Create the snapshot file
vault operator raft snapshot save /tmp/backup/backup-raft-snapshot