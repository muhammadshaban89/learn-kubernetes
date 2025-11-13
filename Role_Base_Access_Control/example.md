

**Example-To test RBAC for user authentication in Kubernetes, you need to combine certificate-based user creation with RoleBindings. **
----------------------------------------------------------------------------------------------------------------------------------------

### Step-by-Step: RBAC for User Authentication

#### 1. **Create a Certificate for a New User**
```bash
openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -out jane.csr -subj "/CN=jane"
openssl x509 -req -in jane.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out jane.crt -days 365
```

This creates a certificate for user `jane` signed by Minikube’s CA.

---

#### 2. **Create a Kubeconfig for Jane**
```bash
kubectl config set-credentials jane --client-certificate=jane.crt --client-key=jane.key
kubectl config set-context jane-context --cluster=minikube --user=jane --namespace=default
```

Switch to Jane’s context:
```bash
kubectl config use-context jane-context
```

---

#### 3. **Create a Role and RoleBinding for Jane**
**Role:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

**RoleBinding:**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

Apply both:
```bash
kubectl apply -f pod-reader-role.yaml
kubectl apply -f pod-reader-binding.yaml
```

---

#### 4. **Test Jane’s Access**
Try listing pods:
```bash
kubectl --context=jane-context get pods
```

✅ You should see pods in the default namespace.

Try accessing secrets:
```bash
kubectl --context=jane-context get secrets
```

❌ You should get a "forbidden" error—Jane isn’t authorized.



### Key Concepts

- **Authentication**: Jane is authenticated via her certificate.
- **Authorization**: RBAC RoleBinding allows her to list pods.
- **Separation of concerns**: Kubernetes doesn’t manage users directly—it delegates authentication to external systems and uses RBAC for authorization.


