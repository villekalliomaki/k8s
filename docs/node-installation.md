# Node installation

Preparing and installing a new node to the cluster.

## Dependencies

Debian based updates.

```sh
sudo apt update && sudo apt upgrade -y && sudo apt install vim -y 
```

Docker installation.

- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Debian](https://docs.docker.com/engine/install/debian/)

```sh
sudo apt-get remove docker docker-engine docker.io containerd runc

# docker dependencies
sudo apt-get update && sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# docker keys (ubuntu)
sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# docker keys (debian)
sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# add repo (ubuntu)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# add repo (debian)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# test installation
docker run hello-world

# common folders
sudo mkdir -p /mnt/{hashicorp-vault,keydb,minio,stolon}
```

## Install wireguard (optional, remote nodes)

```sh
sudo apt install wireguard -y
```

Generate private key.

```sh
cd /etc/wireguard

wg genkey > host.key
chmod 600 host.key
wg pubkey < host.key > host.pub
```

Example for `/etc/wireguard/k8s.conf`. 

```
[Interface]
PrivateKey = private
Address = 10.1.1.0/32
ListenPort = 51800

# hostname
[Peer]
PublicKey = public
Endpoint = endpoint:51800
AllowedIPs = 10.1.1.0/32
PersistentKeepalive = 25
```

Enable wireguard interface.

```sh
sudo systemctl enable --now wg-quick@k8s
```

## Install Longhorn dependencies

Longhorn distributed block storage.

- [Installation guide (1.2.4)](https://longhorn.io/docs/1.2.4/deploy/install/)

```sh
apt-get install nfs-common open-iscsi -y
```

## Install kubeadm

Useful docs:
- [Required ports](https://kubernetes.io/docs/reference/ports-and-protocols/)
- [Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

Install `kubeadm`, `kubelet` and `kubectl`.

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl

# add the key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# add repo
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# install components
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl
# for specific versions
sudo apt-get update && sudo apt-get install -y kubelet=1.23.1-00 kubeadm=1.23.1-00 kubectl=1.23.1-00 && sudo apt-mark hold kubelet kubeadm kubectl
```

Get the join command. Nodes must be able to reach each other now. Run on a control plane. Add `--dry-run` to the printed join command to run pre-flight checks before joining.

```sh
kubeadm token create --print-join-command
```
