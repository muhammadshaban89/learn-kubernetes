🔍 What Is a Liveness?
-----------------------

* In Kubernetes, a liveness probe checks whether a container is still running properly.
* If the probe fails, Kubernetes will automatically restart the container.

🔍 What Is a Liveness Probe?
----------------------------

A liveness probe helps detect situations where a container is "alive" but stuck or unresponsive. For example:

• Deadlocks

• Infinite loops

• Hung processes

If the liveness check fails repeatedly, Kubernetes kills and restarts the container to restore service availability.

Types of Liveness Probes:
------------------------

You can configure liveness probes using one of these methods:
 
* HTTP GET:  Sends an HTTP request to a specified endpoint 
* TCP Socket: Opens a TCP connection to a port.
* Exec Command: Runs a command inside the container.

Example:
-------
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        test: liveness
      name: mylivenessprobe
    spec:
      containers:
        - name: liveness
          image: ubuntu
          args:
          - /bin/sh
          - -c
          - touch /tmp/healthy; sleep 1000
          livenessProbe:                                          
            exec:
              command:                                         
              - cat                
              - /tmp/healthy
          initialDelaySeconds: 5       #Wait time before starting probes.     
          periodSeconds: 5             #Frequency of checks.
          timeoutSeconds: 30           #The number of seconds after which the probe times out if no response is received.
                                         #If the container doesn't respond within this time, the probe is considered failed.

  how to test this :
  
  * apply the manifes  , go inside container , run cat /tmp/health-check , run echo $? , if output is zero it measn its ok, if it returns no zero value it means file dose not exists so probe will fail and it will restart container.                                  

- initialDelaySeconds:

     Wait time before starting probes.
- periodSeconds:

   Frequency of checks.The time (in seconds) between consecutive probe executions.

- failureThreshold:

   Number of failures before restart.
- timeoutSeconds:

   * The number of seconds after which the probe times out if no response is received.
   * Prevents the probe from hanging indefinitely.
   * If the container doesn't respond within this time, the probe is considered failed

✅ Best Practices:
-------------------
- Use different endpoints for liveness and readiness probes.
- Avoid expensive operations in probe handlers.
- Set appropriate timeouts and thresholds to avoid false positives.
- For long startup apps, consider using a startupProbe to delay liveness checks.
