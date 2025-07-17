# KUBERNETES COMMANDS REFERENCE

## KIND (Kubernetes in Docker)
1. `kind create cluster --name cluster_name --config ./Kind/cluster.yaml`
2. `kind get clusters`

## KUBECTL
**Format:** `kubectl command resource_type resource_name`

### General Commands
1. `kubectl api-resources` => List all available API resources
2. `k explain resource_name --recursive` => Get detailed documentation for all fields of a resource recursively
- `kubectl get all -o wide` => Get detailed information about all resources (pods, services, deployments, etc.)\

## NODES
1. `kubectl get nodes` => List all nodes
2. `kubectl get nodes -o wide` => Detailed node information
3. `kubectl describe node node_name` => Detailed information about specific node
4. `kubectl get events` => View cluster events
5. `kubectl api-resources` => List all API resources

## K9s
**Visualization TUI (Terminal User Interface) Tool** for Kubernetes

## PODS
1. `kubectl run nitin --image nginx` => Create pod imperatively
2. `kubectl get pods` => List all pods
3. `kubectl get pod --show-labels` => List all pods and display their labels
4. `k get pod -l env=dev` => List all pods with the label 'env=dev' in the current namespace
5. `k get all -l env=prod` => List all resources with the label 'env=prod' in the current namespace
6. `k get all -l bu=finance -l env=prod -l tier=frontend` => List all resources with the labels 'bu=finance', 'env=prod', and 'tier=frontend' in the current namespace
7. `kubectl describe pod nitin` => Detailed pod information
8. `kubectl get pods -o wide` => Detailed pod information with node info
9. `kubectl edit pod nitin` => Edit pod in default editor
10. `kubectl apply -f pod.yaml` => Apply pod from YAML file
11. `kubectl create -f pod.yaml` => Create pod from YAML file (will update existing pod)
12. `kubectl delete pod nitin1` => Delete specific pod
13. `kubectl run nitin1 --image nginx --dry-run=client -o yaml` => Generate YAML template without creating
14. `kubectl describe pod > description.yaml` => Save pod description to file
15. `kubectl get pod nitin -o yaml > detail.yaml` => Save pod YAML to file
16. `kubectl delete -f pod.yaml` => Delete pod(s) defined in a YAML file
17. `kubectl apply -f pod.yaml --dry-run=server` => Validate pod.yaml against the live API server without applying
18. `kubectl apply -f pod.yaml --dry-run=client` => Validate pod.yaml locally (client-side) without applying
19. `kubectl diff -f pod.yaml` => Show differences between the current cluster state and the pod.yaml file
20. `kubectl exec -it pod_name -c container_name -- sh` => Access a specific container in a pod using sh shell
21. `k label pod pod_name label-` => Remove a specific label from a pod
22. `k delete pods --all` => Delete all pods in the current namespace

### IMPORTANT: kubectl exec (NEVER use in production)
23. `kubectl exec -it pod_name -- bash` => **NEVER use in production: pods are ephemeral (changes lost on restart) + security risk (privilege escalation)**

## EPHEMERAL CONTAINERS
**Definition:** Ephemeral containers are temporary containers that run alongside existing containers in a pod for debugging purposes.

### Debug Command
20. `kubectl debug pod_name -it --image=busybox --target=container_name -- bash`

### Image Options
- `--image=busybox` => Specifies which Docker image to use for the debug container
  - **busybox** is popular because it's small and has basic debugging tools
  - **Other common options:** alpine, ubuntu, centos

### What This Command Does:
- Creates a temporary container in the specified pod
- Shares the network with the pod (can access same services)
- Shares the process namespace with the target container
- Gives you an interactive shell to debug
- Container disappears when you exit or pod restarts

### IMPORTANT LIMITATION:
**YOU CAN'T KILL EPHEMERAL CONTAINER UNLESS YOU KILL THE ORIGINAL POD!**

