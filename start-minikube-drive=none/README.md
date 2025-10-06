
How to start minikube , especially when using the none driver.

Here’s how you can fix it step-by-step:

🛠️ Install crictl on Ubuntu
- Download the latest release:

VERSION="v1.28.0"

curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz

Extract and move to /usr/local/bin:

tar -C /usr/local/bin -xzf crictl-$VERSION-linux-amd64.tar.gz

- Verify installation:
  
   crictl --version

🔁 Retry Minikube
Once crictl is installed and in root’s path, try starting Minikube again:
sudo minikube start --driver=none

-----------------------------------------------------------------------------------------
If facing ERROR!
-----------------------------------------------------------------------------------------
- Exiting due to NOT_FOUND_CRI_DOCKERD:
- Suggestion:
- The none driver with Kubernetes v1.24+ and the docker container-runtime requires cri-dockerd.
- Please install cri-dockerd using these instructions:
- https://github.com/Mirantis/cri-dockerd

-------------
Soluntion:
-------------
⚙️ Step-by-Step: Install cri-dockerd on Ubuntu
1. Install Dependencies
 
sudo apt update

sudo apt install -y git golang-go


2. Clone the Repository

git clone https://github.com/Mirantis/cri-dockerd.git

cd cri-dockerd

3. Build the Binary

	mkdir -p bin

	go build -o bin/cri-dockerd



4. Move the Binary to System Path

  sudo mv bin/cri-dockerd /usr/local/bin/


5. Set Up the Systemd Service:

sudo cp -a packaging/systemd/* /etc/systemd/system/

sudo sed -i 's:/usr/bin/cri-dockerd:/usr/local/bin/cri-dockerd:' /etc/systemd/system/cri-docker.service

6. Start and Enable the Service:

	sudo systemctl daemon-reexec
        sudo systemctl daemon-reload
	sudo systemctl enable cri-docker.service
	sudo systemctl enable cri-docker.socket
	sudo systemctl start cri-docker.service


🔗 Configure Minikube to Use cri-dockerd
When starting Minikube, explicitly point to the CRI socket:

sudo minikube start --driver=none --container-runtime=docker --cri-socket=unix:///var/run/cri-dockerd.sock


🧠 Why This Matters
Kubernetes dropped native Docker support in v1.24+, so cri-dockerd acts as a bridge between Docker and Kubernetes' CRI. Without it, Kubernetes can't talk to Docker directly anymore.
Let me know if you hit any snags during setup — I can help troubleshoot systemd errors, socket issues, or runtime mismatches.

If face Container Networking Plugins Error:

🌐 Install Container Networking Plugins (CNI)
1. Set the Version
Pick a stable version — for example:

	CNI_PLUGIN_VERSION="v1.3.0"


2. Download the Plugin Archive

	CNI_PLUGIN_TAR="cni-plugins-linux-amd64-$CNI_PLUGIN_VERSION.tgz"
	curl -LO "https://github.com/containernetworking/plugins/releases/download/$CNI_PLUGIN_VERSION/$CNI_PLUGIN_TAR"

If you're on ARM or another architecture, change amd64 accordingly.

3. Install to the Correct Directory
	
	CNI_PLUGIN_INSTALL_DIR="/opt/cni/bin"
	sudo mkdir -p "$CNI_PLUGIN_INSTALL_DIR"
	sudo tar -xf "$CNI_PLUGIN_TAR" -C "$CNI_PLUGIN_INSTALL_DIR"
	rm "$CNI_PLUGIN_TAR"


✅ Verify Installation
You should now see binaries like , , , etc. in .

Once this is done, Minikube should be able to proceed with the  driver setup. You're assembling a bare-metal Kubernetes cluster like a true infrastructure artisan.
-----------------------
If facing Permision errors like this:

stderr: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.47/version": dial unix /var/run/docker.sock: connect: permission denied
*

Ah, the classic permission denied on the Docker socket — you're almost there, Muhammad. This error means your current user doesn’t have access to /var/run/docker.sock, which is owned by the docker group. Here's how to fix it:

🔓 Grant Docker Access to Your User
1. Add Your User to the Docker Group
 
sudo usermod -aG docker $USER

Replace $USER with your actual username if needed.

2. Apply the Group Change
 You’ll need to log out and back in, or run:
 
	newgrp docker


✅ Test Docker Access Without sudo
docker version

Start minikube with --driver=none

Some Importent Commands:
 
	minkibe version
        minikube status
        kubectl get nodes 
