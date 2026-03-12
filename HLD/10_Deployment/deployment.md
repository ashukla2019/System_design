# Docker & Kubernetes Quick Deployment Diagrams

---

## Docker Deployment 

```
Developer Machine (Code + Dockerfile)
   |
   | docker build -t myapp:1.0 .
   v
Docker Image (App + Dependencies + Runtime)
   |
   | docker tag myapp:1.0 myrepo/myapp:1.0
   | docker push myrepo/myapp:1.0
   v
Image Registry (Docker Hub / ECR / GCR / ACR)
   |
   | docker pull myrepo/myapp:1.0
   v
Docker Host (Server / VM / Cloud Instance)
   |
   | docker run -d -p 80:3000 --name myapp-container myrepo/myapp:1.0
   v
Running Container (Application Running)
   |
   ^
   | Port Mapping (-p 80:3000)
   |
End Users Access Application via Server IP:80

```


## Kubernet Deployment 
```
Developer Machine (Code + Dockerfile + K8s YAML)
   |
   | docker build (Creates Docker Image)
   v
Docker Image (App + Dependencies + Runtime)
   |
   | docker push (Uploads image to Registry)
   v
Image Registry (Docker Hub / ECR / GCR / ACR)
   |
   | kubectl apply -f deployment.yaml
   v
Kubernetes API Server (Stores desired state in etcd)
   |
   | Creates
   v
Deployment (Defines desired state: replicas, image, strategy)
   |
   | Manages
   v
ReplicaSet (Ensures correct number of Pods)
   |
   | Creates
   v
Pods (Smallest unit in Kubernetes)
   |
   | Kubelet pulls image from Registry
   v
Container Runtime (containerd / Docker)
   |
   v
Running Containers (Application Running)
   |
   ^
   | Service exposes Pods
   |
Service (ClusterIP / NodePort / LoadBalancer)
   |
   v
Users / External Traffic

```

---

## Docker vs Kubernetes (At a Glance)

```
Docker      -> Run containers
Kubernetes -> Manage containers at scale
```

| Feature | Docker | Kubernetes |
|-------|--------|------------|
| Purpose | Containerization | Orchestration |
| Scaling | Manual | Automatic |
| Self-healing | No | Yes |

---

## Real World Flow

```
Code → Docker Image → Registry → Kubernetes → Users

Developer writes code → packages it as a container → stores it in registry → Kubernetes runs it → users access it.

Node.js app
   ↓
Docker Image
   ↓
Push to AWS ECR
   ↓
Kubernetes (EKS) deploys it
   ↓
Users access via LoadBalancer

```
