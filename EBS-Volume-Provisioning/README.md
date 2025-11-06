Installing and Configuring AWS EBS CSI Driver for Kubernetes Cluster with Dynamic Provisioning of EBS Volumes:
-----------------------------------------------------------------------------------------------------------------

* Dynamic provisioning in Kubernetes with AWS EBS is enabled via the AWS EBS CSI driver and a properly configured StorageClass that allows automatic volume creation when a Pod requests persistent storage.

* Dynamic provisioning lets Kubernetes automatically create an Amazon EBS volume when a Pod requests storage via a PersistentVolumeClaim (PVC).

  Step_By_Step_Guide:
  --------------------
  
**Prerequisites**

* A running Kubernetes cluster.
* A Kubernetes version of 1.20 or greater.
* An AWS account with access to create an IAM user and obtain an access key and secret key.
* Create a role "ebs-csi-driver" with "AmazonEBSCSIDriverPolicy".
* Security role "ebs-csi-driver" apply to each EC2-instance.


**1-Installing Helm**

Helm is a package manager for Kubernetes that simplifies the deployment and management of applications.

Run the following commands to install Helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
 chmod 700 get_helm.sh
./get_helm.sh
```
**2-Installing AWS EBS CSI Driver**

Create a secret to store your AWS access key and secret key using the following command:
```
kubectl create secret generic aws-secret  --namespace kube-system  --from-literal "key_id=${AWS_ACCESS_KEY_ID}"  --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"
```
**3-Add the AWS EBS CSI Driver Helm chart repository:**

```
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
```
**4-Deploy the AWS EBS CSI Driver using the following command:**
```
helm upgrade --install aws-ebs-csi-driver  --namespace kube-system  aws-ebs-csi-driver/aws-ebs-csi-driver
```

**5-Verify that the driver has been deployed and the pods are running:**
```
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```
***6-Provisioning EBS Volumes**

Create a storageclass.yaml file and apply the storageclass.yaml file using the following command:
```
kubectl apply -f storageclass.yaml
```
**Create a pvc.yaml file and apply the pvc.yaml file using the following command:**
```
kubectl apply -f pvc.yaml
```
**Create a pod.yaml file and apply the pod.yaml file using the following command:**
```
kubectl apply -f pod.yaml
```
**Verify that the EBS volume has been provisioned and attached to the pod:**
```
kubectl exec -it app -- df -h /data
```
The output of the above command should show the mounted EBS volume and its available disk space.
