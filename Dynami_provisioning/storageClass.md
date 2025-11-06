##  What Is a StorageClass?
----------------------------

* A StorageClass in Kubernetes defines how storage is dynamically provisioned for PersistentVolumeClaims (PVCs). 
* It acts as a blueprint for different types of storage backends, enabling automated volume creation.
* A **StorageClass** is a Kubernetes resource that lets cluster administrators define various types of storage (e.g., SSD, HDD, NFS, cloud volumes) and how they should be provisioned. It abstracts the underlying storage provider and allows PVCs to request storage without needing manual PersistentVolume (PV) creation.

---

##  Key Components of a StorageClass:

| Field               | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `provisioner`       | Specifies the driver (e.g., `kubernetes.io/aws-ebs`, `rancher.io/local-path`) |
| `parameters`        | Key-value pairs passed to the provisioner (e.g., disk type, fs type)        |
| `reclaimPolicy`     | What happens to the PV after PVC is deleted (`Delete`, `Retain`, `Recycle`) |
| `volumeBindingMode` | Controls when volume binding and provisioning occur (`Immediate`, `WaitForFirstConsumer`) |
| `allowVolumeExpansion` | Whether PVCs can request more storage after creation (`true` or `false`) |

---

##  How It Works?

1. **Admin defines StorageClass** with provisioner and parameters
2. **User creates a PVC** referencing the StorageClass
3. **Kubernetes dynamically provisions a PV** using the StorageClass
4. **PVC binds to the PV**, and the Pod mounts it

---

##  Example StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

---

##  Default StorageClass

You can mark one StorageClass as default using:

```yaml
annotations:
  storageclass.kubernetes.io/is-default-class: "true"
```

PVCs without `storageClassName` will use this default.

---

Types of storageClass:
------------------------

**Kubernetes supports multiple types of StorageClasses, each tailored to different storage backends and use cases. 

These classes define how PersistentVolumes (PVs) are dynamically provisioned when a PersistentVolumeClaim (PVC) is created.**

---

##  Common Types of StorageClasses and Their Use Cases:

| Type                      | Provisioner                  | Use Case                                                                 |
|---------------------------|------------------------------|--------------------------------------------------------------------------|
| **Local Path**            | `rancher.io/local-path`      | Bare-metal clusters, labs, CI/CD environments                           |
| **HostPath**              | `kubernetes.io/host-path`    | Static provisioning for single-node testing                             |
| **AWS EBS**               | `kubernetes.io/aws-ebs`      | Block storage for cloud-native apps on AWS                              |
| **GCE Persistent Disk**   | `kubernetes.io/gce-pd`       | Persistent disks for Google Cloud workloads                             |
| **Azure Disk/File**       | `kubernetes.io/azure-disk`   | Durable storage for Azure-based apps                                    |
| **NFS**                   | `kubernetes.io/nfs`          | Shared storage across multiple Pods                                     |
| **Ceph RBD / CSI**        | `rbd.csi.ceph.com`           | Distributed block storage for high availability                         |
| **Longhorn / OpenEBS**    | `driver.longhorn.io`         | Cloud-native storage for Kubernetes with snapshot and backup support    |


---

## YAML Manifest Examples:
-----------------------------

### 1. **Local Path (for kubeadm or bare-metal)**

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

---

### 2. **AWS EBS (gp2)**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aws-ebs-gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

---

### 3. **NFS (shared storage)**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-storage
provisioner: kubernetes.io/nfs
parameters:
  server: 10.0.0.1
  path: /exported/path
reclaimPolicy: Retain
volumeBindingMode: Immediate
```

---

### 4. **Ceph RBD CSI**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ceph-rbd
provisioner: rbd.csi.ceph.com
parameters:
  clusterID: <ceph-cluster-id>
  pool: rbd
  imageFormat: "2"
  imageFeatures: layering
reclaimPolicy: Delete
volumeBindingMode: Immediate
```

---

##  Best Practices

- Use `WaitForFirstConsumer` for multi-zone clusters to delay provisioning until Pod scheduling
- Set `storageclass.kubernetes.io/is-default-class: "true"` for your preferred default
- Match `accessModes` and `volumeMode` in PVCs to what the StorageClass supports


**`volumeBindingMode`** and **`reclaimPolicy`** 
-----------------------------------------------

**`volumeBindingMode`** and **`reclaimPolicy`** in Kubernetes StorageClasses — two key settings that control how and when volumes are provisioned and cleaned up.

---

##  `volumeBindingMode`

This controls **when** a PersistentVolume (PV) is bound to a PersistentVolumeClaim (PVC).

| Mode                    | Behavior                                                                 |
|-------------------------|--------------------------------------------------------------------------|
| `Immediate`             | PV is provisioned as soon as the PVC is created, regardless of Pod scheduling |
| `WaitForFirstConsumer` | PV is provisioned **only when a Pod using the PVC is scheduled** — ensures zone affinity |

###  Best Practice:
Use `WaitForFirstConsumer` in multi-zone clusters to avoid provisioning volumes in the wrong zone before Pod placement.

---

##  `reclaimPolicy`

This controls **what happens to the PV** after the PVC is deleted.

| Policy   | Behavior                                                                 |
|----------|--------------------------------------------------------------------------|
| `Delete` | The underlying storage (e.g., disk) is deleted along with the PV         |
| `Retain` | The PV and data remain — manual cleanup or reuse is required             |
| `Recycle`| Deletes data and makes PV available again (deprecated in most setups)    |

### Best Practice:
- Use `Delete` for ephemeral workloads or CI/CD
- Use `Retain` for databases or critical data you want to preserve

---

##  Example StorageClass YAML

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
```


