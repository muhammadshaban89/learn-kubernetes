Kuberenetes Strategies:
-----------------------

Kubernetes offers several deployment strategies to manage application updates with minimal downtime and risk. 
The most common are Rolling Update, Recreate, Blue-Green, Canary, A/B Testing, and Shadow deployments.

Common Kubernetes Deployment Strategies:
---------------------------------------

1. Rolling Update (Default)
---------------------------

 * How it works:
   
      Gradually replaces old Pods with new ones.
 * Pros:
   
      Minimal downtime, built-in to Deployment objects.
   
 *Use case:
 
   Standard updates for stateless apps.
   
 *Config:
 
 Controlled via "maxUnavailable" and "maxSurge" in the Deployment spec.

2. Recreate
-----------

* How it works:

     Terminates all old Pods before starting new ones.
  
* Pros:
  
     Simple and clean.
  
* Cons:
  
     Causes downtime.
  
* Use case:
  
     Apps that can tolerate downtime or require full teardown.

3. Blue-Green Deployment
------------------------

* How it works:
  
     Deploys new version (green) alongside old (blue), then switches traffic.
  
* Pros:
   
     Instant rollback, zero downtime.

* Cons:

     Requires double resources temporarily.

* Use case:

     Critical apps needing safe transitions.

4. Canary Deployment
--------------------

* How it works:

     Releases new version to a small subset of users first.

* Pros:

    Controlled testing in production.

* Cons:

  Requires traffic routing logic (e.g., Istio, Linkerd).

* Use case:

     Risk-sensitive updates, feature validation.


5. A/B Testing
---------------

* How it works:

     Routes traffic based on user attributes to different versions.

* Pros:

     Real-time comparison of versions.

* Cons:

     Complex setup, needs service mesh or ingress controller.

* Use case: 

     UX experiments, performance benchmarking.

6. Shadow Deployment
--------------------

* How it works:

     New version receives real traffic but doesn’t affect user experience.

* Pros:

    Observes behavior without impact.

* Cons:

    Needs traffic duplication and isolation.

* Use case:

    Load testing, behavior analysis.

Strategy Selection Tip:
-----------------------

* Use Rolling Update for most stateless apps.
* Use Blue-Green or Canary for safer rollouts.
* Use Recreate for apps with strict teardown requirements.
* Use A/B or Shadow for advanced testing and analytics.
