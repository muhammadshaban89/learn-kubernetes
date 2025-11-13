
###  What Is RBAC in Kubernetes?
---------------------------------

* RBAC (Role-Based Access Control) in Kubernetes lets you define who can do what within your cluster—using roles, bindings, and service accounts. 
* RBAC is a Kubernetes authorization mechanism that controls access to resources based on user roles.
* It enforces *least privilege* by assigning only the permissions necessary for users or services.


### Key RBAC Components
-------------------------

| Component           | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Role**           | Defines permissions within a namespace                                      |
| **ClusterRole**    | Defines permissions across the entire cluster                               |
| **RoleBinding**    | Assigns a Role to a user/service account within a namespace                 |
| **ClusterRoleBinding** | Assigns a ClusterRole to a user/service account cluster-wide             |

---

### Example 1: Read-Only Access to Pods in a Namespace

**Role:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

**RoleBinding:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: dev
subjects:
- kind: User
  name: alice
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

---

### Example 2: Cluster-Wide Admin Access

**ClusterRole:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
```

**ClusterRoleBinding:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-binding
subjects:
- kind: User
  name: bob
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```

---

###  Example 3: Granting Access to a Service Account

**Use case:** Allow a Pod to list ConfigMaps in its namespace.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: app
  name: configmap-reader
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: configmap-access
  namespace: app
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: app
roleRef:
  kind: Role
  name: configmap-reader
  apiGroup: rbac.authorization.k8s.io
```

---

### Best Practices

- **Use Roles for namespace-scoped access**, ClusterRoles for global access.
- **Avoid using `verbs: ["*"]` unless absolutely necessary.**
- **Audit bindings regularly** to prevent privilege creep.
- **Use service accounts for Pods**, not user accounts.
