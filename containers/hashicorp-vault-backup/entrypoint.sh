#!/bin/bash
set -e

source log.sh

# Import TLS certs for the vault client
logline "Importing certs"
cp /mnt/certs/. /usr/local/share/ca-certificates
update-ca-certificates

/backup.sh