# TRIVY
1. `trivy image image_name` => Scan a Docker image for vulnerabilities
2. `trivy image image_name --severity CRITICAL/HIGH/LOW` => Scan image and filter results by severity level

# KYVERNO
Kyverno is a Kubernetes-native policy engine that allows you to tweak and extend the Kubernetes admission controller. It enables you to define, validate, mutate, and generate configurations using policies as Kubernetes resources.
**Pre-requisite:**

1. **Install Helm:**
   - On Linux/macOS:
     `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash`
   - On Windows (using Chocolatey):
     `choco install kubernetes-helm`
2. `helm repo add kyverno https://kyverno.github.io/kyverno/` => Add the Kyverno Helm repository
3. `helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace` => Install Kyverno in the 'kyverno' namespace

### Kyverno Components Installed

| Component             | Purpose/Use                                                                  |
|-----------------------|------------------------------------------------------------------------------|
| CRDs                  |  Increase functionality of kubernetes api                                    |
| Admission Controller  | Enforce policies on resource creation/update                                 |
| Reports Controller    | Generate compliance and policy violation reports                             |
| Cleanup Controller    | Automate deletion of resources based on policies                             |
| Background Controller | Apply policies to existing resources, not just new/updated ones              |

### Kyverno Use Cases
- Restrict usage to a particular image
- Add a specific label to resources
- Specify CPU and memory requirements for workloads

**How to apply**
- To apply a Kyverno policy, you typically create a `kyverno_policy.yaml` file. 
- Most policies are adapted or tweaked from the official Kyverno documentation to fit your specific requirements.
- **Note:** Generally, validating policies are applied rather than mutating policies.

**Commands:**
- `kubectl apply -f policy.yaml` => Apply a Kyverno policy
- `kubectl get policyreports` => View policy compliance reports

# KUBE-LINTER

KubeLinter is a static analysis tool that checks Kubernetes YAML files (like Pod, Deployment, etc.) for security and best-practice issues before they are applied to a cluster. Here are some common suggestions KubeLinter would make to improve the security of your YAML files:

## Commands
- `kube-linter lint file-name.yaml` => Lint a specific Kubernetes YAML file for security and best-practice issues

# KUBE-BENCH

Kube-bench scans cluster components (API server, etcd, scheduler, controller-manager, kubelet, kubectl) .

## Command
- `kube-bench` => Run security checks on cluster components as per CIS Kubernetes Benchmark

# STATIC PODS

- Managed by kubelet instead of the API server
- Restart automatically without asking the kube-apiserver
- The location of static pod manifests is defined in `/var/lib/kubelet/config.yaml`, with the default path being `/etc/kubernetes/manifests`

## DAEMONSET

A DaemonSet ensures that a specific pod runs on all (or selected) nodes in a Kubernetes cluster.
It is considered a more flexible and manageable alternative to Static Pods.

## Commands
- `kubectl get daemonsets` => List all DaemonSets
- `kubectl describe daemonset daemonset_name` => Detailed information about a specific DaemonSet
- `kubectl apply -f daemonset.yaml` => Apply a DaemonSet from YAML file
- `kubectl delete daemonset daemonset_name` => Delete a DaemonSet

# INIT-CONTAINER

- Runs before the main application container in a Pod
- Each must run successfully for the application container to start
- Multiple init containers can be defined and run sequentially
- Once an Init Container runs successfully, it exits and does not run again unless the Pod restarts

## Command
- `k apply -f init-container.yaml` => Apply a Pod spec with Init Containers

# SIDECAR CONTAINER

Same as init container but it does not terminate automatically  after it's execution instead stay with main container.

## 🚨 Common Mistake
People think:

"I'm converting an initContainer to sidecar → let me just copy it and add restartPolicy: Always to the container block."

That's wrong — the container block doesn't allow restartPolicy.

Instead, simply move it to containers: and ensure it has a long-running process (sleep, while true, etc.).

## Commands
- `kubectl exec -it pod_name -- bash` => Access the main application container in a Pod
- `kubectl exec -it pod_name -c container_name -- bash` => Access a specific container (e.g., sidecar) in a Pod

