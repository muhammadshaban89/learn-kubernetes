
### View and Inspect

- **List all ServiceAccounts in a namespace**:
  ```bash
  kubectl get serviceaccounts -n <namespace>
  ```

- **Describe a specific ServiceAccount**:
  ```bash
  kubectl describe serviceaccount <name> -n <namespace>
  ```

- **View the default ServiceAccount for a namespace**:
  ```bash
  kubectl get serviceaccount default -n <namespace>
  ```

---

### Create and Apply

- **Create a ServiceAccount from YAML**:
  ```bash
  kubectl apply -f serviceaccount.yaml
  ```

- **Create a ServiceAccount directly via CLI**:
  ```bash
  kubectl create serviceaccount <name> -n <namespace>
  ```

---

###  RBAC Binding

- **Create RoleBinding for a ServiceAccount**:
  ```bash
  kubectl create rolebinding <binding-name> \
    --role=<role-name> \
    --serviceaccount=<namespace>:<serviceaccount-name> \
    --namespace=<namespace>
  ```

- **Apply RoleBinding from YAML**:
  ```bash
  kubectl apply -f rolebinding.yaml
  ```

---

###  Token and Access

- **Get the token for a ServiceAccount (Kubernetes 1.24+)**:
  ```bash
  kubectl create token <serviceaccount-name> -n <namespace>
  ```

- **Get the secret associated with a ServiceAccount (pre-1.24)**:
  ```bash
  kubectl get serviceaccount <name> -n <namespace> -o jsonpath='{.secrets[0].name}'
  ```

- **Extract token from secret (pre-1.24)**:
  ```bash
  kubectl get secret <secret-name> -n <namespace> -o jsonpath='{.data.token}' | base64 -d
  ```

---

###  Pod Usage and Validation

- **Deploy a pod using a specific ServiceAccount**:
  ```yaml
  spec:
    serviceAccountName: <name>
  ```

- **Verify which ServiceAccount a pod is using**:
  ```bash
  kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.serviceAccountName}'
  ```

- **Exec into pod and test API access**:
  ```bash
  kubectl exec -it <pod-name> -- sh
  ```

---

### Cleanup

- **Delete a ServiceAccount**:
  ```bash
  kubectl delete serviceaccount <name> -n <namespace>
  ```

- **Delete RoleBinding or Role**:
  ```bash
  kubectl delete rolebinding <name> -n <namespace>
  kubectl delete role <name> -n <namespace>
  ```
