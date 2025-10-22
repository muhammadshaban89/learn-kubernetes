Blue Green Deployment in K8s:
-----------------------------

* In Kubernetes, the Blue-Green deployment strategy involves running two identical environments—Blue (current) and Green (new) and switching traffic between them to minimize downtime and risk.

* Blue-Green deployment is a zero-downtime release strategy where:
 
- Blue is the live environment serving production traffic.

- Green is the new version deployed in parallel.

- Once validated, traffic is switched from Blue to Green.

This allows:

 - Safe rollbacks if issues arise.

 - Testing in production-like conditions before full release.

 - Minimal impact on users during upgrades.

How to Implement It in Kubernetes
---------------------------------

- Deploy Blue Version
- Your current stable app is running in a Deployment (e.g., blue-deployment) with a Service pointing to it.
- Deploy Green Version
- Create a new Deployment (e.g., green-deployment) with the updated app version.
- Ensure it’s isolated from production traffic initially.
- Smoke Test Green
- Run health checks, integration tests, or manual validation on the Green environment.
- Switch Traffic
- Update the Kubernetes Service selector to point to green-deployment pods.
- This reroutes all traffic to the new version instantly.
- Rollback (if needed)
- Simply re-point the Service back to blue-deployment.
- Consider using Ingress controllers or Service mesh (e.g., Istio) for more granular traffic control.

 Best Practices:
------------------

- Use labels and selectors smartly to manage traffic routing.
- Automate with Helm, GitOps, or CI/CD pipelines.
- Monitor metrics and logs during the switch.

Example:
-------
- Create deployment objects for blue and green depolment using manifes "blue.yml" and "green.yml" (name could be any)
- create a "service" to route trafic


      kind: Deployment
      apiVersion: apps/v1
      metadata:
        name: blue-deploy
      spec:
        replicas: 2
        selector:     
          matchLabels:
          app: apache
          ver: blue
      template:
       metadata:
         labels:
           app: apache
           ver: blue
      spec:
        containers:
          - name: webcon
            image: apache

  Green deploymenet:

      kind: Deployment
      apiVersion: apps/v1
      metadata:
        name: blue-deploy
      spec:
        replicas: 2
        selector:     
          matchLabels:
          app: apache
          ver: green
      template:
       metadata:
         labels:
           app: apache
           ver: blue
      spec:
        containers:
          - name: webcon
            image: apache


Create a service object to route traffic:


    kind: Service                            
    apiVersion: v1
    metadata:
      name: blueservive
    spec:
      ports:
       - port: 80                              
         targetPort: 80  
         nodePort: 30086                  
      selector:
        app: apache
        ver: blue    #initialy routes traffic to blue deployment.
      type:  NodePort

 - For testing purpose change "index.html" of both "blue" and "green" deployment objcets.
 - You can do it by using configMap , but to simplfiy test you can use:

        echo "testing txt" > /usr/local/apache2/htdocs/index.html
   
   to each container running in pod.
   As intially our service object routed trafic to blue , now swicth traffic to "green" deployment using:

       kubectl patch service blueservive  -p '{"spec":{"selector":{"app":"apache","ver":"green"}}}'
   
   curl the ip of node with nodeport i.e 30086. You will find the difference here as it will show you green deployment page.
   


 
 
