
## What Is Dynamic Provisioning?
--------------------------------

* Dynamic provisioning in Kubernetes automatically creates PersistentVolumes (PVs) when a user requests storage via a PersistentVolumeClaim (PVC), eliminating the need for manual volume setup.

* Dynamic provisioning is a Kubernetes feature that allows **on-demand creation of storage volumes**. When a developer creates a PVC, Kubernetes uses a **StorageClass** to determine how to provision the requested storage.

* Without dynamic provisioning, cluster admins must manually create PVs that match each PVC — a tedious and error-prone process.

##  How It Works?

1. **Admin defines a StorageClass** with a provisioner (e.g., AWS EBS, NFS, local-path)
2. **User creates a PVC** referencing that StorageClass
3. **Kubernetes automatically creates a PV** using the provisioner
4. **PVC binds to the PV**, and the Pod mounts it


##  Example StorageClass (Local Path)

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

## Example PVC Using Dynamic Provisioning

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: local-path
```

When this PVC is applied, Kubernetes dynamically provisions a PV using the `local-path` StorageClass.

---

## Benefits

- **Automation**: No manual PV creation
- **Scalability**: Ideal for CI/CD and cloud-native apps
- **Flexibility**: Supports multiple backends (e.g., AWS, GCE, NFS, CSI drivers)


