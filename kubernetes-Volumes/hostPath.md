HostPath:
---------

* In Kubernetes, hostPath is a volume type that mounts a file or directory from the host node’s filesystem directly into a pod.
* It’s powerful but should be used with caution due to potential security and portability concerns.
* It allows a pod to access files or directories on the node where it’s running.
* Useful for accessing system-level resources like logs, Docker sockets, or custom binaries.
* Not portable across nodes unless all nodes have the same directory structure.
* Best for: Trusted workloads, debugging, or when you need access to host-level resources.

Example:
--------
  

    apiVersion: v1
    kind: Pod
    metadata:
      name: hostpath-volume
    spec:
      containers:
        - image: ubuntu
          name: testcon
          command: ["/bin/bash", "-c", "sleep 15000"]
          volumeMounts:
           - mountPath: /tmp/hostpath
             name: testvolume
      volumes:
       - name: testvolume
         hostPath:
            path: /tmp/data 
            type: DirectoryOrCreate

 hostPath.type Option:
 ---------------------

   1-Directory:   Directory must exist.

   2-DirectoryOrCreate:   Creates the directory if it doesn’t exist.

   3-File : File must exist.
   
   4-FileOrCreate:    File must exist.
   
   5-socket:   Must be a UNIX socket.
  
   6-CharDeivice:  Must be a character device.

   7-BlockDevice:   Must be a block device.

Cautions:
---------

* Security risk: Containers can access sensitive host files.
* Node-specific: Ties your pod to a specific node, breaking portability.

Hostpath Practical Example: 
----------------------------

- supose you want to host a sample website  for testing  - but you want to test multiple sites one by one.
- for this you can use hostpth to mount sample websites  html from  a host directory ,directly into pod i.e to container DocumentRoot.
- if you want to access sample-site from outside the cluster you can use service-> "nodePort"


      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx-hostpath-deploy
      spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx-hostpath
        template:
          metadata:
            labels:
              app: nginx-hostpath
        spec:
          containers:
            - name: nginx
              image: nginx:latest
              ports:
                - containerPort: 80
              volumeMounts:
                - name: site-volume
                  mountPath: /usr/share/nginx/html
          volumes:
            - name: site-volume
              hostPath:
                path: /home/ubuntu/sample-site
                type: DirectoryOrCreate    #better to create on worker node and place html content

Expose the Deployment via NodePort

    apiVersion: v1  
    kind: Service
    metadata:
      name: nginx-hostpath-service
    spec:
    type: NodePort
    selector:
      app: nginx-hostpath
    ports:
    - port: 80
      targetPort: 80
      nodePort: 30080

Access Your Site

From outside the cluster:

    http://<worker-node-IP>:30080




