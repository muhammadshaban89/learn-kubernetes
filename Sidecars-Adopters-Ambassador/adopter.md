Example-Adopter:
------------------

```
apiVersion: v1
kind: Pod
metadata:
  name: adapter-pod
  labels:
    app: metrics-demo
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9090"
spec:
  containers:
    - name: main-app
      image: muhammaddev/myapp:latest
      ports:
        - containerPort: 8080
      env:
        - name: METRICS_ENABLED
          value: "true"
    - name: metrics-adapter
      image: muhammaddev/metrics-adapter:latest
      env:
        - name: TARGET_PORT
          value: "8080"
        - name: FORMAT
          value: "prometheus"
      ports:
        - containerPort: 9090
      readinessProbe:
        httpGet:
          path: /metrics
          port: 9090
        initialDelaySeconds: 5
        periodSeconds: 10
```
How  Works as an Adapter:
-------------------------

 **Input: StatsD Metrics**
  • 	The main container emits metrics in StatsD format (UDP packets).
  • 	These are lightweight, fast, and common in legacy apps or microservices.
  
  **Adapter Role**
  
  - The statsd-exporter container listens on UDP port 8125 for incoming StatsD metrics.
  - It parses and transforms those metrics into Prometheus exposition format.

**Output: Prometheus-Compatible Metrics:**

  - The adapter exposes transformed metrics on HTTP port 9102 at /metrics.
  - Prometheus scrapes this endpoint to ingest metrics in its native format.

** Why This Is an Adapter?**

  - It adapts one protocol (StatsD) into another (Prometheus).
  - It does not interfere with the main app logic.
  - It adds observability without modifying the main container.


        