# INIT CONTAINER vs SIDECAR CONTAINER

| Feature                | Init Container                                      | Sidecar Container                                  |
|------------------------|-----------------------------------------------------|----------------------------------------------------|
| Purpose                | Performs setup before the main container starts     | Runs alongside the main container to assist it      |
| Execution Time         | Runs sequentially before app starts, then exits     | Runs concurrently with the main container           |
| Restart Behavior       | Restarts only if the Pod restarts                   | Restarts independently if it crashes                |
| Access to App Runtime  | Cannot interact with the running app (runs before it)| Can interact with the running app in real time      |
| Use Cases              | - Pre-flight checks<br>- Config setup<br>- Wait for services | - Logging agent<br>- Sidecar proxy (Istio/Envoy)<br>- Metrics exporter |
| Typical Volumes Used   | Shared volumes to write setup data for the main app | Shared volumes to read/write real-time data         |



# SERVICE

Purpose of a Service
 1. To expose Pods to other parts of the cluster or to the external world.
 2. To provide a stable endpoint (IP and DNS) for communication even if the underlying Pods change.

## Type of Services 
 1.ClusterIP: Internal cluster communication. Default. Exposes the Service on an internal IP only within the cluster.
 2.NodePort: External access via node IP and port. Exposes the Service on a static port on each Node’s IP.
 3.LoadBalancer: External access via cloud LB. Automatically provisions an external load balancer


## HOW SERVICE WORK

Kubernetes services provide a stable endpoint for accessing pods, which are ephemeral and can be created, destroyed, or moved around the cluster. Services use labels and selectors to automatically discover and route traffic to the appropriate pods.

## Port Types Explained
- **Node Port**: Port on which the service is exposed to the internet (external access)
- **Port**: Service port / Port on which the service is exposed to the Kubernetes network (internal access)
- **Target Port**: Pod port, should equal to the container's exposed port

## How It Works
1. **Label Selection**: Service uses label selectors to find matching pods
2. **Endpoint Creation**: Service creates endpoints for each matching pod
3. **Traffic Routing**: Incoming traffic is distributed across the endpoints
4. **Automatic Updates**: When pods are added/removed, endpoints are automatically updated

## CLUSTER IP

ClusterIP is the default Kubernetes service type that exposes the service on a cluster-internal IP address. This makes the service only reachable from within the cluster.

## Command
- `k expose pod pod-name --port=3000 --target-port=80 --name service-name2` => Create a ClusterIP service (accessible inside Kubernetes network)
- `k get svc` => List all services in the current namespace
- `k describe srv service-name` => Get detailed information about a specific service

## NODE PORT

NodePort is a Kubernetes service type that exposes the service on each Node's IP at a static port. This makes the service accessible from outside the Kubernetes cluster.

### Command
- `k expose pod pod-name --type=NodePort --port=3000 --target-port=80 --name service-name2` => Create a NodePort service (accessible outside Kubernetes network)
- `k apply -f first-service.yaml`



# REPLICATION CONTROLLER

A ReplicationController ensures that a specified number of pod replicas are running at any given time. It monitors the pods and automatically replaces any that fail, are deleted, or are terminated.

## Key Features
- **Desired State**: Maintains a specified number of pod replicas
- **Self-Healing**: Automatically replaces failed or deleted pods
- **Scaling**: Can scale the number of replicas up or down

## Commands
- `kubectl get rc` => List all ReplicationControllers
- `kubectl describe rc rc_name` => Get detailed information about a ReplicationController
- `kubectl scale rc rc_name --replicas=3` => Scale the number of replicas
- `kubectl apply -f replication-controller.yaml` => Apply a ReplicationController from YAML file
- `k delete rc --cascade=false rc` => Delete ReplicationController without deleting the managed pods
- `k replace -f rc.yaml` => Replace the ReplicationController with the configuration from rc.yaml

# REPLICA SET

