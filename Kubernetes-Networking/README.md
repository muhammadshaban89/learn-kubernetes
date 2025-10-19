Kubernetes Networking:
---------------------

Kubernetes networking enables seamless communication between Pods, Services, and external clients, using a flat network model and powerful abstractions like Services, Ingress, and NetworkPolicies.

Core Principles of Kubernetes Networking:
-----------------------------------------

- Each Pod gets a unique IP address:
  No need for port mapping between containers.

- Flat network model:
  All Pods can communicate with each other without NAT.

- Containers in a Pod share the same network namespace:
  They can talk over localhost.

- No IP masquerading between Pods: 
  Direct routing simplifies debugging and traffic flow

Key Networking Components:
--------------------------
- Pod Network:
  Assigns IPs to Pods, enabling direct communication across the cluster.

- Service:
  Provides a stable endpoint (ClusterIP, NodePort, LoadBalancer) for Pods.

- Ingress:
  Manages external HTTP/S access to Services using rules and controllers.

- NetworkPolicy:
  Controls traffic flow between Pods based on labels and rules.

- DNS:
  Automatically resolves Service names to IPs within the cluster.



  Communication Types:
  ---------------------

- Pod-to-Pod:
  
  Handled by the CNI (Container Network Interface) plugin (e.g., Calico, Flannel).

- Pod-to-Service:
  
  Services abstract Pod IPs and offer load balancing.

- External-to-Service:
 
  Ingress or LoadBalancer exposes Services to the outside world.

- Container-to-Container:
  
  Within the same Pod, containers use localhost.

What Is a Kubernetes Service?
-----------------------------

In Kubernetes, a Service is an abstraction that defines a logical set of Pods and a policy by which to access them—essentially acting as a stable endpoint for dynamic workloads


• Purpose: 

  Exposes a set of Pods under a single DNS name and IP address, enabling reliable communication even as Pods are created or destroyed.

• Selector-based: 
  
  Most Services use label selectors to dynamically route traffic to matching Pods.

• Decouples consumers from Pod IPs:
 
 Clients don’t need to track changing Pod IPs.

Types of Services
-----------------

- ClusterIP:
  
  Default. Accessible only within the cluster. Ideal for internal services

- NodePort:
  
  Exposes the Service on a static port on each Node’s IP.

- LoadBalancer:
  
  Provisions an external load balancer (cloud provider dependent).

- ExternalName:
  
  Maps the Service to an external DNS name (no selector or endpoints).

- Headless:
  
  Set "clusterIP: None" to expose Pod IPs directly—used for StatefulSets.



Example YAML

    apiVersion: v1
    kind: Service
    metadata:
      name: my-service
    spec:
      selector:
        app: my-app
    ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
    type: ClusterIP


This exposes Pods with label app=my-app on port 80, forwarding to container port 8080.



