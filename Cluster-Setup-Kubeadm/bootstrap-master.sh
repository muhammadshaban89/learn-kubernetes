#!/bin/bash
#Kubernetes Master Node Bootstrap Script (Post-Reset)

# === 1. Disable Swap ===
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# === 2. Enable IP Forwarding ===
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

# === 3. Start and Enable Container Runtime ===
systemctl start containerd
systemctl enable containerd

# === 4. Start and Enable Kubelet ===
systemctl start kubelet
systemctl enable kubelet

# === 5. Initialize Cluster ===
kubeadm init --pod-network-cidr=10.244.0.0/16

# === 6. Configure kubectl for root ===
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# === 7. Deploy Flannel CNI ===
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
