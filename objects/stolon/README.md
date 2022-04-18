# Stolon

A highly available distributed PostgreSQL solution, integrating with kubernetes to replace a etcd cluster.

Currently running 3 nodes of each component.

## Initialize a new cluster

```sh
kubectl run -i -t stolonctl --image=villekalliomaki/stolon --restart=Never --overrides='{ "spec": { "serviceAccount": "stolon" }  }' --rm -- /usr/local/bin/stolonctl --cluster-name=stolon-prod --store-backend=kubernetes --kube-resource-kind=configmap init
```

Additionally patch the cluster to enable TLS.

```sh
kubectl run -i -t stolonctl --image=villekalliomaki/stolon --restart=Never --overrides='{ "spec": { "serviceAccount": "stolon" }  }' --rm -- /usr/local/bin/stolonctl --cluster-name=stolon-prod --store-backend=kubernetes --kube-resource-kind=configmap update --patch '{ "pgParameters": { "ssl": "true", "ssl_cert_file": "/stolon-tls-runtime/tls.crt", "ssl_key_file": "/stolon-tls-runtime/tls.key" } }'
```

## Cluster state

View the current cluster status. Replace `status` with `spec` to see pgParameters.

```sh
kubectl run -i -t stolonctl --image=villekalliomaki/stolon --restart=Never --overrides='{ "spec": { "serviceAccount": "stolon" }  }' --rm -- /usr/local/bin/stolonctl --cluster-name=stolon-prod --store-backend=kubernetes --kube-resource-kind=configmap status
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