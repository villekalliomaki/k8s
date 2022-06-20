# Troubleshooting

## Node wrong internal ip

Common for remote nodes. Use the correct IP.

```
sudo vim /var/lib/kubelet/kubeadm-flags.env

KUBELET_KUBEADM_ARGS="... ... --node-ip=10.1.1.0"
```

## Worker port 10250 no route to host.

Check firewalls and connectivity. Common after adding `--node-ip` to kubelet arguments.

```sh
# flush iptables
iptables --flush
iptables -tnat --flush

# restart docker
systemctl restart docker
```

## LDAP queries don't return entries

Probbaly an issue with OpenLDAP. Authelia failed logins, invalid group memberships. Delete OpenLDAP pod.
