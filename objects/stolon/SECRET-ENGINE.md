# Hashicorp Vault secret engine

Stolon database user management and password rotation. The credentials are created dynamically when requested from Vault.

[Vault Docs](https://www.vaultproject.io/docs/secrets/databases/postgresql)

## Installation

Enable secret engine and configure access.

```sh
vault secrets enable database

# Username and password will be formatted to the connection URL.
# Only replace the key values.
vault write database/config/stolon_prod \
    plugin_name=postgresql-database-plugin \
    allowed_roles="stolon_prod_user" \
    username_template="{{.RoleName | lowercase | replace \"-\" \"_\"}}_prod" \
    connection_url="postgresql://{{username}}:{{password}}@stolon-proxy:5432/postgres?sslmode=disable" \
    username="replace_this" \
    password="replace_this"
```


## Creating a database role

The database user role description. SQL statement [reference](https://www.vaultproject.io/api-docs/secret/databases/postgresql#statements).
A new role is created for each new database client. The actual username of the role is something like`lowercase_username_prod`.

```sql
CREATE USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
```

### Revoke

Lock the user. The user or their databases are not deleted.

```sql
ALTER USER {{username}} WITH NOLOGIN;
```

### Renew

Enable login for the user.

```sql
ALTER USER {{username}} WITH LOGIN;
```

### Rotation

Change the password of the user.

```sql
ALTER USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
```

### Apply the role

Because the username is replaced with something like `v-root-stolonpr-QVpbXuK1EK9500q21pV4-1650216546`, quoting the formatted username is required in SQL.

```sh
vault write database/roles/role_here \
    db_name=stolon_prod \
    creation_statements="CREATE USER \"{{name}}\" WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
    revocation_statements="ALTER USER \"{{name}}\" WITH NOLOGIN;" \
    renew_statements="ALTER USER \"{{name}}\" WITH LOGIN;" \
    rotation_statements="ALTER USER \"{{name}}\" WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
    default_ttl="7d" \
    max_ttl="30d"
```