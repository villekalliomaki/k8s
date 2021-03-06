#!/bin/bash

echo "Sending notification."

if [[ -z "${GOTIFY_TOKEN}" ]] || [[ -z "${GOTIFY_ENDPOINT}" ]]; then
    echo "GOTIFY_ENDPOINT or GOTIFY_TOKEN not set, skipping notification."
else
    curl -X POST "http://gotify/message?token=${GOTIFY_TOKEN}" \
    -F "title=New Stolon backup created" \
    -F "message=A new backup created at $(date)" \
    -F "priority=6"
fi