A ReplicaSet is the next-generation ReplicationController that provides the same core functionality but with more powerful label selectors. It ensures that a specified number of pod replicas are running at any given time.

## Key Features
- **Enhanced Selectors**: Supports set-based selectors (in, notin, exists) in addition to equality-based selectors
- **Pod Management**: Uses more sophisticated label matching for pod selection

## Commands
- `kubectl get rs` => List all ReplicaSets
- `kubectl describe rs rs_name` => Get detailed information about a ReplicaSet
- `kubectl scale rs rs_name --replicas=3` => Scale the number of replicas
- `kubectl apply -f rs.yaml` => Apply a ReplicaSet from YAML file
- `kubectl delete rs rs_name` => Delete a ReplicaSet
- `k delete rs --all` => Delete all ReplicaSets in the current namespace

# DEPLOYMENT

## Key Features
- **Declarative Updates**: Describe desired state, let Kubernetes handle the rest
- **Rolling Updates**: Update applications with zero downtime
- **Rollback Capability**: Easily rollback to previous versions
- **Pause and Resume**: Pause deployments to make multiple changes

## Commands
- `kubectl get deployments` => List all Deployments
- `kubectl describe deployment deployment_name` => Get detailed information about a Deployment
- `kubectl scale deployment deployment_name --replicas=3` => Scale the number of replicas
- `kubectl apply -f deployment.yaml` => Apply a Deployment from YAML file
- `kubectl rollout status deployment/deployment_name` => Check the status of a deployment rollout
- `kubectl rollout history deployment/deployment_name` => View deployment history
- `kubectl rollout undo deployment/deployment_name` => Rollback to the previous version
- `kubectl rollout undo deployment/deployment_name --to-revision=2` => Rollback to a specific revision


## Rolling Update Strategy
- **Recreate**: Terminates old pods before creating new ones
- **RollingUpdate**: Gradually replaces old pods with new ones (default)

## Tip: Custom Rollout Change-Cause Annotation
To set a custom rollout name or description for history, add this under your Deployment's metadata:

```yaml
metadata:
  annotations:
    kubernetes.io/change-cause: "latest version is deployed"
```
This message will appear in `kubectl rollout history` for better tracking of changes.

> **Note:** Kubernetes keeps the last 10 revisions of a Deployment rollout history by default. This is controlled by the `revisionHistoryLimit` field in your Deployment YAML. For example:

```yaml
spec:
  revisionHistoryLimit: 20
```
This would keep the last 20 revisions instead of the default 10.

# RESOURCES IN POD

Resource management in Kubernetes pods allows you to specify CPU and memory requirements and limits for containers.

## Resource Types
- **Requests**: Minimum resources required for the container to run
- **Limits**: Maximum resources the container can use

## Resource Units
- **CPU**: Specified in cores (e.g., 0.5, 1, 2) or millicores (e.g., 500m)
- **Memory**: Specified in bytes, KiB, MiB, GiB (e.g., 64Mi, 128Mi, 1Gi)


## Commands
- `kubectl describe pod pod_name` => View resource allocation and usage
- `kubectl top pods` => Show resource usage of pods
- `kubectl top nodes` => Show resource usage of nodes

## Best Practices
- Always set resource requests and limits
- Monitor resource usage regularly
- Use appropriate resource values based on application needs
- Consider using HorizontalPodAutoscaler for automatic scaling

> **Note:** In the case of multiple containers in a single pod, the pod's total CPU and memory requests/limits are the sum of the values for all containers (e.g., total CPU = cpu1 + cpu2).

# NAMESPACES

## Key Concepts
- **Isolation**: Namespaces provide a scope for names, allowing resources with the same name to exist in different namespaces.
- **Resource Quotas**: You can set resource limits per namespace.
- **Default Namespace**: If not specified, resources are created in the `default` namespace.

