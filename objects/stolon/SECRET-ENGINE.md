# Hashicorp Vault secret engine

Stolon database user management and password rotation. Vault is the source for all credentials, pushing them to Stolon while applications pull them from Vault. When a new user is created, it becomes the owner of a database with the same name.

[Vault Docs](https://www.vaultproject.io/docs/secrets/databases/postgresql)

## Installation

Enable secret engine and configure access.

```sh
vault secrets enable database

# Username and password will be formatted to the connection URL.
# Only replace the key values.
vault write database/config/stolon-prod \
    plugin_name=postgresql-database-plugin \
    allowed_roles="stolon-prod-user" \
    connection_url="postgresql://{{username}}:{{password}}@stolon-proxy:5432/" \
    username="replace_this" \
    password="replace_this"
```

The database user role description. SQL statement [reference](https://www.vaultproject.io/api-docs/secret/databases/postgresql#statements).

### Create

Create the new user with the default database.

```sql
CREATE DATABASE {{username}}-user-db;
CREATE USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT ALL PRIVILEGES ON {{username}}-user-db TO {{username}};
```

### Revoke

Lock the user. The user or their databases are not deleted.

```sql
ALTER USER {{username}} WITH NOLOGIN;
```

### Renew

???

```sql
SQL ...
```

### Rotation

Password rotation of an user.

```sql
ALTER USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
```

### 

```sh
vault write database/roles/stolon-prod-user \
    db_name=stolon-prod \
    creation_statements="" \
    revocation_statements="" \
    renew_statements="" \
    rotation_statements="" \
    default_ttl="1h" \
    max_ttl="24h"
```