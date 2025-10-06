What is minikube?

Minikube is a lightweight tool that lets you run a local Kubernetes cluster on your machine—perfect for development, testing, and learning.

How to setup minikube?

Prerequisites:
--------------
Before starting the installation process, ensure that the following prerequisites are met:

1:You have at least  Ubuntu 18.04 or higher server available for creating the cluster.
2:Each server has at least 2GB of RAM and 2 CPU cores.
3:You have root access to each server.

Installation Steps:
The following are the step-by-step instructions for setting up a minikube on Ubuntu.

1:Update the system's package list and install necessary dependencies using the following commands:

	sudo sudo apt update
	
2:Install Docker:
	
	sudo apt -y install docker.io
	
3:Install apt-transport-https which is a package that enables the APT package manager (used in Debian, Ubuntu, and related systems) to fetch packages over HTTPS instead of plain HTTP

        sudo apt install -y curl wget apt-transport-https

4:Download and Install minikube:

	sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && install minikube-linux-amd64 /usr/local/bin/minikube
  
  Check minikube version"
  
		minikube version

5:Install kubectl: 

	sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

	sudo chmod +x ./kubectl

	sudo mv ./kubectl /usr/local/bin/kubectl

latest Version:

	curl -LO "https://dl.k8s.io/release/v1.33.1/bin/linux/amd64/kubectl"
	sudo chmod +x kubectl
	sudo mv kubectl /usr/local/bin/

6:Install conntrack: 

	sudo apt-get install conntrack

which is a powerful tool used to interact with the Linux kernel's connection tracking system, which is part of the netfilter framework.
 - allows you to view, modify, and flush entries in the connection tracking table.
 - This table keeps track of all active network connections (TCP, UDP, ICMP, etc.)—essential for stateful firewalls.

🧰 Common Use Cases
• Debugging network issues: See which connections are being tracked and why packets are being dropped.
• Firewall tuning: Monitor how iptables or nftables are handling connections.
• NAT troubleshooting: Inspect how connections are being translated.
• Container networking: Useful in Kubernetes and Docker environments where connection tracking affects pod/service communication.

7: Start Minikube:

    minikube start --driver=docker
 	
		 Or
to start it with "driver=none" (Better if you want to learn k8s networking).but it requires additional steps as Kubernetes dropped native Docker support in v1.24+, so cri-dockerd acts as a bridge between Docker and Kubernetes' CRI. Without it, Kubernetes can't talk to Docker directly anymore.
