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
    connection_url="postgresql://{{username}}:{{password}}@stolon-proxy:5432/postgres?sslmode=disable" \
    username="replace_this" \
    password="replace_this"
```


## Creating a database role

The database user role description. SQL statement [reference](https://www.vaultproject.io/api-docs/secret/databases/postgresql#statements).
A new role is created for each new database client. SQL statements can be altered per user as seen fit.

*Note that "-" should be replaced with "_" in role names.*


```sql
CREATE DATABASE {{username}}_default;
CREATE USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT ALL PRIVILEGES ON {{username}}_default TO {{username}};
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

```sh
vault write database/roles/role_here \
    db_name=stolon_prod \
    creation_statements="CREATE DATABASE {{username}}_default; CREATE USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL PRIVILEGES ON {{username}}_default TO {{username}};" \
    revocation_statements="ALTER USER {{username}} WITH NOLOGIN;" \
    renew_statements="ALTER USER {{username}} WITH LOGIN;" \
    rotation_statements="ALTER USER {{username}} WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
    default_ttl="7d" \
    max_ttl="30d"
```