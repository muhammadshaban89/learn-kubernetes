
## What is a Kubernetes Network Policy?
---------------------------------------

* Kubernetes Network Policies let you control Pod-to-Pod and Pod-to-external traffic using label selectors and rules for ingress and egress. They're enforced by your CNI plugin (e.g., Calico, Cilium) and are essential for securing microservices.**

* A **NetworkPolicy** is a Kubernetes resource that defines how groups of Pods are allowed to communicate with each other and with external endpoints. By default, all Pods can talk to each other. Once a NetworkPolicy is applied, only explicitly allowed traffic is permitted.

> ⚠️ Requires a CNI plugin that supports NetworkPolicy (e.g., Calico, Cilium, Weave Net).


## Basic Example: Deny All Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

This blocks all incoming traffic to Pods in the `default` namespace unless explicitly allowed.


##  Allow Ingress from Specific Pod

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-nginx-from-frontend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: nginx
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
  policyTypes:
  - Ingress
```

Only Pods with label `role=frontend` can access Pods labeled `app=nginx`.

---

## Allow Egress to DNS and HTTPS

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-https-egress
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 443
```

Allows DNS (UDP 53) and HTTPS (TCP 443) traffic from `myapp` Pods.

---

## Best Practices

- **Start with deny-all policies**, then allow specific traffic.
- Use **labels consistently** for Pod selectors.
- Test policies using tools like `netshoot` or `kubectl exec`.
- Monitor with CNI plugins like **Calico** or **Cilium** for visibility.

ingress and egress:
---------------------

In Kubernetes **Network Policies**, **ingress** and **egress** define the direction of traffic that is allowed to or from Pods. 

## Ingress vs Egress in NetworkPolicy

| Direction | Description | Example |
|----------|-------------|---------|
| **Ingress** | Controls **incoming** traffic **to** Pods | Allow traffic from a frontend Pod to a backend Pod |
| **Egress** | Controls **outgoing** traffic **from** Pods | Allow traffic from a Pod to an external database or DNS |

---

## Ingress Example: Allow traffic from specific Pods

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 80
```

✅ This allows Pods with `role=frontend` to access `app=backend` Pods on TCP port 80.

---

## egress Example: Allow DNS and HTTPS traffic

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-egress-dns-https
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Egress
  egress:
  - to:
    - ports:
      - protocol: UDP
        port: 53
      - protocol: TCP
        port: 443
```

✅ This allows Pods labeled `app=myapp` to access DNS (UDP 53) and HTTPS (TCP 443).

---

## Key Notes
------------

- If no NetworkPolicy exists, **all traffic is allowed**.
- Once a policy is applied to a Pod, **only allowed traffic is permitted**.
- You can define both `ingress` and `egress` in the same policy.
- Use `namespaceSelector` to allow traffic across namespaces.

**Kubernetes Network Policies are only enforced by CNI plugins that support them—Flannel does not support NetworkPolicy by itself, but Calico, Cilium, and others do.**

---

## CNI Plugins That Support NetworkPolicy:
--------------------------------------------

| CNI Plugin     | NetworkPolicy Support | Notes |
|----------------|------------------------|-------|
| **Calico**     | ✅ Full support         | Most widely used for fine-grained security and policy enforcement |
| **Cilium**     | ✅ Full support         | Uses eBPF for high-performance policy enforcement and observability |
| **Canal**      | ✅ Full support         | Combines Flannel (for networking) + Calico (for policy) |
| **Weave Net**  | ✅ Partial support      | Supports basic NetworkPolicy features |
| **Flannel**    | ❌ No support           | Simple overlay network; use Canal if you need policy enforcement |
| **Multus**     | ✅ With secondary plugin| Multus itself is a meta-plugin; policy support depends on underlying plugin (e.g., Calico) |

---

## Recommendations:
-------------------

- **For production clusters**, use **Calico** or **Cilium** for robust policy enforcement.
- If you're using **Flannel**, consider switching to **Canal** to retain Flannel’s simplicity while gaining Calico’s policy features.
- Always verify that your CNI plugin is properly configured to enforce NetworkPolicies—some require additional setup.




