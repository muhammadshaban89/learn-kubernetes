
How to Install Local Path Provisioner (for kubeadm):
----------------------------------------------------

Run this to install it:

    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
    
This will:

- Deploy the provisioner in local-path-storage namespace
- Create the local-path StorageClass
- Enable dynamic provisioning for PVCs

**Verify Installation**

    kubectl get pods -n local-path-storage
    kubectl get storageclass


**You should see:**

- A running Pod like local-path-provisioner-xxxx
- A default StorageClass named local-path



