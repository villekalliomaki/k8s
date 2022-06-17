# Kubernetes cluster

### Components

- Cluster TLS issuer
- Hashicorp Vault
- KeyDB (Redis)
- Stolon (PostgreSQL)
- Flame
- Wireguard
  - Node to node
  - Remotely to cluster
- Identity
  - Authelia SSO
  - OpenLDAP
  - phpLDAPadmin
- Trilium
- Media
  - Jellyfin
  - Transmission
  - Radarr
  - Sonarr
  - Jackett
  - Bazarr
- Hastebin
- Trilium notes
- Vaultwarden (Bitwarden)
- Minio (S3 storage)
- Gotify
- Monitoring
  - Promtail
  - Prometheus
  - Loki
  - Grafana
  - Node exporter
- Calendar
  - Etebase server
  - Etebase WebDAV proxy
  - Etebase web UI

### Objects

Kubernetes objects.

### Charts

Helm charts and chart values.

### Edge latency

Latency sentisive applications (SSO, single instance databases, master instances) should prefer nodes labeled `edge-latency=low`.

`requiredDuringSchedulingIgnoredDuringExecution`, `preferredDuringSchedulingIgnoredDuringExecution` and `nodeSelector` are used for pod scheduling.

[Docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

### TLS

Internal certificates are issued directly by the cluster `root-ca` without intermediates. Most applications do not automatically apply the updated certs without a restart.