## Common Commands
- `kubectl get ns` => List all namespaces
- `kubectl create ns my-namespace` => Create a new namespace
- `kubectl delete ns my-namespace` => Delete a namespace
- `kubectl get pods -n my-namespace` => List pods in a specific namespace
- `kubectl config set-context --current --namespace=my-namespace` => Set default namespace for current context
- `k apply -f pod.yaml -n my-namespace` => Apply a resource (e.g., pod) to a specific namespace

## Best Practices
- Use namespaces to separate environments (dev, test, prod)
- Apply resource quotas and limits per namespace
- Use RBAC to control access per namespace

### Default Namespaces
- **default**: The default namespace for user resources
- **kube-node-lease**: Used to enhance the heartbeat of worker nodes
- **kube-public**: Contains resources that should be publicly accessible
- **kube-system**: Used for Kubernetes system components

> **Note:** Within a namespace, pods can access services directly using the service name (e.g., `http://service-name`). No need to specify the namespace for intra-namespace communication.

> **Note:** For cross-namespace access, pods must use the full DNS name: `service-name.namespace.svc.cluster.local` (e.g., `http://my-service.service-namespace.svc.cluster.local`).

---

### Resource Quotas in Namespaces

Purpose: To limit the total resource usage (e.g., CPU, memory, number of objects) within a namespace.

- **Scope:** Quotas are applied per namespace.
- **Types of Quotas:** 
                    1. Object based Quotas 
                    2. Resource based Quotas --> CPU, Memory

> **Note:**
> When you create a ResourceQuota in a namespace, Kubernetes enforces that all resources created in that namespace must define their resource requests and limits. If you do not define resource requests, Kubernetes will automatically set requests = limits.

✅ ResourceQuota controls total resource use across the entire namespace.


### Limit Range in Namespaces

Purpose: To set default and maximum/minimum resource limits per pod/container inside the namespace.

`kubectl get limitrange -n namespace-name` => List all LimitRanges in the namespace
`kubectl describe -n namespace-name` => Describe a LimitRange in the namespace

✅ LimitRange controls per-pod/container limits.


# ConfigMap

Purpose: To provide configuration data to pods and other resources without hardcoding values inside container images.

`kubectl create cm config-name --from-literal=key=value` => Create a ConfigMap from literal values
`kubectl create cm config-name --from-file=path/to/file` => Create a ConfigMap from a file
`kubectl get cm -n namespace-name` => List all ConfigMaps in a namespace
`kubectl describe cm config-name -n namespace-name` => Describe a specific ConfigMap in a namespace
`k create cm cm2 --from-file=application.properties --from-file=database.properties` => When there are more than one file
`k create cm cm2 --from-file=folder_name`



> **Tip:**
> Use `--from-file` for config files or when you want the whole file as a value.
> Use `--from-env-file` for environment variable style key-value pairs.

> **Note:** ConfigMaps are injected into Pods by referencing them in the Pod's YAML definition, either as environment variables or as mounted files.


# KUBERNETES SECRETS

## Purpose
Kubernetes Secrets are used to securely store and manage sensitive information such as passwords, tokens, SSH keys, and other confidential data. 

## Types of Secrets

- **generic**: Default type for arbitrary user-defined key-value pairs (most custom secrets).
- **docker** (`kubernetes.io/dockerconfigjson`): Used to store Docker registry credentials for pulling private images.
- **tls** (`kubernetes.io/tls`): Used to store a TLS certificate and its associated private key.

### generic
`kubectl create secret generic my-generic-secret --from-literal=username=admin --from-literal=password=secret`
### docker
`kubectl create secret docker-registry my-docker-secret --docker-username=myuser --docker-password=mypassword --docker-server=myregistry.example.com`
### tls
`kubectl create secret tls my-tls-secret --cert=path/to/tls.crt --key=path/to/tls.key`

## Common Commands
- `k get secrets` — List all Secrets in the current namespace.
- ` k create secret generic secret-name --from-file=database.properties` — Create a Secret from a file named application.properties.
- `k get secret application.properties -o yaml` — View the YAML (base64-encoded data) of the Secret named application.properties.
- `k describe secret secret-name` — Show details about all Secrets in the current namespace.

