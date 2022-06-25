#!/bin/bash
set -e

source log.sh

logline "Started container"

# Import TLS certs for the vault client
logline "Importing certs"
cp /mnt/certs/. /usr/local/share/ca-certificates
update-ca-certificates

# Copy SSH private key, for the remote host
logline "Copying over SSH private key"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /vault/secrets/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa

/backup.sh
