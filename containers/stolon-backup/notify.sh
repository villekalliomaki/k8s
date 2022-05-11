#!/bin/bash

echo "Sending notification."

if [[ -z "${GOTIFY_TOKEN}" ]] || [[ -z "${GOTIFY_ENDPOINT}" ]]; then
    echo "GOTIFY_ENDPOINT or GOTIFY_TOKEN not set, skipping notification."
else
    curl \
        -X POST \
        -H "X-Gotify-Key: ${GOTIFY_TOKEN}" \
        -H "Content-Type: application/json" \
        -d '{"priority": 1, "title": "Stolon Backup Created", "message": '"$(cat /tmp/msg | jq -aRs .)"'}' \
        "${GOTIFY_ENDPOINT}/message"
fi
