Some important commands:
-----------------------------

 To create any object using file.yml
 
     kubectl apply -f filename
To delete any object.

	kubectl delete pod podname
OR
	   
	   kubectl delete -f file.yml

To check pods

    kubectl get pods

To get pod details.

    kubectl get pods -o wide

To pods log

    kubect logs podname
	
To get logs of container running inside 

    kubectl logs -f podname -c containername

To exec commands inside a container.

    kubectl exec -it podname	 -c containername -- /bin/bash

To get details of a pod

    kubectl describe pod podname

To get nodes

    kubectl get nodes

Node in detail

    kubectl get nodes -o wide

To label a node

    kubectl label nodes nodename key=value

Show labels on nodes

    kubelctle get nodes --show-labels 

To remove a lable 
 
    kubectl label nodes nodename label-    

    kubectl label pods podname label-

To get pods as per label

    kubectl get pods -l env=development

To get Pods not as per label

    kubectl get pods -l env!=development

See yaml file of pod

    kubectl get pods -o yaml

edit ymal file of pod

    kubectl edit pods -o yaml

Replica Sets:(get,delete,scale)

     kubectl get rs 
    kubectl get rc
    kubectl delete rc/myrc
	kubectl delete rs/myrs

	kubectl scale --replicas=N rc/myrc
or	
	
	kubectl scale --replicas=N rc -l xyz=abc   # with repect to lable 
 
to scale up rs through deployment 

 	kubectl scale --replicas=3 deploy mydeployments

status/history/rollback
	
  	kubectl rollout status deploy mydeployments

	kubectl rollout history deploy mydeployments

	rollout to last version

	kubectl rollout undo deploy/mydeployments
	

To rollout to a specific version

	kubectl rollout undo deployment mydeployments --to-revision=1
