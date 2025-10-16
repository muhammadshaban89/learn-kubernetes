🧩Environment Variables in Kubernetes
---------------------------------------

Environment variables allow you to store configuration data separately from your application code, making it easier to manage and update your application.
In Kubernetes, environment variables are used to pass configuration data into containers at runtime. 
They help you customize behavior without modifying your application code.

🧩 Ways to Define Environment Variables in Kubernetes

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
