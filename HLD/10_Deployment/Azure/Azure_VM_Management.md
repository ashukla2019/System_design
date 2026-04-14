# Azure VM Management – Single Diagram Flow

```text
Admin / User
(Console / CLI / PowerShell / SDK)
   │
   ▼
Azure Management Plane (RBAC / Control Plane)
   │
   ▼
VM Agent
   │
   ▼
Azure VM
   │
   ▼
Operating System / Applications
   │
   ▼
Managed Identity (token request via metadata endpoint)
   │
   ▼
Azure AD (Entra ID issues token)
   │
   ▼
Azure Service (Key Vault / Storage / DB)
   │
   ▼
Output / Data


1. Admin / User
Initiates command execution using Console, CLI, PowerShell, or SDK.

2. Azure Management Plane (Control Plane)
Authenticates and authorizes the request using RBAC, then registers/stores the command for the target VM.

3. VM Agent (on Azure VM)
Runs inside the VM and securely pulls the command from the management plane, then executes it.

4. Azure VM (OS / Application Layer)
The command or script is executed within the operating system environment.

5. Output & Logging
Execution results and logs are sent back to the management plane and can be stored or analyzed using services like Azure Monitor, Azure Log Analytics, or a Storage Account.