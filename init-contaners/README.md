 Init Containers:
 ----------------

* Init containers in Kubernetes are special containers that run before the main application containers in a Pod. 
* They're perfect for setup tasks like preparing volumes, waiting for services, or injecting configuration.
* Init containers are defined in the Pod spec and run sequentially before the main containers. 
* Each must complete successfully before the next one starts. If any init container fails, the Pod is restarted.


 What Makes Init Containers Special?
---------------------------------------

• Run sequentially: Each init container must complete before the next one starts.
• Run once per Pod: They don’t restart unless the Pod itself restarts.
• Separate from app containers: You can use different images, tools, and permissions.

**Key Features*

• Runs to completion: Unlike regular containers, init containers must finish before the Pod proceeds.
• Multiple init containers: You can define several, and they run in order.
• Separate image and tools: You can use different images and tools than your main app container.
• Used for setup: Common tasks include waiting for a database, setting permissions, or pulling config files

**Common Use Cases:**
----------------------

• Setting up permissions on mounted volumes
• Waiting for a database or service to be ready
• Injecting secrets or config files
• Validating IAM roles or CSI driver readiness.

📄 Example: Init Container That Prepares a Volume:

yaml
```bash
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  initContainers:
  - name: init-volume
    image: alpine
    command: ["/bin/sh", "-c", "echo initializing > /tmp/xchange/init.txt; sleep 30"]
    volumeMounts:
      - name: shared-data
        mountPath: "/tmp/xchange"
  containers:
  - name: main-app
    image: alpine
    command: ["/bin/sh", "-c", "while true; do echo $(cat /tmp/data/init.txt); sleep 5; done"]
    volumeMounts:
      - name: shared-data
        mountPath: /tmp/data
  volumes:
  - name: shared-data
    emptyDir: {}

```
**What above manfiest do:**
----------------------

**Key Components Explained**

🔹 **initContainers:**
yaml
```bash
- name: init-volume
  image: alpine
  command: ["/bin/bash", "-c", "echo initializing > /tmp/xchange/init.txt; sleep 30"]
```
- Runs before the main container starts.
- Uses the alpine image and executes a shell command:
- Writes "initializing" to /tmp/xchange/init.txt
- Sleeps for 30 seconds
- Mounts a shared volume at /tmp/xchange

🔹 **containers**
yaml
```bash
- name: main-app
  image: alpine
  command: ["/bin/bash", "-c", "while true; do echo `cat /tmp/data/init.txt`; sleep 5, done"]

```
- Starts after the init container completes.
- Continuously reads and prints the contents of /tmp/data/init.txt every 5 seconds.
- Mounts the same shared volume at /tmp/data

🔹 **volumes**
yaml
```
- name: shared-data
  emptyDir: {}
```

- Defines a temporary in-memory volume shared between containers.
- Data written by the init container is accessible to the main container.


**Tips:**
----------

- Use init containers to validate IAM role attachment before CSI provisioning.
- - Script dummy file creation or health checks before PVC binding.
- Patch metrics-server or HPA setups with pre-flight checks.
- Script dummy file creation or health checks before PVC binding.
- Patch metrics-server or HPA setups with pre-flight checks.
