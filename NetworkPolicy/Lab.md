
Deny all ingress:
----------------

1:Create two pods --**nginx-server** and **busybox-client**
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-server
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

```
**busybox-client**
```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-client
  namespace: default
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
```
Check pod-pod connectivity using:
```
kubectl exec busybox-client -- wget -O- 10.244.27.138
```

***Then create "Denny all Policy" and check connectivity.**

```
#• 	 podSelector: {}→ Targets all Pods in the namespace.
#• 	 policyTypes:→ Applies only to incoming traffic.
#• 	No  rules → Means deny all ingress by default.

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

Allow Ingress from Same Namespace:
---------------------------------

To allow traffic from other Pods in the same namespace (e.g., for testing), you could add this policy
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector: {}
```
and run:
```
kubectl exec busybox-client -- wget -O- 10.244.27.138
```
**Note that**

  • 	Without the allow policy: connection fails
  • 	With the allow policy: connection succeeds

**How to List All NetworkPolicies**
```
kubectl get networkpolicy -A
```
**Describe a network Policy**
```
kubectl describe networkpolicy <policy-name> -n <namespace>

```