> **Note:** Secrets are injected into Pods by referencing them in the Pod's YAML definition, either as environment variables or as mounted files.


# TAINT AND TOLERATION

## Purpose
Taints and tolerations work together to ensure that pods are only scheduled onto appropriate nodes. Taints are applied to nodes, and tolerations are applied to pods.

## Key Concepts
- **Taint:** Prevents pods from being scheduled on a node unless the pod has a matching toleration.
- **Toleration:** Allows (tolerates) a pod to be scheduled on a node with a matching taint.

## How It Works
- Nodes are “tainted” to repel certain pods.
- Pods with matching “tolerations” can be scheduled on those tainted nodes.

> **Note:** By default, the master node (control plane node) is tainted, which prevents regular pods from being scheduled on it unless they have a matching toleration. This is done to ensure that only critical system pods run on the master node.

## Common Use Cases
- Dedicating nodes for specific workloads (e.g., GPU, high-memory, or special compliance requirements).
- Preventing certain pods from running on specific nodes.

### Command Example
`kubectl taint node node-name mysize=large:NoSchedule` — Add a taint to the node 'kind-worker' so that only pods with a matching toleration can be scheduled on it.

`k taint node node-name mysize-` — Remove the taint with key 'mysize' from the node 'node-name', allowing pods to be scheduled on it without requiring a matching toleration.

**Taint Effects:**
- **NoSchedule**: Pods that do not tolerate the taint will not be scheduled on the node.
- **PreferNoSchedule**: Kubernetes will try to avoid scheduling pods that do not tolerate the taint, but it is not guaranteed.
- **NoExecute**: Existing pods that do not tolerate the taint will be evicted from the node, and new ones will not be scheduled.


# NODE SELECTOR & NODE AFFINITY

## Purpose
Node Selector and Node Affinity are mechanisms in Kubernetes to control which nodes your pods are scheduled on, based on node labels. This allows you to target specific nodes for certain workloads (e.g., GPU nodes, high-memory nodes, compliance zones).

---

## NODE SELECTOR

Node Selector is the simplest way to constrain pods to run on nodes with specific labels.

### How It Works
- You add a `nodeSelector` field to your Pod spec, specifying a key-value pair that must match a label on the node.
- If no node matches, the pod will remain unscheduled.

### Commands
- `kubectl label nodes node-name key=value` — Add a label to a node
- `kubectl get nodes --show-labels` — Show all node labels

---

## NODE AFFINITY

Node Affinity is a more expressive and flexible way to control pod scheduling, introduced as a replacement and enhancement for nodeSelector.

### Types of Node Affinity
- `requiredDuringSchedulingIgnoredDuringExecution`: (Hard requirement) Pod will only be scheduled on nodes that match the rules. If no node matches, the pod will not be scheduled.
- `preferredDuringSchedulingIgnoredDuringExecution`: (Soft preference) Kubernetes will try to schedule the pod on matching nodes, but will use others if none are available.

- Node affinity supports operators like `In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt`, and `Lt` for matching node labels.
- For example, you can require a pod to run only on nodes with a specific label or prefer nodes in a certain zone.

---


## Best Practices
- Use nodeSelector for simple, single-label constraints.
- Use node affinity for complex scheduling needs (multiple labels, soft preferences).
- Label your nodes meaningfully (e.g., by hardware, zone, environment).
- Avoid over-constraining pods, which can lead to unschedulable workloads.
- Regularly review node labels and affinity rules as your cluster evolves.

---

## Common Commands
- `kubectl label nodes node-name key=value` — Add or update a label on a node
- `kubectl get nodes --show-labels` — List all nodes with their labels
- `kubectl describe node node-name` — View detailed node info, including labels
- `k label node node01 color=blue` — Add a label `color=blue` to the node named `node01`

> Note: Node Affinity only affects scheduling, not ongoing execution. If a node's labels change after a pod is scheduled, the pod will not be evicted.






