#!/bin/bash
source log.sh

logline "Sending notification"

if [[ -z "$GOTIFY_TOKEN" ]] || [[ -z "$GOTIFY_ENDPOINT" ]]; then
    logline "GOTIFY_ENDPOINT or GOTIFY_TOKEN not set, skipping notification"
else
    curl -X POST "$GOTIFY_ENDPOINT/message?token=$GOTIFY_TOKEN" \
    -F "title=Hashicorp Vault backup" \
    -F "message=A new backup created at $(date)" \
    -F "priority=5"
fi
