ResourceQuota in Kubernetes:


In Kubernetes, a ResourceQuota is a policy object that limits the total amount of resources (like CPU, memory, storage, and object counts) that a namespace can consume.

** Purpose of ResourceQuota**

• Prevent resource hogging: Ensures no single team or workload monopolizes cluster resources.
• Enable fair sharing: Especially important in multi-tenant environments.
• Control costs and capacity: Helps with budgeting and planning in cloud-native setups.

**What You Can Limit**

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

**How It Works**

- Quotas are enforced per namespace.
- Kubernetes checks the total usage before allowing new resource creation.
- If usage exceeds the quota, new requests are denied.
- Existing resources are not affected by quota changes.

**✅ Best Practices**

- Combine with LimitRange to enforce per-Pod or per-container limits.
- Use RBAC to isolate teams into namespaces.
- Monitor usage with tools like kubectl describe quota or Prometheus/Grafana.
