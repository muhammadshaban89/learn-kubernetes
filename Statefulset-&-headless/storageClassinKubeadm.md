
StorageClass in kubeadm?
------------------------

**Kubeadm does not install a default StorageClass by itself. 
You must manually create one or install a dynamic provisioner.**



Why Kubeadm Doesn’t Include a Default StorageClass?
---------------------------------------------------

* Unlike cloud-managed Kubernetes (like EKS, GKE, AKS), **kubeadm is a bare-metal installer
* It sets up the control plane and nodes, but **does not include storage provisioners or default StorageClasses**. This is intentional — * kubeadm is designed to be minimal and flexible.


How to Set Up a Default StorageClass in Kubeadm?
-------------------------------------------------

**You have two options:**

🔹 Option 1: Use a Local Provisioner (for bare-metal)

Install a dynamic provisioner like [`local-path-provisioner`](https://github.com/rancher/local-path-provisioner) or use a static `hostPath` setup.

**Example: Local Path StorageClass**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
```

> This works well for Minikube, K3s, or bare-metal clusters.
> thit StorageClass definition will work with kubeadm, but only if you’ve installed the Local Path Provisioner that supports rancher.io/local-path.


# 🔹 Option 2: Use Static Provisioning with `hostPath`

If you don’t want dynamic provisioning, manually create PVs and use a static StorageClass:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: hostpath
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/host-path
volumeBindingMode: Immediate
```

> Note: `hostPath` does **not support dynamic provisioning**, so you must manually create matching PVs.



## Verify Default StorageClass**

```bash
kubectl get storageclass
```

Look for `(default)` next to the name.

How to Install Local Path Provisioner (for kubeadm)??
------------------------------------------------------

Run this to install it:

    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

**This will:**

- Deploy the provisioner in local-path-storage namespace.
- Create the local-path StorageClass
- Enable dynamic provisioning for PVCs

**Verify Installation**

    kubectl get pods -n local-path-storage
    kubectl get storageclass
You should see:

- A running Pod like local-path-provisioner-xxxx
- A default StorageClass named local-path

✅ Result
Once installed, your PVCs will dynamically bind to PVs using local disk paths like /opt/local-path-provisioner.
