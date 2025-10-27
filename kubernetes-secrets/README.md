Kubernetes Secretes:
--------------------

-  Kubernetes Secrets are used to securely store and manage sensitive data like passwords, tokens, and keys within your cluster.
-  Unlike ConfigMaps, Secrets are intended for sensitive content and can be mounted as volumes or exposed as environment variables.
- A Secret is a Kubernetes object designed to hold small amounts of sensitive data such as:
  
  - Passwords
  - OAuth tokens
  - SSH keys
  - TLS certificates
  - They help avoid hardcoding sensitive info into Pod specs or container images.

Types of Secrets:
-----------------

Kubernetes supports several built-in types:

  - Opaque:   Default type for arbitrary key-value pairs.

        kubectl create secret generic db-secret --from-literal=username=dbuser --from-literal=password=Y4nys7f11
    
  - kubernetes.io/dockerconfigjson:     For Docker registry credentials.
    
        kubectl create secret docker-registry docker-secret --docker-email=example@gmail.com --docker-username=dev --docker-password=pass1234 --docker-server=my-registry.example:5000

  - kubernetes.io/tls:     For TLS certs and keys.

        kubectl create secret tls my-tls-secret --cert=/root/data/serverca.crt --key=/root/data/servercakey.pem

  - kubernetes.io/basic-auth: For username/password pairs.

        kubectl create secret generic my-basic-auth --type=kubernetes.io/basic-auth  --from-literal=username=admin  --from-literal=password=secret123
    
 How to Create a Secret?
 -----------------------
 
You can create Secrets using:

- kubectl CLI:---(imperative method)

      kubectl create secret generic my-secret --from-literal=username=admin  --from-literal=password=secret123
  OR

      kubectl create secret generic my-secret2  --from-file=xyz.txt
  
- YAML manifest: --(delerative Method)

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

