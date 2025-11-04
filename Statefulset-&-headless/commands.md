

kubectl apply -f storageclass.yaml

kubectl get storageclass

kubectl rollout restart statefulset postgres
