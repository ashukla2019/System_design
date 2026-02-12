# Docker & Kubernetes Quick Deployment Diagrams

---

## Docker Deployment (Simple)

```
Correct & Easy-to-Understand Docker Flow
Developer Machine
   |
   | docker build
   v
Docker Image (local)
   |
   | docker push
   v
Image Registry (Docker Hub / ECR / GCR)
   |
   | docker pull
   v
Host Machine (Server / VM / Kubernetes Node)
   |
   | docker run
   v
Docker Container
   |
   v
Application Running



What’s happening at each step (plain English)
1️⃣ Developer Machine
You write code + Dockerfile.

2️⃣ docker build
Creates a Docker Image
➡️ Image = blueprint (code + dependencies + runtime)

3️⃣ Docker Image (local)
Image exists only on your laptop at this point.

4️⃣ docker push
Uploads the image to an Image Registry
Examples:
Docker Hub
AWS ECR
GCP GCR
Azure ACR

5️⃣ Image Registry
Central storage for images (like GitHub for code).

6️⃣ docker pull
Server downloads the image from registry.

7️⃣ Host Machine
Could be:
EC2 / VM
On-prem server
Kubernetes node

8️⃣ docker run
Starts a Container from the image.

9️⃣ Docker Container
Running instance of the image
➡️ Like an object created from a class

🔟 Application Running
Your app is now live

```

---

## Kubernetes Deployment (High Level)

```
Developer
   |
   | kubectl apply
   v
Kubernetes API Server
   |
   v
Deployment
   |
   v
ReplicaSet
   |
   v
Pods (Containers)
   |
   v
Service (Stable IP / Load Balancer)
   |
   v
Users
```

### Notes
- Pod is the smallest unit
- Deployment manages replicas
- Service exposes pods

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
Code â†’ Docker Image â†’ Registry â†’ Kubernetes â†’ Users
```