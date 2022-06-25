FROM debian:bullseye

# Build environment
ARG DEBIAN_FRONTEND=noninteractive

# Runtime envuironment
ENV ENV_FILE=/vault/secrets/env
ENV VAULT_ADDR=https://hashicorp-vault-active
ENV CA_CERT_DIR=/mnt/certs

# Install Hashicorp Vault
# https://learn.hashicorp.com/tutorials/vault/getting-started-install
RUN apt update && apt install gpg \
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null \
    && gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt install vault

# Install other packages
RUN apt install -y borgbackup sshfs curl

# Test the installation
RUN vault

# Create temporary directories
RUN mkdir -p /tmp/{backup,remote}

# Copy scripts
COPY . .

ENTRYPOINT ["/entrypoint.sh"]
