Stateless architecture is a design where servers don't store client session data, treating each request as a new, 
independent transaction requiring all necessary info from the client, making systems highly scalable, fault-tolerant, 
and easier to manage by distributing load across multiple servers that access shared state in a central database or token.
This contrasts with stateful systems, which remember past interactions, making them simpler for specific tasks but harder to 
scale.    

----------------------------------------------------------------------------------------------
Key Characteristics

    No Server-Side Memory: Servers don't retain client-specific data between requests; they forget everything once the response is sent.
    Self-Contained Requests: Each request must contain all data needed for the server to process it (e.g., authentication tokens, user ID).
    Externalized State: Session data (like shopping cart items, user preferences) is stored externally in a shared database or cache, accessible by any server.
    RESTful Principles: Aligns well with REST principles, making it ideal for modern web services and microservices. 

Advantages

    Scalability: Easily add or remove servers (horizontal scaling) because no server holds critical session data.
    Fault Tolerance: If a server fails, another can seamlessly take over without data loss, improving reliability.
    Simplified Design: Servers are simpler as they don't manage complex session state, reducing dependencies.
    Flexibility: Better for handling dynamic workloads and enabling continuous deployment. 

    Common Examples & Technologies

    HTTP: The foundational protocol for the web is inherently stateless.
    RESTful APIs: Popular for building stateless web services.
    JSON Web Tokens (JWTs): Used to securely transmit authentication and user data with each request.
    Microservices: Each service can be stateless and scale independently.
    Cloud Services: CDNs, social media apps (Twitter, Instagram) leverage statelessness for global reach and high availability. 

How It Works (Simplified)

    Client Request: You log in; the server sends back a token (JWT).
    Subsequent Request: You click an item; the request includes the token.
    Server Verification: Any server receives the request, validates the token (which has your info), fetches cart data
    from the shared database, and responds.
    No Memory: The server forgets your session after responding. 
