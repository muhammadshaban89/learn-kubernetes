
 Reinitialize the Control Plane
-------------------------------

If you want to reset and reinitialize the control plane:

    sudo kubeadm reset -f
    sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet/* /etc/cni/net.d/ /var/lib/cni/ /run/flannel/
    sudo systemctl restart containerd
    sudo systemctl restart kubelet

* Remove CNI Configuration
 
       sudo rm -rf /etc/cni/net.d/
       sudo rm -rf /var/lib/cni/
       sudo rm -rf /run/flannel/
    
* Reset iptables Rules (Optional but Recommended)
  
      sudo iptables -F
      sudo iptables -t nat -F
      sudo iptables -t mangle -F
      sudo iptables -X
  
* Remove kubeconfig Files
  
      rm -rf $HOME/.kube/config
  
* Restart Services

      sudo systemctl restart containerd
      sudo systemctl restart kubelet

* Then reinitialize

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
