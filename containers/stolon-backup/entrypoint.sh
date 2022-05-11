#!/bin/bash

echo "Started container."

# Copy and fix SSH key permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /vault/secrets/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa

if [ "$1" = "backup" ]; then
    /backup.sh
elif [ "$1" = "list" ]; then
    /list.sh
else
    echo "Invalid command ${1}. Valid command are 'backup' and 'list'."
    exit 1
fi
