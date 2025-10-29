Taints and tolerations in Kubernetes:
----------------------------------------

Taints and tolerations in Kubernetes control which pods can be scheduled on which nodes, allowing fine-grained placement and isolation of workloads.


What Are Taints?
----------------

A **taint** is applied to a node to repel pods that don’t explicitly tolerate it. It consists of:

- **Key**:     Identifier for the taint (e.g., `key=dedicated`)
  
- **Value**:   Optional value (e.g., `value=frontend`)
  
- **Effect**:   Determines the behavior (`NoSchedule`, `PreferNoSchedule`, or `NoExecute`)

Example:

	kubectl taint nodes node1 dedicated=frontend:NoSchedule

This means: *“Don’t schedule any pod on `node1` unless it tolerates the `dedicated=frontend` taint.”*



What Are Tolerations?
---------------------

A **toleration** is applied to a pod. It allows the pod to be scheduled on nodes with matching taints.

Example:

    apiVersion: v1
    kind: Pod
    metadata:
      name: mypod
    spec:
    tolerations:
    - key: "dedicated"
      operator: "Equal"
      value: "frontend"
      effect: "NoSchedule"


This pod can now be scheduled on nodes tainted with `dedicated=frontend:NoSchedule`.

⚙️ Taint Effects Explained

* NoSchedule:      Pod won’t be scheduled unless it has a matching toleration               
* PreferNoSchedule: Scheduler avoids the node unless no better options are available     
* NoExecute: Existing pods without toleration are evicted; new ones won’t be scheduled|\


Removing a Taint

To remove a taint:

	kubectl taint nodes node1 dedicated=frontend:NoSchedule-
 
🧠 Use Cases

- **Dedicated nodes**: Reserve nodes for specific workloads (e.g., GPU, logging).
- **Isolation**: Prevent critical workloads from being scheduled on general-purpose nodes.
- **Eviction control**: Use `NoExecute` to evict pods from nodes under maintenance or failure.
