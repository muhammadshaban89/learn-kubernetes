practical examples of how to use `securityContext` in Kubernetes to harden your Pods and Containers:

---

### 1. Run as Non-Root User
```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
```
Ensures the container runs as UID 1000 and not root. This is a basic security best practice.

---

### 2. Drop All Capabilities
```yaml
securityContext:
  capabilities:
    drop: ["ALL"]
```
Removes all Linux capabilities from the container. You can selectively add back only what’s needed.

---

###  3. Prevent Privilege Escalation
```yaml
securityContext:
  allowPrivilegeEscalation: false
```
Blocks processes from gaining more privileges than their parent, even if the binary has setuid.

---

### 4. Set File System Group
```yaml
securityContext:
  fsGroup: 2000
```
Ensures shared volumes are accessible to the container via group ID 2000.

---

### 5. Apply SELinux Labels
```yaml
securityContext:
  seLinuxOptions:
    level: "s0:c123,c456"
```
Applies SELinux context for mandatory access control (MAC) enforcement.

---

### 6. Container-Level SecurityContext Example
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
```

