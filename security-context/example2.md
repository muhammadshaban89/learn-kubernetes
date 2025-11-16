- Here are **separate, minimal YAML examples** for each key `securityContext` setting in Kubernetes. 
_ These are tailored for Minikube and Calico environments, using public images like `busybox` or `nginx`.

---

### 🔹 1. `runAsNonRoot: true`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runasnonroot-example
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["sh", "-c", "id && sleep 3600"]
```

🧠 Ensures the container runs as a non-root user (UID 1000). If the image requires root, the Pod will fail to start.

---

### 🔹 2. `capabilities` (Drop All, Add Specific)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: capabilities-example
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["sh", "-c", "sleep 3600"]
    securityContext:
      capabilities:
        drop: ["ALL"]
        add: ["NET_ADMIN"]
```

🧠 Drops all Linux capabilities, then adds back only `NET_ADMIN` (e.g., for `tc`, `ip` commands).

---

### 🔹 3. `allowPrivilegeEscalation: false`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: no-priv-escalation
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["sh", "-c", "sleep 3600"]
    securityContext:
      allowPrivilegeEscalation: false
```

🧠 Prevents processes from gaining more privileges than their parent, even if the binary has setuid/setgid.

---

### 🔹 4. `fsGroup` (File System Group)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: fsgroup-example
spec:
  securityContext:
    fsGroup: 2000
  volumes:
  - name: shared-data
    emptyDir: {}
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["sh", "-c", "ls -l /data && sleep 3600"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
```

🧠 Ensures mounted volumes are owned by GID 2000, allowing group-based access control.


