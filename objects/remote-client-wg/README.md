# Remote Wireguard clients

Enables remote devices (phones, laptops) to access the internal network over the internet. Traffic is direct and not over CF. Deployment runs on local node(s).

Multiple nodes could be possible. Session affinity for handshakes, but otherwise stateless? Would need router-level load balancing.

## Issues

While administering the cluster remotely it is possible to be locked out, if for some reason Hashicorp Vault is sealed and the Wireguard "server" is restarted. Vault can't be unsealed without the VPN and the VPN server can't start without Vault because it can't fetch the private/public keys.