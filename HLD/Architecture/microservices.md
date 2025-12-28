Microservices architecture is a method for building large applications as a suite of small, independent, loosely coupled 
services, each focused on a specific business function, communicating via APIs, and deployable/scalable separately. 

------------------------------------------------------------------------
Core Concepts
Small & Focused Services: Each microservice handles one specific task (e.g., user auth, payments). 
Independent Deployment: Services can be updated and deployed without affecting the whole system. 
Loose Coupling: Services rely on well-defined APIs (like REST) to talk, keeping internal details hidden. 
Autonomous Teams: Small, dedicated teams own and manage individual services. 
Technology Diversity: Teams can choose the best language/database for their service. 

Benefits
Agility & Speed: Faster development, testing, and deployment cycles. 
Scalability: Scale individual services based on demand, not the whole app. 
Resilience: Failure in one service doesn't necessarily bring down the entire application. 
Easier Maintenance: Smaller codebases are simpler to understand and manage. 

Challenges & Considerations
Distributed Complexity:
Managing multiple services, networks, and communication adds operational overhead. 

Data Management:
Each service often has its own database, requiring careful design (Bounded Context). 
Inter-Service Communication:
Network latency and potential failures are concerns. 
Operational Tools:
Requires robust tools for deployment (containers/Kubernetes) and monitoring. 

Typical Components
 API Gateway: Single entry point for clients, routing requests to appropriate services.
 Service Registry: Helps services find each other (e.g., Eureka, Consul).
 Configuration Server: Centralizes configuration management.
 Containers & Orchestration: Docker for packaging, Kubernetes for management. 
