
 Reinitialize the Control Plane
-------------------------------

If you want to reset and reinitialize the control plane:

    sudo kubeadm reset -f
    sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet/* /etc/cni/net.d/ /var/lib/cni/ /run/flannel/
    sudo systemctl restart containerd
    sudo systemctl restart kubelet

# Then reinitialize

    sudo kubeadm init --pod-network-cidr=10.244.0.0/16


Rejoin a Worker Node**
-------------------------------

If you're on a worker node and want to rejoin:

    sudo kubeadm reset -f
    sudo rm -rf /etc/kubernetes/ /var/lib/kubelet/* /etc/cni/net.d/ /var/lib/cni/ /run/flannel/
    sudo systemctl restart containerd
    sudo systemctl restart kubelet

# Then rejoin

    sudo kubeadm join <control-plane-ip>:6443 --token <token>  --discovery-token-ca-cert-hash sha256:<hash>


Restart Cluster Services:
-------------------------

If you just want to restart the services kubeadm manages:

    sudo systemctl restart kubelet
    sudo systemctl restart containerd


Let me know which scenario you're aiming for — I can tailor the exact commands or help you script it for your lab automation.
