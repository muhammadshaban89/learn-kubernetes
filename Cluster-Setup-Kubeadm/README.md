Multi-Node Kubernetes Cluster Setup Using Kubeadm:
---------------------------------------------------

This readme provides step-by-step instructions for setting up a multi-node Kubernetes cluster using Kubeadm.

Overview
-------

This guide provides detailed instructions for setting up a multi-node Kubernetes cluster using Kubeadm. The guide includes instructions for installing and configuring containerd and Kubernetes, disabling swap, initializing the cluster, installing Flannel, and joining nodes to the cluster.

Prerequisites:
--------------

Before starting the installation process, ensure that the following prerequisites are met:

- You have at least two Ubuntu 18.04 or higher servers available for creating the cluster.
- Each server has at least 2GB of RAM and 2 CPU cores.
- The servers have network connectivity to each other.for this add indbound and outbound rules that allow ssh, ICMP, HTTPS.
- You have root access to each server.

Installation Steps:
-------------------
Note:( Steps are same for master and worker node. Commands the need to run only on master node are specified explicitly to run only on master node.)

The following are the step-by-step instructions for setting up a multi-node Kubernetes cluster using Kubeadm:

Update the system's package list and install necessary dependencies using the following commands:

	sudo apt-get update
	sudo apt install apt-transport-https curl -y
	sudo apt-get nstall containerd
To install Containerd, use the following commands:

	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install containerd.io -y
Create containerd configuration
Next, create the containerd configuration file using the following commands:

	sudo mkdir -p /etc/containerd
	sudo containerd config default | sudo tee /etc/containerd/config.toml
Edit /etc/containerd/config.toml
Edit the containerd configuration file to set SystemdCgroup to true. Use the following command to open the file:

	sudo nano /etc/containerd/config.toml
	Set SystemdCgroup to true:

	SystemdCgroup = true
or use this command

	sudo sed -i -e 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml	
Restart containerd:

	sudo systemctl restart containerd

Install Kubernetes:
-------------------

To install Kubernetes, use the following commands:

	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	sudo systemctl enable --now kubelet

Disable swap
Disable swap using the following command:

	sudo swapoff -a
If there are any swap entries in the /etc/fstab file, remove them using a text editor such as nano:

sudo vi /etc/fstab
Enable kernel modules

	sudo modprobe br_netfilter
Add some settings to sysctl

	sudo sysctl -w net.ipv4.ip_forward=1
	
Initialize the Cluster --Run only on master.
----------------------------------------------

Use the following command to initialize the cluster:

	sudo kubeadm init --pod-network-cidr=10.244.0.0/16
Create a .kube directory in your home directory:

	mkdir -p $HOME/.kube
Copy the Kubernetes configuration file to your home directory:

	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	Change ownership of the file:

	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	
Install Flannel -Run only on master
-------------------------------------
Flannel is a simple and popular Container Network Interface (CNI) plugin used with "kubeadm" to provide pod-to-pod networking across nodes in a Kubernetes cluster.
Kubernetes requires that every pod can communicate with every other pod in the cluster, regardless of which node they’re on. Flannel enables this by creating an overlay network that routes traffic between pods using virtual interfaces

Use the following command to install Flannel.

	kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
Verify Installation
Verify that all the pods are up and running:

	kubectl get pods --all-namespaces

How to Join Nodes?
-----------------

To add nodes to the cluster, run the kubeadm join command with the appropriate arguments on each node. 
The command will output a token that can be used to join the node to the cluster.

Print Full Join Command Automatically
-------------------------------------
This prints the full command with token and hash included. run the command on master node.

	sudo kubeadm token create --print-join-command

To verify either node joined or not run following command on master node.
	This command will show status pf each node(control-plan and worker nodes). 
	Status must be "Ready".
	
		kubectl get nodes
You can verify pods creation on worker node by creating a pode either with command-line or with a manifest.
As an example run below commands to create a pod and verify its placement on worker node.
create pod:
 			
	kubectl run mypod --image=alpine --restart=Never --command -- sh -c "echo Hello && sleep 10"
	
Get pod deetails- (in the output check "NODE" to verify the node where pode is created.)
		
		kubecel get pods -o wide   
