To join your Ubuntu 20.04.2 LTS node as a Kubernetes worker, you'll need to install required packages, configure the system, and use the kubeadm join command from your master node.

**Step 1: Prepare the System**

- Disable swap (Kubernetes requires swap to be off):

      sudo swapoff -a
      sudo sed -i '/ swap / s/^/#/' /etc/fstab
  
- Update system packages:
  
      sudo apt update && sudo apt upgrade -y
  
- Set hostname (optional but recommended):

      sudo hostnamectl set-hostname worker-node-name



📦 Step 2: Install Container Runtime (containerd):

    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y containerd.io

- Configure containerd:

      sudo mkdir -p /etc/containerd
      containerd config default | sudo tee /etc/containerd/config.toml
      sudo systemctl restart containerd
      sudo systemctl enable containerd

📦 Step 3: Install Kubernetes Components

      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt update
      sudo apt install -y kubelet kubeadm kubectl
      sudo apt-mark hold kubelet kubeadm kubectl
    
🔐 Step 4: Join the Cluster
- On the master node, run:
 
      kubeadm token create --print-join-command
  
- Copy the output (it looks like kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>) and run it on the worker node:
sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>

✅ Step 5: Verify Node Join
- On the master node:

      kubectl get nodes
Note:
----
You do not manually install Flannel on each worker



