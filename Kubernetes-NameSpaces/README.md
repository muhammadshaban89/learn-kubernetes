NameSpaces in Kubernetes:
-------------------------

* In Kubernetes, a namespace is a way to divide cluster resources between multiple users or teams.
* It provides isolation, organization, and access control within a single cluster

* A namespace in Kubernetes acts like a virtual cluster inside your physical cluster. 
* It helps you organize and isolate resources such as Deployments, Services, ConfigMaps, and Secrets.
* Isolation: Resources in one namespace don’t interfere with those in another.
* Scoping: Resource names must be unique within a namespace, but can be duplicated across namespaces.
* Access Control: You can apply RBAC (Role-Based Access Control) policies per namespace.

Default Namespaces in Every Cluster:
------------------------------------

When you create a Kubernetes cluster, it comes with four built-in namespaces:

* Default:

    Where resources go if no namespace is specifie.

* kube-system:
     
    System components like kube-dns, kube-proxy.

* kube-public:
   
   Publicly readable resources (e.g., cluster info)

* kube-node-lease:

    Tracks node heartbeats for faster failure detection


Practical Use Cases:
--------------------

Namespaces are especially useful when:

* You’re managing multi-tenant clusters with different teams or projects.
* You want to separate environments (e.g., dev, staging, prod).
* You need fine-grained access control using RBAC.
* You’re automating lab setups and want reproducible resource boundaries.

Common Namespace Commands:
---------------------------

* List all namespaces

     kubectl get namespaces

* Create a new namespace
 
    kubectl create namespace dev-lab

* Use a namespace for a command
   
     kubectl get pods -n dev-lab

* Set default namespace in your context

    kubectl config set-context --current --namespace=dev-lab

Example:
 

	apiVersion: v1
	kind: Namespace
	metadata:
          name: lab-automation
          labels:
            purpose: reproducible-lab
            owner: muhammad
