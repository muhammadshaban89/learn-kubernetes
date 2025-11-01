What is LimitRange?
-------------------

A LimitRange is a namespace-scoped policy object that sets:
- Default resource requests and limits (CPU, memory, storage)
- Minimum and maximum bounds
- Applies to Pods, Containers, and PVCs
  
It ensures that workloads don’t consume excessive resources or run without defined limits.

**Behavior**
------------

**- Default injection:**
If a Pod doesn’t specify resources.requests or resources.limits, Kubernetes injects defaults from the LimitRange.

**- Validation failure:**
If a Pod violates the min or max constraints, it will be rejected with a LimitRange validation error.

**- Scope:**
Only new Pods are validated. Existing ones are not retroactively affected.

**Example YAML:**

    apiVersion: v1
    kind: LimitRange
    metadata:
      name: mem-cpu-limit-range
      namespace: dev
    spec:
      limits:
      - default:
          cpu: "500m"
          memory: "512Mi"
        defaultRequest:
          cpu: "250m"
          memory: "256Mi"
        max:
          cpu: "1"
          memory: "1Gi"
        min:
          cpu: "100m"
          memory: "128Mi"
        type: Container




