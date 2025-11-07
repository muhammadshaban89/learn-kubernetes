Sidecar,Adapter,Ambassador:
--------------------------


* In Kubernetes, **Sidecar**, **Adapter**, and **Ambassador** are design patterns used to extend or enhance the behavior of applications without modifying their core logic. 
* These patterns are especially useful in microservices architectures. 


1. Sidecar Pattern
-------------------

A **Sidecar** is a helper container that runs alongside the main container in the same Pod. It shares the same network namespace and can augment the main container's functionality.

###  Use Case:

  - Logging agent
  - Proxy (e.g., Envoy)
  - Data sync or backup

### Example: NGINX sidecar for static file serving

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-example
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo Hello from app > /usr/share/nginx/html/index.html && sleep 3600"]
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  volumes:
  - name: shared-data
    emptyDir: {}
```

---

## 2. Adapter Pattern
---------------------

An **Adapter** transforms output from an application into a format that another system understands. This is common in monitoring and metrics collection.

### Use Case:

  - Convert app logs to Prometheus metrics
  - Format legacy output for modern systems

###  Example: Prometheus adapter for custom metrics

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: metrics-adapter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: adapter
  template:
    metadata:
      labels:
        app: adapter
    spec:
      containers:
      - name: adapter
        image: directxman12/k8s-prometheus-adapter-amd64:v0.8.4
        args:
        - --config=/etc/adapter/config.yaml
        volumeMounts:
        - name: config
          mountPath: /etc/adapter
      volumes:
      - name: config
        configMap:
          name: adapter-config
```

> You'd need a `ConfigMap` named `adapter-config` with Prometheus query mappings.

---

## 3. Ambassador Pattern
------------------------


An **Ambassador** acts as a proxy between the application and the outside world or other services. It’s often used to offload cross-cutting concerns like authentication, routing, or TLS termination.

###  Use Case:

  - API gateway
  - Service mesh ingress
  - TLS offloading

###  Example: Ambassador container proxying to external API

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ambassador-example
spec:
  containers:
  - name: app
    image: myapp:latest
    ports:
    - containerPort: 8080
  - name: ambassador
    image: envoyproxy/envoy:v1.25-latest
    args:
    - -c
    - /etc/envoy/envoy.yaml
    volumeMounts:
    - name: envoy-config
      mountPath: /etc/envoy
  volumes:
  - name: envoy-config
    configMap:
      name: envoy-config
```

> The `envoy-config` ConfigMap would define routing rules to forward traffic to the app container or external services.

---

##  Summary Table

| Pattern     | Purpose                          | Example Use Case              | Shared Pod? |
|-------------|----------------------------------|-------------------------------|-------------|
| Sidecar     | Augment app behavior             | Logging, proxy, file sync     | ✅ Yes       |
| Adapter     | Transform app output             | Metrics conversion            | ✅ Yes       |
| Ambassador  | Proxy for external communication | API gateway, TLS termination  | ✅ Yes       |


