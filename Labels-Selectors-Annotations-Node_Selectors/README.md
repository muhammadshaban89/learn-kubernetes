
📝 What are  Labels in Kubernetes?
--------------------------------

Labels are key-value pairs attached to Kubernetes objects (like pods, nodes, services) that help you identify and group resources.

✅ Use Cases:

• Select pods for a Deployment or Service

• Filter resources.

• Organize environments.

📌 Example:

    metadata:
      labels:
        app: nginx
        env: production

📝 What are Annotations?
-------------------------

Annotations are also key-value pairs, but they’re used to store non-identifying metadata — things that don’t affect selection or scheduling.

✅ Use Cases:

- Attach build info, version, or contact details
- Store external tool data (e.g., monitoring configs)
- Add notes for automation or CI/CD systems

📌 Example:

    metadata:
      annotations:
        buildVersion: "v1.2.3"
        maintainer: "Muhammad Shaban"



📝 what are  Node Selectors ?
------------------------------

Node selectors are used to schedule pods onto specific nodes based on labels assigned to those nodes.

✅ Use Cases:

- Run workloads on GPU nodes, SSD-backed nodes, or specific zones
- Separate dev/test/prod environments
- Target nodes with custom hardware or compliance needs

📌 Example:

Label your node:

    kubectl label nodes node-1 disktype=ssd


Then in your pod spec:

    spec:
      nodeSelector:
        disktype: ssd

📝 what are Selectors ?
-----------------------

Selectors in Kubernetes are expressions used to identify and match sets of objects based on their labels. 
They’re essential for grouping, filtering, and managing resources like pods, services, deployments, and more.

🧩 Types of Selectors

1. Label Selectors

These match objects based on their labels.

• Equality-based:

Example: - Matches objects with app=nginx.

    matchLabels:
      app: nginx

• Set-based: Matches objects where  "tier" is either "frontend"  or in "backend".

    matchExpressions:
    - key: tier
      operator: In
      values:
        - frontend
        - backend

2. Field Selectors.

These match objects based on resource fields (not labels).

Example:

    kubectl get pods --field-selector status.phase=Running
    
Used for:

• Filtering by status, name, or node.
• Scripting and automation.

 Real-World Use Cases
-----------------------

 - Target pods for a service.
 - Filter running pods
 - Schedule pods to labeled nodes
 - Apply network policy to group
 

Examples.
--------

Labels:

    kind: Pod
    apiVersion: v1
    metadata:
      name: mypod1
      labels:
        env: development
        class: pods
    spec:
      containers:
        - name: cont1
          image: ubuntu
          command: ["/bin/bash", "-c", "while true; do echo Hello-World; sleep 5 ; done"]

Description:

Above manifest will create a pod "mypod1" with labels "env=development, class=pods".You can verify it by:

    kubectl get pods --show-labels
    
Labels make easy to filter selection as per desire,for example to delete a pod with matching labels.

        kubectle delete pods -l class=pods

Nodes Selectors:

    kind: Pod
    apiVersion: v1
    metadata:
      name: nodeselector
      labels:
        env: development
    spec:
      containers:
        - name: c2
          image: ubuntu
          command: ["/bin/bash", "-c", "while true; do echo Learn-Nodeselectors; sleep 5 ; done"]
      nodeSelector:                                         
        env: development

Description:

Above manifest will create a pod "nodeselector" on a node havig label "env=development".

Pode will not be created & remain pending if no matching labels on node. Node selectors are usefull if you want to deploy a pod on a specfic node for any reason i.e for testing.

To label a node

    kubectl label nodes node_name key=value
    kubectl label nodes nodeselector env=development
    

