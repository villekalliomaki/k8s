# Stolon

A highly available distributed PostgreSQL solution, integrating with kubernetes to replace a etcd cluster.

Currently running 3 nodes of each component.

## Initialize a new cluster

```
kubectl run -i -t stolonctl --image=villekalliomaki/stolon --restart=Never --overrides='{ "spec": { "serviceAccount": "stolon" }  }' --rm -- /usr/local/bin/stolonctl --cluster-name=stolon-prod --store-backend=kubernetes --kube-resource-kind=configmap init --log-level warn '{ "ssl": true, "ssl_cert_file": "", "ssl_key_file": "" }'
```

## Docker image

[The image](https://hub.docker.com/r/villekalliomaki/stolon/) is built from a fork based on the stolon master branch. Multi-arch with support for amd64 and arm64.

## Backups (planned)

Run with Kubernetes jobs. Stored on and off premise.

```
# Users, roles
pg_dumpall --globals-only

# For every database backed up
pg_dump [database name]
```