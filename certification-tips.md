# Kubernetes Certification Tips: Common Commands

---

## POD

### Create an NGINX Pod
```sh
kubectl run nginx --image=nginx
```

### Generate POD Manifest YAML file (do not create the Pod)
```sh
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

---

## Deployment

### Create a Deployment
```sh
kubectl create deployment --image=nginx nginx
```

### Generate Deployment YAML file (do not create the Deployment)
```sh
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```

### Generate Deployment with 4 Replicas
```sh
kubectl create deployment nginx --image=nginx --replicas=4
```

### Scale a Deployment using kubectl scale
```sh
kubectl scale deployment nginx --replicas=4
```

### Save Deployment YAML to a file and modify
```sh
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml
```
You can then update the YAML file with the replicas or any other field before creating the deployment.

---

## Service

### Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
```sh
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml
```
(This will automatically use the pod's labels as selectors)

**Or**

```sh
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
```
(This will not use the pod's labels as selectors, instead it will assume selectors as app=redis)

---

### Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes
```sh
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
```
Or
```sh
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
```

---

## Additional Tips

### Create a Redis Pod with a Label
Create a pod named redis using the redis:alpine image and add a label tier=db:
```sh
kubectl run redis --image=redis:alpine -l tier=db
```

### Expose an Existing Pod as a ClusterIP Service
Expose an existing pod as a ClusterIP service named redis-service on port 6379:
```sh
kubectl expose pod existing-po-name --name=redis-service --port=6379 --type=ClusterIP
```

### Create a Deployment with a Specific Image and Replicas
Create a deployment named webapp using the kodekloud/webapp-color image with 3 replicas:
```sh
kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3
```

### Create a Pod with a Custom Port
Create a pod named custom-nginx using the nginx image and expose port 8080:
```sh
kubectl run custom-nginx --image=nginx --port=8080
```

### Create a Namespace
Create a namespace named dev-ns:
```sh
kubectl create ns dev-ns
```

### Create a Deployment in a Specific Namespace
Create a deployment named redis-deploy in the dev-ns namespace using the redis image with 2 replicas:
```sh
kubectl create deployment redis-deploy -n dev-ns --image=redis --replicas=2
```

### Expose a Pod as a ClusterIP Service on Port 80
Expose a pod named httpd as a ClusterIP service on port 80:
```sh
kubectl expose pod httpd --name=httpd --type=ClusterIP --port=80
```
