emptyDir:
--------
* In Kubernetes, emptyDir is a simple, temporary volume type that’s created when a pod starts and deleted when the pod stops. 
* It’s ideal for scratch space, caching, or sharing files between containers in the same pod.
* Lifecycle:
  
    Created when the pod is assigned to a node; deleted when the pod is removed.
* Storage Location:
  
    By default, stored on the node’s filesystem (), but can be backed by memory ().
* Use Case:
  
     Temporary storage for logs, caches, or inter-container communication

Why Use emptyDir?
-----------------

* Scratch space: Temporary files during processing.
* Shared data: Between containers in the same pod.
* Performance: RAM-backed volumes for speed-sensitive tasks


Example
-------
 
    apiVersion: v1
    kind: Pod
    metadata:
      name: emptydir-demo
    spec:
    containers:
      - name: app
        image: ubuntu
        command: ["sh", "-c", "echo Hello > /data/hello.txt && sleep 3600"]
        volumeMounts:
         - name: temp-storage
           mountPath: /data
    volumes:
     - name: temp-storage
       emptyDir: {}
 
Optional: In-Memory Storage
 
	emptyDir:
          medium: Memory

This stores the volume in RAM, making it faster but volatile.
