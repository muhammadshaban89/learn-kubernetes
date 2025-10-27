Kubernetes Secretes:
--------------------

-  Kubernetes Secrets are used to securely store and manage sensitive data like passwords, tokens, and keys within your cluster.

- A Secret is a Kubernetes object designed to hold small amounts of sensitive data such as:
  
  - Passwords
  - OAuth tokens
  - SSH keys
  - TLS certificates
  - They help avoid hardcoding sensitive info into Pod specs or container images.

Types of Secrets:
-----------------

Kubernetes supports several built-in types:

  - Opaque: Default type for arbitrary key-value pairs.
  - kubernetes.io/dockerconfigjson: For Docker registry credentials.
  - kubernetes.io/tls: For TLS certs and keys.
  - kubernetes.io/basic-auth: For username/password pairs.
    
 How to Create a Secret?
 -----------------------
 
You can create Secrets using:

- kubectl CLI:

      kubectl create secret generic my-secret --from-literal=username=admin  --from-literal=password=secret123
  
- YAML manifest:

      apiVersion: v1
      kind: Secret
      metadata:
        name: my-secret
        type: Opaque
      data:
        username: YWRtaW4=   # base64 encoded
        password: c2VjcmV0MTIz

How Secrets Are Used?
--------------------

Secrets can be consumed by Pods in three ways same as configMaps

  - Environment variables
  - Mounted volumes
  - Used directly by system components (e.g., kubelet pulling images from a private registry).

⚠️ Security Considerations
---------------------------

- Not encrypted by default in etcd (unless encryption at rest is enabled).
- Base64 encoding ≠ encryption — it’s just encoding.
- Avoid checking Secrets into version control.
- Use tools like Sealed Secrets (Bitnami) for encrypted GitOps workflows.

Best Practices:
---------------

- Enable encryption at rest for Secrets in etcd.
- Use RBAC to restrict access.
- Rotate Secrets regularly.
- Prefer external secret managers (e.g., HashiCorp Vault, AWS Secrets Manager) for high-security environments.
- Audit access and usage patterns.

Would you like a checklist for integrating Secrets into your OCI DevOps pipelines or microservices? I can also help you script secure Secret creation and consumption
