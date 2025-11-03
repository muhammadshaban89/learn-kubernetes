
What Is Static Provisioning in kubernetes?
---------------------------------------------

Static provisioning in Kubernetes refers to the **manual creation and binding of PersistentVolumes (PVs)** by a cluster administrator, rather than letting Kubernetes dynamically provision storage based on a StorageClass.

**static provisioning**
In static provisioning:

- Pre-create a **PersistentVolume (PV)** that points to a specific storage resource (e.g., NFS share, local disk, iSCSI target).
- Users create **PersistentVolumeClaims (PVCs)** that match the PV’s specs (size, access mode, etc.).
- Kubernetes binds the PVC to the matching PV.


 **Example: Static NFS Provisioning**

1. Create the PV manually:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  nfs:
    path: /mnt/nfs_share
    server: 192.168.1.100
  persistentVolumeReclaimPolicy: Retain
```

2. Create a matching PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

Once the PVC is created, Kubernetes will bind it to `nfs-pv` if the specs match.

---

 **Key Differences from Dynamic Provisioning**

| Feature                  | Static Provisioning                         | Dynamic Provisioning                          |
|--------------------------|---------------------------------------------|-----------------------------------------------|
| **PV Creation**          | Manual by admin                             | Automatic by Kubernetes                       |
| **StorageClass**         | Not required                                | Required                                      |
| **Flexibility**          | Limited to pre-defined volumes              | Highly flexible, scalable                     |
| **Use Case**             | Legacy systems, custom storage setups       | Cloud-native, automated environments          |



 **Automation Tip for Your Lab**

- Use static provisioning when testing NFS, iSCSI, or bare-metal setups.
- Script PV/PVC creation with `kubectl apply -f` and validate binding with:
 
      kubectl get pv
      kubectl get pvc



