FROM debian:bookworm

# Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV SOURCE_ENV_FILE=/vault/secrets/env

# Copy scripts
COPY . .

# Install packages
RUN apt update && apt -y upgrade && apt install -y borgbackup postgresql-client sshfs curl jq && rm -rf /var/lib/apt/lists/*

# Temporary backup directory before data encryption
RUN mkdir /tmp/backup

# Create remote mountpoint
RUN mkdir /mnt/remote

ENTRYPOINT ["bash", "-c", "/entrypoint.sh"]
