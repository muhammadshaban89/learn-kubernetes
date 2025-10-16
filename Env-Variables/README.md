✅Environment Variables in Kubernetes
---------------------------------------

Environment variables allow you to store configuration data separately from your application code, making it easier to manage and update your application.
In Kubernetes, environment variables are used to pass configuration data into containers at runtime. 
They help you customize behavior without modifying your application code.

✅ Ways to Define Environment Variables in Kubernetes

✅ 1. Static Key-Value Pairs

Defined directly in the pod or deployment manifest:

    env:
      - name: LOG_LEVEL
        value: "debug"
        
✅ 2. From ConfigMap

Inject values from a ConfigMap:

    envFrom:
      - configMapRef:
        name: app-config
        

Or reference a specific key:

env:
  
    - name: APP_PORT
      valueFrom:
      configMapKeyRef:
        name: app-config
        key: port
        
✅ 3. From Secret

Securely inject sensitive data:

    env:
    - name: DB_PASSWORD
      valueFrom:
      secretKeyRef:
        name: db-secret
        key: password

✅ 4. From Pod Metadata (FieldRef)

Dynamically pull values from the pod itself:

    env:
    - name: POD_NAME
      valueFrom:
      fieldRef:
        fieldPath: metadata.name

✅Examples:
---------

Prerequisites

Before getting started, you need to have the following:

- A Kubernetes cluster up and running

- A Docker image of your application.

Yaml manifest:
------------
    apiVersion: v1
    kind: Pod
    metadata:
      name: env-var-2
      labels:
        purpose: demonstrate-env-var-2
    spec:
      containers:
      - name: env-var
        image: wordpress
        env:
        - name: WORDPRESS_VERSION
          value: "5.2.2"
        - name: WORDPRESS_USER
          value: "ubuntu"
        command: ["echo"]
        args: ["$(WORDPRESS_VERSION) $(WORDPRESS_USER)"]

To print environment variables:

    kubectl exec <pod-name> -- printenv
    
 You can use grep to filter output   

     kubectl exec <pod-name> -- printenv |  grep -i  WORDPRESS_VERSION

🔑 Common Use Cases for env in K8s
------------------------------------

- Configuration Management:  Pass runtime settings like log levels, feature flags, or app modes
- Secrets Injection: Securely inject credentials using Kubernetes Secrets
- Service Discovery: Provide internal service endpoints or ports to containers
- Environment Differentiation: Distinguish between dev, staging, and prod setups
- Metadata Access: Inject pod or node info (e.g., pod name, namespace) using fieldRef
- Bulk Config Injection: Load multiple variables from a ConfigMap or Secret using envFrom
- Tooling & Automation: Set paths, flags, or credentials for CLI tools and automation scripts

