#!/bin/bash

echo "Started container."

# Copy and fix SSH key permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /vault/secrets/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa

/backup.sh
