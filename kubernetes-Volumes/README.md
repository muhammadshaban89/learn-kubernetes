Volumes in Kubernetes.
-----------------------

* In Kubernetes, a volume is a directory accessible to containers in a pod, mounted at a specified path.
* Unlike container filesystems, which are ephemeral, volumes allow data to persist across container restarts or be shared between container.

Key Volume Types in Kubernetes
------------------------------

1-emptyDir:

   * Temporary storage that lives as long as the pod; good for scratch space.

2-hostpath:
  
   * Mounts a file or directory from the host node into the pod.

3-configMap:
  
  * Injects configuration data into containers as files

4-secrets

  * Similar to configMap, but for sensitive data like passwords or tokens.

5-presistentVolumeCalim:
  
  * Requests storage from a PersistentVolume (PV); supports dynamic provisioning.

6-nfs:

  * Mounts a remote NFS share into the pod.

7-awsElasticBlockStore,gcePresistentDisk,azureDisk
 
  * Cloud-specific block storage volumes

8-volumeClaim

   * Used in StatefulSets to create per-pod PVCs automatically.

Lifecycle and Mounting
----------------------
* Volumes are defined in the pod spec under .
* Containers mount them using .
* A volume can be shared across containers in the same pod.

Why Volumes Matters:
-------------------

* Persistence: Keeps data across container restarts.
* Sharing: Enables file sharing between containers.
* Security: Inject secrets securely.
* Flexibility: Supports local, cloud, and remote storage.
