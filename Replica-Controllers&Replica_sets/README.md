Overview
--------

In Kubernetes, ReplicaSets and ReplicationControllers are both used to ensure that a specified number of pod replicas are running at any given time. 
But they differ in capabilities and usage — let’s break it down:

What Is a ReplicationController?
--------------------------------

- Legacy controller used in early Kubernetes versions.
- Ensures a fixed number of pod replicas are running.
- Uses equality-based selectors only (e.g., app=nginx).
- Mostly replaced by ReplicaSets and Deployments.

📌 Example:
  
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: nginx-rc
    spec:
      replicas: 3
      selector:
        app: nginx
      template:
      metadata:
        labels:
          app: nginx
      spec:
      containers:
        - name: nginx
          image: nginx

What Is a ReplicaSet?
--------------------

- Modern replacement for ReplicationController.
- Supports set-based selectors (e.g., In, NotIn, Exists).
- Usually managed by a Deployment (you rarely use it directly).
- Enables rolling updates and rollbacks via Deployments.
  
📌 Example:

    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
      name: nginx-rs
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
         - name: nginx
           image: nginx
           
🔍 Key Differences

Recplica Controller :

  - Uses only equality based selectors.
  - manual rolling updates.
  - API Version "v1"
  - usage is Deprecated.
    
Replica Sets : 
 - supports both Equality + Set-based selectors.
 - Rolling update vis Deployment object.
 - usage vis deployment.
 - API version "apps/v1".

Key difference between Pods, Replica controllers and replica sets.
------------------------------------------------------------------
Pods:

A Pod is the smallest deployable unit in Kubernetes. It wraps one or more containers that share the same network namespace and storage. 
Pods are ephemeral — if a pod crashes or is deleted, it won’t come back unless something is managing it. You typically use standalone pods for testing, debugging, or very simple workloads.

ReplicationController (RC):

A ReplicationController is an older Kubernetes object that ensures a specified number of pod replicas are running at all times. 
If a pod dies, the RC creates a new one. It uses equality-based label selectors to identify which pods it manages. While it served its purpose in early Kubernetes versions, it’s now considered deprecated and replaced by ReplicaSets.

ReplicaSet (RS)

A ReplicaSet is the modern version of ReplicationController. It also ensures a fixed number of pod replicas are running, but it supports more flexible label selectors — including set-based expressions like “In”, “NotIn”, and “Exists”. ReplicaSets are rarely used directly; instead, they’re managed by Deployments, which add rolling updates, rollbacks, and declarative management.

Summary :
------------
• 	Pods are the actual running containers, but they don’t self-heal.

• 	ReplicationControllers were the original way to keep pods alive, but they’re outdated.

• 	ReplicaSets do the same job as RCs but with more flexibility and are typically used under the hood by Deployments.

Importent Commands:
------------------

To get, delete replica-set and replica controller

    kubectl get rs 
    kubectl get rc
    kubectl delete rc/myrc
    kubectl delete rs/myrs
To scale replicas

    kubectl scale --replicas=N rc/myrc
  or
    
    kubectl scale --replicas=N rc -l xyz=abc   # with repect to lable 
  
To scale up rs through deployment 

    kubectl scale --replicas=3 deploy mydeployments

status

    kubectl rollout status deploy mydeployments

    kubectl rollout history deploy mydeployments

rollout to last version

    kubectl rollout undo deploy/mydeployments
    
To rollout to a specific version

    kubectl rollout undo deployment mydeployments --to-revision=1

