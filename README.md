# Kubernetes cluster

### Components

- Cluster TLS issuer
- Hashicorp Vault
- KeyDB (Redis)
- Stolon (PostgreSQL)
- [Flame](https://github.com/pawelmalak/flame)
- Wireguard
  - Node to node
  - Remotely to cluster
- Identity
  - Authelia SSO
  - OpenLDAP
  - phpLDAPadmin
- [Trilium](https://github.com/zadam/trilium)
- Media
  - Jellyfin
  - Transmission
  - Radarr
  - Sonarr
  - Jackett
  - Bazarr
- Hastebin
- Trilium notes
- Uptime Kuma
- Vaultwarden (Bitwarden)
- Minio (S3 storage)
- Gotify

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
