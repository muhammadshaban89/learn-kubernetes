**Ambassador pattern**:
-------------------------

in this example a secondary container acts as a **proxy** between the main application and external services.


##  Ambassador Pattern Pod Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ambassador-pod
  labels:
    app: ambassador-demo
spec:
  containers:
    - name: main-app
      image: hashicorp/http-echo
      args:
        - "-text=Hello from main app"
      ports:
        - containerPort: 5678

    - name: ambassador
      image: alpine/socat
      args:
        - "TCP-LISTEN:8080,fork"
        - "TCP:localhost:5678"
      ports:
        - containerPort: 8080
```


### How It Works?

- **main-app**: A simple HTTP echo server listening on port `5678`.
- **ambassador**: Uses `socat` to listen on port `8080` and forward traffic to `main-app` on `5678`.
- Clients send requests to `8080`, and the ambassador transparently proxies them to the main container.

### How to Test?

1. Deploy the pod:
   ```bash
   kubectl apply -f ambassador-pod.yaml
   ```

2. Port-forward the ambassador:
   ```bash
   kubectl port-forward pod/ambassador-pod 8080
   ```

3. Curl the ambassador:
   ```bash
   curl http://localhost:8080
   ```

You’ll get:
```
Hello from main app
```

**Why Use the Ambassador Pattern?**

- **Decouples external access** from internal logic.

- Enables **TLS termination**, **rate limiting**, or **authentication** in the ambassador.

- Useful for **legacy apps** or **protocol translation**.

