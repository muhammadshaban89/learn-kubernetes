What is Deployment Object in kubernetes?
-----------------------------------------

A Deployment in Kubernetes is a powerful object that manages the lifecycle of your application pods. 
It provides declarative updates, self-healing, and version control — making it the go-to resource for running stateless workloads.

 What Is a Deployment?

A Deployment defines:

• What your app should look like (image, ports, labels)

• How many replicas should run

• How updates should be rolled out

• How to recover from failures

It automatically creates and manages a ReplicaSet, which in turn manages the actual Pods.

Key Features
-------------------

- Declarative updates: You describe the desired state, Kubernetes makes it happen.
- Rolling updates: Gradually replaces old pods with new ones.
- Rollbacks: Revert to a previous version if something breaks.
- Self-healing: Automatically replaces failed pods.

Example Deployment YAML

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp-deployment
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: myapp
      template:
      metadata:
        labels:
          app: myapp
      spec:
        containers:
        - name: myapp-container
          image: myapp:1.0
          ports:
          -  containerPort: 8080

Naming Conventions
----------------------

Pod Names:

- If created by a ReplicaSet or Deployment, pod names follow this pattern:

      <replicaset-name>-<random-suffix>

- Example: nginx-rs-7d9f4f6c9b-abcde

ReplicaSet Names

- If created by a Deployment, the name includes a hash of the pod template:

      <deployment-name>-<hash>


- Example: nginx-deployment-7d9f4f6c9b

Deployment Names:

- You define this directly in your manifest:

      metadata:
        name: nginx-deployment

What Happens When a Pod Is Deleted?
-----------------------------------

If a pod managed by a ReplicaSet or Deployment is manually deleted:

- Kubernetes automatically creates a new pod to maintain the desired replica count.
- This is part of its self-healing mechanism.
- The new pod will have a different name (new random suffix).

What Happens When a ReplicaSet Is Deleted?
-------------------------------------------

If you delete a ReplicaSet:

- All pods managed by that ReplicaSet are also deleted.
- If the ReplicaSet was created by a Deployment:
- The Deployment notices the RS is gone.
- It recreates a new ReplicaSet with the same pod template.
- This triggers a fresh rollout of pods.

What Happens During a Rollback?
-----------------------------------

When you roll back a Deployment to a previous version in Kubernetes, the ReplicaSet count typically remains the same — meaning:

-	The new ReplicaSet created during rollback will have the same number of replicas as the Deployment's  field.

- 	The old ReplicaSet (from the version you're rolling back from) will be scaled down to zero.

- Kubernetes identifies the previous ReplicaSet that matches the earlier pod template.
- 	It scales up that ReplicaSet to the desired replica count (e.g., 3).
- 	It scales down the current ReplicaSet to zero.
- 	The Deployment’s history is updated to reflect the rollback.

If your Deployment has:
    
    spec:
     replicas: 3
     
Then during rollback:

• 	The previous ReplicaSet is scaled to 3 replicas.

• 	The current (faulty) ReplicaSet is scaled to 0 replicas.

That is ,If your current Deployment has 4 replicas and you roll back to a previous version whose ReplicaSet originally had 2 replicas, the result will be:

    The previous ReplicaSet will be scaled to 4 replicas, not 2.

Why?

• 	Kubernetes rolls back the pod template, not the replica count.

• 	The Deployment’s  field remains unchanged unless you explicitly modify it.

• 	So even if the previous ReplicaSet was created with 2 replicas, during rollback it will be scaled to match the current desired count — which is 4.
 
Summary:
--------

- Pods are ephemeral — they’re replaced if deleted.
- ReplicaSets manage pods — deleting one removes its pods.
- Deployments manage ReplicaSets — deleting a RS under a Deployment triggers healing.
- Naming follows a hierarchy: Deployment → RS → Pod, with hashes and suffixes for uniqueness.
- Rolling back to previous version will not change change rs count to previous state unless you explicitly modify "spec:replicas" field.

Some Importent Commands:
------------------------

To get deployment:

    kubectl get deployment
To check rollout status ,History , 

    kubectl rollout status deploy <deployment-name>

    kubectl rollout history deploy <deployment-name>

To rollout to last version

    kubectl rollout undo deploy/<deployment-name>


To rollout to a specific version

    kubectl rollout undo deployment <deployment-name> --to-revision=1
    
To scale up or dow  replicasets  to "N" numbers:

    kubectl scale --replicas=N deploy <deployment-name>

  
