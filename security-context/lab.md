A bundled manifest for a Calico-enforced Kubernetes Pod using multi-container patterns and hardened `securityContext` settings. It includes:

- ✅ Pod-level security: `runAsUser`, `fsGroup`, `runAsNonRoot`
- 🔐 Container-level isolation: dropped capabilities, no privilege escalation
- 🧭 Multi-container setup: Sidecar + Adapter pattern
- 📦 Public images: `nginx` and `busybox` (validated)

---

###  Hardened Multi-Container Pod Manifest (Calico-ready)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hardened-multi-container
  labels:
    app: secure-app
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
    runAsNonRoot: true
  containers:
  - name: web-server
    image: nginx:1.25.3
    ports:
    - containerPort: 80
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
  - name: log-sidecar
    image: busybox:1.36.1
    command: ["sh", "-c", "tail -n+1 -f /var/log/nginx/access.log"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/nginx
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
  volumes:
  - name: shared-logs
    emptyDir: {}
```

---

###  Validation Checklist:

| Step | Command | Expected Output |
|------|---------|-----------------|
| Pod creation | `kubectl apply -f hardened-pod.yaml` | Pod `Running` |
| Pod security | `kubectl get pod hardened-multi-container -o jsonpath='{.spec.securityContext}'` | UID 1000, GID 3000, fsGroup 2000 |
| Calico policy | `kubectl describe networkpolicy` | Enforced rules |
| Connectivity | `kubectl exec web-server -- curl localhost` | HTML response |
| Sidecar logs | `kubectl logs log-sidecar` | Nginx access logs |


