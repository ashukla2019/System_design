Monolithic architecture is a traditional software design where an application is built as a single, unified, self-contained
unit, with all components (UI, logic, data access) bundled into one codebase and deployed as a single artifact, ideal for 
small projects due to initial simplicity but challenging for large, complex apps as changes require redeploying the whole 
system. It contrasts with microservices, offering easier initial setup and debugging but less flexibility and independent 
scalability as the application grows. 

-------------------------------------------------------------------------------------------------------
Key Characteristics:
    Single Codebase: All functionalities (UI, business logic, data layer) reside in one repository.
    Tightly Coupled: Components are highly interconnected, sharing memory and resources.
    Single Deployment Unit: The entire application is built, tested, and deployed as one piece (e.g., a single WAR file).
    Unified Database: Often uses a single database for all functions. 

Pros (Advantages):
    Simplicity: Easier to develop, test, and deploy in the early stages.
    Performance: Faster internal communication due to shared resources.
    Easier Debugging: A single codebase makes end-to-end testing simpler. 

Cons (Disadvantages):
    Scalability Issues: Must scale the entire application even if only one part needs more resources.
    Complexity: Large codebases become hard to manage, leading to maintenance issues.
    Reduced Flexibility: Changes in one module can affect the entire system, requiring full redeployment.
    Technology Lock-in: Difficult to adopt new technologies for specific parts. 

When to Use It:
    Small to medium-sized applications with well-defined boundaries.
    Projects requiring rapid prototyping or initial speed.
    Applications with limited scope or smaller development teams. 

Example:
Think of a single-engine airplane where all parts are integrated; updating the engine requires touching the whole plane. 
In software, updating the interest calculation logic in a banking app means redeploying the whole banking application
