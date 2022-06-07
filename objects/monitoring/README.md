# Cluster monitoring stack

- Promtail pulls logs
- Loki for storage
- Prometheus for metrics
- Grafana for displaying

Kubernetes pod logs data flow: Promtail > Loki > Grafana

Other metrics: Prometheus scrapes > Grafana

# Storage

Loki and Prometheus need persistent storage. Both use Longhorn block storage. With stable S3 storage (Minio) setup, loki could migrate to that.

# TLS

*All components **probably** use TLS for communication.*

# Deployment

- Promtail on all nodes as a DaemonSet
    - Needs roles to access pod logs from the kubelet
- Loki as a single replica Deployment
    - If migrated to S3, a 2-3 node cluster would be possible. Probably unnecessary
- Prometheus as a single replica Deployment
- Grafana as a single replica Deployment
