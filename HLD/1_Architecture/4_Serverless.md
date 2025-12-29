**Serverless architecture is a cloud model where developers build and run apps without managing servers; the cloud provider
handles infrastructure (provisioning, scaling, maintenance), allowing focus on code, with resources allocated dynamically
and billed only during execution (event-driven). Key benefits include reduced operational overhead, automatic scaling, 
and cost efficiency (pay-per-use), but potential drawbacks are vendor lock-in and cold starts (latency for inactive functions)**
-------------------------------------------------------------------------------------------------------------------
Key Concepts
    No Server Management: Developers don't provision, patch, or maintain servers; the cloud provider does.
    Function as a Service (FaaS): Core to serverless, code runs in stateless containers triggered by events (e.g., API calls, file uploads).
    Event-Driven: Code executes in response to specific events, rather than running constantly.
    Automatic Scaling: Resources scale up or down instantly based on demand.
    Pay-Per-Use: You only pay for the compute time your code actually uses, not for idle servers. 

Benefits
    Reduced Costs: Eliminates paying for idle server capacity.
    Increased Agility: Faster development cycles by focusing solely on code.
    High Scalability & Availability: Handles traffic spikes automatically. 

Common Use Cases
    APIs & Web Backends: Building responsive, scalable APIs.
    Data Processing: Real-time data transformation (ETL) and file processing.
    Scheduled Tasks (Cron Jobs): Running recurring tasks efficiently.
    Microservices: Decomposing applications into independent functions

