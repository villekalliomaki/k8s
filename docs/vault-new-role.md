# Vault role creation

## 1. Create a policy

Paths and their permissions scopes. Easier to put a single path here and then add more in the web UI. The following is the usual config path for apps.

```
vault policy write role_here - <<EOF
path "role_here/data/config" {
  capabilities = ["read"]
}
EOF
```

## 2. Create a role

Role is bound to a k8s service account in the pod manifest. With normal apps the role, SA and policy the of the same name.

```
vault write auth/kubernetes/role/role_here \
    bound_service_account_names=role_here \
    bound_service_account_namespaces=default \
    policies=role_here \
    ttl=24h
```

## 3. Add read permissions to DB (optional)

PostgreSQL static role policy:

```
path "database/static-creds/authelia" {
  capabilities = ["read"]
}
```

## 4. Create config store (optional)

For general secrets, admin passwords: `vault secrets enable -path=app_name kv-v2`.
