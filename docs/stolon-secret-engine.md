# Hashicorp Vault secret engine

Stolon credentials are rotated by Vault.

[Vault Docs](https://www.vaultproject.io/docs/secrets/databases/postgresql)

[Static roles](https://learn.hashicorp.com/tutorials/vault/database-creds-rotation)

## Installation

Enable secret engine and configure access.

```sh
vault secrets enable database

# Username and password will be formatted to the connection URL.
# Only replace the key values.
vault write database/config/stolon_prod \
    plugin_name=postgresql-database-plugin \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@stolon-proxy:5432/postgres?sslmode=disable" \
    username="replace_this" \
    password="replace_this"
```

## Creating a database role

Database roles are static, and only their password is rotated. When reading the secret the existing valid password is returned. The database user (the `username` key) must exist before creating the role.

```sh
vault write database/static-roles/role_here \
    username="role_here" \
    db_name=stolon_prod \
    rotation_statements="ALTER USER \"{{name}}\" WITH ENCRYPTED PASSWORD '{{password}}';" \
    rotation_period="7d"
```
