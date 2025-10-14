Whats is pod in K8S?
--------------------

In Kubernetes (K8s), a pod is the smallest and most basic deployable unit. It represents a single instance of a running process in your cluster. You can think of it as a wrapper around one or more containers that share the same network namespace and storag

🧩 Key Features of a Pod
-------------------------

• One or more containers:
Most pods run a single container, but you can run multiple tightly coupled containers (e.g., sidecars).

• Shared resources:

• Network: 

All containers in a pod share the same IP address and port space.

• Volumes: 

Shared storage can be mounted across containers.
 
Ephemeral by design: 

Pods are not meant to be long-lived. If a pod dies, Kubernetes can replace it via controllers like Deployments or ReplicaSets.

Real-World Analogy.
-------------------

Think of a pod like a shipping container:

• 	It holds your application (the container).

• 	It travels with its own network and storage.

• 	Kubernetes is the logistics system that deploys, tracks, and replaces these containers as needed.

pod commands:
-------------

🚀 Pod Lifecycle Commands.(run, get,describe,delete pods)

    kubectl run mypod --image=nginx --restart=Never 
    kubectl get pods 
    kubectl get pods -n <namespace> 
    kubectl describe pod <pod-name> 
    kubectl delete pod <pod-name> 
    
🔍 Pod Inspection & Debugging

    kubectl logs <pod-name> 
    kubectl logs <pod-name> -c <container-name> 
    kubectl exec -it <pod-name> -- bash 
    kubectl port-forward <pod-name> 8080:80 
    kubectl get pod <pod-name> -o wide 

🧪 Advanced Pod Usage

    kubectl run debug --image=busybox --restart=Never --command -- sleep 3600 
    kubectl apply -f pod.yaml 
    kubectl delete pods -l app=myapp 
    kubectl get pods --watch 














