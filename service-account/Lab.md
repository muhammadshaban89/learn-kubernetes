Example:
---------

- Create a custom `ServiceAccount`
- Bind it to a Role with limited permissions
- Deploy a pod that uses this ServiceAccount
- Validate access control using `kubectl exec`

---

### Lab: ServiceAccount with RBAC in Action

This setup includes:

1. A `ServiceAccount` named `pod-reader`
2. A `Role` that allows listing and getting pods
3. A `RoleBinding` to bind the Role to the ServiceAccount
4. A test pod using the ServiceAccount to try accessing the Kubernetes API

---

### Full Manifest (`serviceaccount-lab.yaml`)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-reader
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: read-pods
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: pod-reader
  namespace: default
roleRef:
  kind: Role
  name: read-pods
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: Pod
metadata:
  name: sa-test-pod
  namespace: default
spec:
  serviceAccountName: pod-reader
  containers:
  - name: curl
    image: curlimages/curl:8.4.0
    command: ["sleep", "3600"]
```

---

### How to Deploy and Test?
--------------------------

1. **Apply the manifest**:

   ```bash
   kubectl apply -f serviceaccount-lab.yaml
   ```

2. **Verify the pod is running**:

   ```bash
   kubectl get pods
   ```

3. **Exec into the pod and test API access**:

   ```bash
   kubectl exec -it sa-test-pod -- sh
   ```

   Inside the pod:

   ```sh
   TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
   curl -sSk -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/namespaces/default/pods
   ```

   ✅ You should see a list of pods — because the Role allows `get` and `list` on pods.

4. **Try accessing something unauthorized**:

   ```sh
   curl -sSk -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/namespaces/default/secrets
   ```

   ❌ You should get a `403 Forbidden` — because the Role doesn't allow access to secrets.

Note:
----

**please check seperate  yaml manifests for role,serviceaccont, roleBinding and pod examples**

**deployment Order**
```
kubectl apply -f serviceaccount.yaml
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml
kubectl apply -f pod.yaml
```
OR:

```
kubectl apply -f ./manifests/
```

**Importent**
--------------

* when a pod i created , default serviceaccount automatically associated with pod.
* You can check by :
```
kubectl decribe pod pod-name | grep -i default
```
and a token is mounted to mount ,which you can check by:
```
kubectl decribe pod pod-name | grep -i serviceaccount
```
which shows:
```
/var/run/secrets/kubernetes.io/serviceaccount
```
If you want that pod not use this defalt service account- in specs mention:

```yaml
specs:
  automountServiceAccountToken: false
```
after this even when you describe the pod, despite showing "serviceaccout=defult" k8s will not mount any token.



