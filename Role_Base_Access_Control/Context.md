
Overview:
--------

* In Kubernetes (`kubectl`), a **context** is a configuration that defines which **cluster**, **user**, and **namespace** your `kubectl` commands will interact with. 
* It’s part of your kubeconfig file and allows you to switch between different environments easily.

---

### 🔍 What a Context Includes

A context is made up of:

| Component   | Description |
|-------------|-------------|
| **Cluster** | The Kubernetes cluster to connect to |
| **User**    | The credentials used to authenticate |
| **Namespace** | The default namespace for commands |

---

### 📁 Example from `~/.kube/config`

```yaml
contexts:
- name: minikube
  context:
    cluster: minikube
    user: minikube
    namespace: default
- name: jane-context
  context:
    cluster: minikube
    user: jane
    namespace: default
```

---

### 🧪 Common Commands

- **View current context:**
  ```bash
  kubectl config current-context
  ```

- **List all contexts:**
  ```bash
  kubectl config get-contexts
  ```

- **Switch context:**
  ```bash
  kubectl config use-context jane-context
  ```

- **Set default namespace for a context:**
  ```bash
  kubectl config set-context jane-context --namespace=dev
  ```

---

### ✅ Why Contexts Matter

- They let you **switch between clusters** (e.g., dev, staging, prod).
- They help you **test RBAC** by switching users.
- They simplify scripting and automation.
