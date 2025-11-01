ResourceQuota in Kubernetes:
----------------------------

In Kubernetes, a ResourceQuota is a policy object that limits the total amount of resources (like CPU, memory, storage, and object counts) that a namespace can consume.

**Purpose of ResourceQuota**

- Prevent resource hogging: Ensures no single team or workload monopolizes cluster resources.

- Enable fair sharing: Especially important in multi-tenant environments.

- Control costs and capacity: Helps with budgeting and planning in cloud-native setups.

**What You Can Limit?**

ResourceQuota can restrict:

- Compute resources: requests.cpu, limits.cpu, requests.memory, limits.memory
  
- Storage: PersistentVolumeClaims (PVCs), ephemeral storage
  
- Object counts: Number of Pods, Services, Secrets, ConfigMaps, etc.

**Example YAML**

    apiVersion: v1
    kind: ResourceQuota
    metadata:
      name: dev-quota
      namespace: dev
    spec:
      hard:
        requests.cpu: "2"
        requests.memory: "4Gi"
        limits.cpu: "4"
        limits.memory: "8Gi"
        pods: "10"
        persistentvolumeclaims: "5"  


This sets a cap on total CPU/memory requests and limits, plus object counts like Pods and PVCs in the dev namespace.

**How It Works?**

- Quotas are enforced per namespace.
- Kubernetes checks the total usage before allowing new resource creation.
- If usage exceeds the quota, new requests are denied.
- Existing resources are not affected by quota changes.

**✅ Best Practices**

- Combine with LimitRange to enforce per-Pod or per-container limits.
- Use RBAC to isolate teams into namespaces.
- Monitor usage with tools like kubectl describe quota or Prometheus/Grafana.

Kubernetes ResourceQuota options:
----------------------------------

* Kubernetes ResourceQuota supports a wide range of options to control resource usage per namespace, including compute, storage, and object counts.

**Compute Resource Limits**

These control total CPU and memory usage across all Pods in a namespace:

- **requests.cpu**: Total CPU requested by all containers
- **limits.cpu**: Total CPU limit across all containers
- **requests.memory**: Total memory requested
- **limits.memory**: Total memory limit

**Storage Resource Limits**

These manage persistent and ephemeral storage:

- **requests.storage:** Total requested storage across PVCs
- **persistentvolumeclaims:** Max number of PVCs
- **requests.ephemeral-storage:** Total ephemeral storage requested
- **limits.ephemeral-storage:** Total ephemeral storage limit

**Object Count Limits**
These restrict the number of Kubernetes objects in a namespace:

- **pods:** Max number of Pods
- **services:** Max number of Services
- **replicationcontrollers**
- **secrets**
- **configmaps**
- resourcequotas
- **services.loadbalancers:** Max number of LoadBalancer-type Services
- **services.nodeports:** Max number of NodePort-type Services

**Compute Resource Limits by Pod Priority Class**

 scope quotas by priority class

    scopeSelector:
      matchExpressions:
      - scopeName: PriorityClass
        operator: In
        values: ["high-priority"]

**Verify Resource Quota Creation:**

To verify that the Resource Quota has been successfully created, run the following command:

	kubectl get resourcequota compute-resources
 
**View Existing Resource Quotas**

To view the existing Resource Quotas in the "my-first-ns"  namespace, use the following command:

	kubectl get resourcequota -n my-first-ns

**Delete a Resource Quota**
To delete a Resource Quota from the "my-first-ns" namespace, execute the following command:

  	kubectl delete resourcequota compute-resources -n my-first-ns

**Checking Resource Utilization**
To check the resource utilization of the "my-first-ns" namespace, run the following command:

	kubectl top namespace my-first-ns
        
        
Remember!!!!!!
----------------
When you apply a ResourceQuota, it limits usage within a namespace, but the actual resource consumption happens on worker nodes where the Pods are scheduled.
