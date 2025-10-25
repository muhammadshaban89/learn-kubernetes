What Is a ConfigMap?
-------------------

* ConfigMaps in Kubernetes are used to store non-sensitive configuration data as key-value pairs, allowing you to decouple configuration from application code.

* A ConfigMap is a Kubernetes object that holds configuration data such as:
 - Environment variables
 - Command-line arguments
 - Configuration files

This allows your containers to be portable and environment-agnostic, since the config is injected at runtime rather than baked into the image.

🔐 Note: ConfigMaps are not secure. For sensitive data, use a Secret instead.


How to Create a ConfigMap:
------------------------

1. From Literal Values
   
        kubectl create configmap my-config   --from-literal=database_host=172.138.0.1  --from-literal=debug_mode=true


2. From a File:

       kubectl create configmap my-config --from-file=config.txt


3. From a Directory

        kubectl create configmap my-config --from-file=/path/to/config-dir/



📥 How to Use a ConfigMap
🔹 As Environment Variables

    envFrom:
    - configMapRef:
      name: my-config


🔹 As Volume Mounts

    volumes:
    - name: config-volume
      configMap:
        name: my-config


🔹 As Command-Line Arguments
    
      args: ["--host=$(DATABASE_HOST)"]

View and Manage:

- List all ConfigMaps:

    	kubectl get configmaps

- Describe a ConfigMap:

	  kubectl describe configmap my-config

- Edit a ConfigMap:

	  kubectl edit configmap my-config

- Delete a ConfigMap:

	  kubectl delete configmap my-config



