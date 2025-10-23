Worker-Node Setup -Local Machine
--------------------------------:

Prerequisites:

✅ Control plane already initialized (kubeadm init)

✅ You have the kubeadm join command with token and hash

✅ Ubuntu 20.04.2 LTS installed on the worker node

✅ Root or sudo access


 
Step 1: System Preparation

	apt update && sudo apt upgrade -y
	apt install -y curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common


Step 2: Install Container Runtime (containerd)

vim containerd.sh


	# Load required modules
	cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
	overlay
	br_netfilter
	EOF

	sudo modprobe overlay
	sudo modprobe br_netfilter

	# Set sysctl params
	cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
	net.bridge.bridge-nf-call-iptables  = 1
	net.ipv4.ip_forward                 = 1
	net.bridge.bridge-nf-call-ip6tables = 1
	EOF

	sudo sysctl --system
  
 make scrip executeable
 
    chmod +x containerd.sh
    ./containerd.sh
    
Install containerd:

	sudo apt install -y containerd

Configure containerd

	sudo mkdir -p /etc/containerd
	containerd config default | sudo tee /etc/containerd/config.toml

Restart containerd

	sudo systemctl restart containerd
	sudo systemctl enable containerd



Step 3: Install Kubernetes Components

Add Kubernetes repo:

	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

Install kubeadm, kubelet, kubectl
	
	sudo apt update
	sudo apt install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl


Step 4: Join the Cluster

	Use the kubeadm join command from your control plane:
	sudo kubeadm join 

Step 5: Verify Node Status

On the control plane:
	
	kubectl get nodes -o wide


Your worker node should show Ready.

Step 6: Flannel CNI (Handled Automatically)

If Flannel was already applied on the control plane:

	kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


Then verify:

	kubectl get pods -n kube-flannel -o wide


You should see a Flannel pod running on the worker node.

Optional: Validate Pod Networking

Deploy a test pod:

	kubectl run testpod --image=nginx --restart=Never
	kubectl get pod testpod -o wide


Check if it lands on the worker node and reaches the internet.

Troubleshooting Tips:
---------------------

- If pods are stuck in ContainerCreating, check:

		journalctl -u kubelet -f
		ls /etc/cni/net.d/
		cat /run/flannel/subnet.env

- Restart services if needed:

		sudo systemctl restart containerd
		sudo systemctl restart kubelet

  
* How to Remove the Node from the Control Plane?
  ----------------------------------------------

* Run this on the control plane:

      kubectl drain <node-name> --delete-local-data --force --ignore-daemonsets
      kubectl delete node <node-name>

For example:

    kubectl drain workernode --delete-local-data --force --ignore-daemonsets
    kubectl delete node workernode
	
This:

- Evicts all pods from workernode  
- Removes it from the cluster registry

	
* 2-Reset Kubernetes on the Worker Node- run on worker node.

       sudo kubeadm reset -f
       sudo rm -rf /etc/kubernetes/ /var/lib/kubelet/* /etc/cni/net.d/ /var/lib/cni/ /run/flannel/
       sudo systemctl restart containerd
       sudo systemctl restart kubelet
  
* 3-Final Check
On the control plane:

      kubectl get nodes
	
workernode should no longer appear.
	
How to Clean, Reset and Rejoin if node previosly joined master node?
-------------------------------------------------------------------------

* 1- Reset Kubernetes on the Worker Node

	  sudo kubeadm reset -f
* 2- Clean Up Residual Files

		sudo rm -rf /etc/kubernetes/
		sudo rm -rf /var/lib/kubelet/*
		sudo rm -rf /etc/cni/net.d/
		sudo rm -rf /var/lib/cni/
		sudo rm -rf /run/flannel/

* 3- Restart Services

		sudo systemctl restart containerd
		sudo systemctl restart kubelet
* 4- Rejoin the Cluster

  		sudo kubeadm join 192.168.xyz.xyz:6443 --token 1ynh1n.3u5m6cno3adaztax --discovery-token-ca-cert-hash sha256:0360e15628e2685371b8c3e20a7f6a7ab99b44e4ea31f66f54656240e44f68b3

* 5-Final Check

On the control plane: Your workernode should now show Ready.

	kubectl get nodes -o wide
