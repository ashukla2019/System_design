# Azure VM Management – Single Diagram Flow

```text
Admin / User
(Console / CLI / PowerShell / SDK)
   │
   ▼
Azure Management Plane
  (RBAC / Control Plane)
   │
   ▼
VM Agent (running on Azure VM)
   │
   ▼
Azure VM (Command Execution / Session)
   │
   ▼
Operating System / Applications
   │
   ▼
Output & Logs
   │
   ▼
Azure Monitor / Log Analytics / Storage Account


Admin / User: Initiates connection or command execution using Console, CLI, PowerShell, or SDK.
Azure Management Plane: Receives request, validates permissions via RBAC, and stores command/session in the control plane.
VM Agent: Runs on the Azure VM, handles command execution, and communicates securely with the management plane.
Azure VM Execution: Commands/scripts are executed inside the VM operating system.
Output & Logging: Results and logs are returned to the management plane and optionally stored in Azure Monitor, Log Analytics, or Storage Accounts.
