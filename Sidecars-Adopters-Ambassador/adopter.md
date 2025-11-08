Example-Adopter:
------------------

```
apiVersion: v1
kind: Pod
metadata:
  name: adapter-pod
  labels:
    app: statsd-adapter
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9102"
spec:
  containers:
    - name: main-app
      image: busybox
      command: ["sh", "-c", "while true; do echo 'sending metrics'; sleep 10; done"]
    - name: statsd-adapter
      image: prom/statsd-exporter:latest
      ports:
        - containerPort: 9102
      args:
        - "--statsd.listen-udp=:8125"
        - "--web.listen-address=:9102"
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


        
