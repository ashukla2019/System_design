# Docker & Kubernetes â€“ Quick Deployment Diagrams

---

## Docker Deployment (Simple)

```
Developer
   |
   | docker build
   v
Docker Image
   |
   | docker push
   v
Image Registry
   |
   | docker run
   v
Docker Container
   |
   v
Application Running
```

### Notes
- Dockerfile defines the image
- Image = app + dependencies
- Container = running instance

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