FROM debian:bookworm

# Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV SOURCE_ENV_FILE=/vault/secrets/env

# Copy scripts
COPY . .

# Install packages
RUN apt update && apt -y upgrade && apt install -y borgbackup postgresql-client sshfs && rm -rf /var/lib/apt/lists/*

# Temporary backup directory before data encryption
RUN mkdir /tmp/backup

CMD ["bash", "-c", "/entrypoint.sh"]