Security Context:
----------------

* A security context defines privilege and access control settings for a Pod or Container. Security context settings include, but are not limited to:

*  **Discretionary Access Control:** Permission to access an object, like a file, is based on user ID (UID) and group ID (GID).

* **Security Enhanced Linux (SELinux)**: Objects are assigned security labels.

* Running as privileged or unprivileged.

* **Linux Capabilities:** Give a process some privileges, but not all the privileges of the root user.

* **AppArmor:** Use program profiles to restrict the capabilities of individual programs.

* **Seccomp:** Filter a process's system calls.

* **allowPrivilegeEscalation:** Controls whether a process can gain more privileges than its parent process. This bool directly controls whether the no_new_privs flag gets set on the container process. allowPrivilegeEscalation is always true when the container:
is run as privileged, or
has CAP_SYS_ADMIN

* **readOnlyRootFilesystem: Mounts** the container's root filesystem as read-only.

**In Kubernetes, a *SecurityContext* defines privilege and access control settings for a Pod or Container.** It’s a critical tool for enforcing least privilege, isolating workloads, and hardening your cluster against attacks.

---

### What Is a SecurityContext?

A `securityContext` is a field in the Pod or Container spec that controls:

- **User and group IDs**: Specify which Linux user (`runAsUser`) or group (`runAsGroup`, `fsGroup`) the container runs as.
- **Privilege escalation**: Prevent processes from gaining more privileges than their parent (`allowPrivilegeEscalation: false`).
- **Root access**: Enforce non-root execution (`runAsNonRoot: true`).
- **Linux capabilities**: Drop or add specific kernel capabilities (e.g., `NET_ADMIN`, `SYS_TIME`).
- **SELinux/AppArmor profiles**: Apply mandatory access control policies.
- **Seccomp profiles**: Restrict system calls the container can make.

---

### Pod vs Container-Level SecurityContext

- **Pod-level**: Applies to all containers in the Pod (e.g., `fsGroup`, `runAsUser`).
- **Container-level**: Overrides Pod-level settings for that specific container.

Example:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
    securityContext:
      allowPrivilegeEscalation: false
```

---

###  Best Practices

- **Always set `runAsNonRoot: true`** unless root is absolutely required.
- **Drop all Linux capabilities** and add only what’s needed.
- **Use seccomp and AppArmor profiles** to restrict syscall and binary behavior.
- **Avoid `privileged: true`** unless you fully trust the workload.

