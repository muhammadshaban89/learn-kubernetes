**complete setup with **three Pods** and a NetworkPolicy that allows ingress **only from one specific Pod**. 

**This is perfect for testing Calico enforcement and Pod-level isolation.**

### 🧪 Pod Setup

#### 1️ `nginx-server` (Target Pod)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-server
  namespace: default
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
```

#### 2️ -`busybox-client` (Allowed Source)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-client
  namespace: default
  labels:
    access: allowed
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
```

#### 3️- `busybox-blocked` (Blocked Source)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-blocked
  namespace: default
  labels:
    access: blocked
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
```

---

### NetworkPolicy: Allow Only `busybox-client`

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-specific-pod
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: allowed
```

### Test Connectivity

```bash

# Should succeed
kubectl exec busybox-client -- wget -O- nginx-server

# Should fail
kubectl exec busybox-blocked -- wget -O- nginx-server
```

---

Would you like this bundled into a single manifest for quick deployment and teardown? I can also add a Service and DNS egress policy if you're testing full Calico enforcement.
