# KUBERNETES COMMANDS REFERENCE

## KIND (Kubernetes in Docker)
1. `kind create cluster --name cluster_name --config ./Kind/cluster.yaml`
2. `kind get clusters`

## KUBECTL
**Format:** `kubectl command resource_type resource_name`

### General Commands
1. `kubectl api-resources` => List all available API resources

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
4. `kubectl describe pod nitin` => Detailed pod information
5. `kubectl get pods -o wide` => Detailed pod information with node info
6. `kubectl edit pod nitin` => Edit pod in default editor
7. `kubectl apply -f pod.yaml` => Apply pod from YAML file
8. `kubectl create -f pod.yaml` => Create pod from YAML file (will update existing pod)
9. `kubectl delete pod nitin1` => Delete specific pod
10. `kubectl run nitin1 --image nginx --dry-run=client -o yaml` => Generate YAML template without creating
11. `kubectl describe pod > description.yaml` => Save pod description to file
12. `kubectl get pod nitin -o yaml > detail.yaml` => Save pod YAML to file
13. `kubectl delete -f pod.yaml` => Delete pod(s) defined in a YAML file
14. `kubectl apply -f pod.yaml --dry-run=server` => Validate pod.yaml against the live API server without applying
15. `kubectl apply -f pod.yaml --dry-run=client` => Validate pod.yaml locally (client-side) without applying
16. `kubectl diff -f pod.yaml` => Show differences between the current cluster state and the pod.yaml file
17. `kubectl exec -it pod_name -c container_name -- sh` => Access a specific container in a pod using sh shell

### IMPORTANT: kubectl exec (NEVER use in production)
18. `kubectl exec -it pod_name -- bash` => **NEVER use in production: pods are ephemeral (changes lost on restart) + security risk (privilege escalation)**

## EPHEMERAL CONTAINERS
**Definition:** Ephemeral containers are temporary containers that run alongside existing containers in a pod for debugging purposes.

### Debug Command
19. `kubectl debug pod_name -it --image=busybox --target=container_name -- bash`

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

# DAEMONSET

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

