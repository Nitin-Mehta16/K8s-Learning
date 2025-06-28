# Kubernetes Learning Repository

This repository contains my learning journey and reference materials for Kubernetes (K8s).

## 📚 Contents

### Commands Reference
- Comprehensive `Commands.md` file with essential Kubernetes commands
- Organized by resource types (Pods, Nodes, Services, etc.)
- Includes debugging commands and best practices
- Covers ephemeral containers and production considerations

### Kind (Kubernetes in Docker)
- `Kind/k8s.sh` - Scripts for Kind cluster management
- `Kind/multi_cluster.yaml` - Multi-cluster configuration

### Pod Examples
- `Pods/Pod.yaml` - Example pod configurations
- `pod.yaml` - Additional pod examples

## 🚀 Getting Started

### Prerequisites
- Docker installed
- kubectl CLI tool
- Kind (Kubernetes in Docker)

### Quick Start
```bash
# Create a Kind cluster
kind create cluster --name my-cluster --config ./Kind/cluster.yaml

# Check cluster status
kubectl get nodes

# Apply pod configuration
kubectl apply -f pod.yaml
```

## 📖 Learning Resources

### Essential Commands
- **Pod Management**: Create, describe, edit, delete pods
- **Debugging**: Logs, describe, events, ephemeral containers
- **Cluster Management**: Nodes, namespaces, resources

### Best Practices
- Never use `kubectl exec` in production
- Use ephemeral containers for debugging
- Follow declarative approach with YAML files
- Implement proper logging and monitoring

## 🔧 Tools Used

- **kubectl** - Kubernetes command-line tool
- **Kind** - Kubernetes in Docker for local development
- **K9s** - Terminal UI for Kubernetes

## 📝 Notes

- Ephemeral containers are temporary and disappear when you exit
- Pods are immutable - changes via exec are lost on restart
- Always use declarative configuration for production
- Security considerations for production environments

## 🤝 Contributing

This is a personal learning repository. Feel free to use the commands and examples for your own Kubernetes learning journey.

## 📄 License

This project is for educational purposes.

---

**Happy Learning Kubernetes! 🐳**

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
3. `kubectl describe pod nitin` => Detailed pod information
4. `kubectl get pods -o wide` => Detailed pod information with node info
5. `kubectl edit pod nitin` => Edit pod in default editor
6. `kubectl apply -f pod.yaml` => Apply pod from YAML file
7. `kubectl create -f pod.yaml` => Create pod from YAML file (will update existing pod)
8. `kubectl delete pod nitin1` => Delete specific pod
9. `kubectl run nitin1 --image nginx --dry-run=client -o yaml` => Generate YAML template without creating
10. `kubectl describe pod > description.yaml` => Save pod description to file
11. `kubectl get pod nitin -o yaml > detail.yaml` => Save pod YAML to file

### IMPORTANT: kubectl exec (NEVER use in production)
12. `kubectl exec -it pod_name -- bash` => **NEVER use in production: pods are ephemeral (changes lost on restart) + security risk (privilege escalation)**

## EPHEMERAL CONTAINERS
**Definition:** Ephemeral containers are temporary containers that run alongside existing containers in a pod for debugging purposes.

### Debug Command
13. `kubectl debug pod_name -it --image=busybox --target=container_name -- bash`

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








