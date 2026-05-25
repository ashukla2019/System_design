# Azure Policy + DeployIfNotExists + UAMI + Remediation — Complete Guide

# Goal

Attach a required User Assigned Managed Identity (UAMI-X) to all Azure VMs using:

- Azure Policy
- DeployIfNotExists
- ARM Templates
- Remediation Tasks

---

# What DeployIfNotExists Does

DeployIfNotExists means:

```text
If resource does NOT satisfy policy condition
→ mark resource as non-compliant
→ optionally deploy/fix configuration
```

---

# Compliance Meaning

## Compliant

Resource follows policy.

Example:

```text
VM already has required UAMI-X
```

Result:

```text
Compliant
```

---

## Non-compliant

Resource violates policy.

Example:

```text
VM does NOT have required UAMI-X
```

Result:

```text
Non-compliant
```

---

# Case 1 — Future VM Without Identity

## Scenario

New VM gets created.

VM has:

```text
No identity
```

---

## Policy Evaluation

Policy checks:

```text
Does VM contain required UAMI-X?
```

Result:

```text
Non-compliant
```

---

## DeployIfNotExists Action

Policy deployment attaches UAMI-X.

---

## Final Result

```text
VM becomes compliant
```

---

# Case 2 — Existing VM Without Identity

## Scenario

Existing VM already present.

VM has:

```text
No identity
```

---

## Policy Evaluation

Result:

```text
Non-compliant
```

---

## Remediation Task

Remediation runs ARM deployment.

Identity gets attached successfully.

---

## Final Result

```text
VM becomes compliant
```

---

# Case 3 — Existing VM Already Has Required UAMI

## Scenario

VM already has:

```text
UAMI-X
```

---

## Policy Evaluation

Result:

```text
Compliant
```

---

## Remediation

No remediation needed.

---

# Case 4 — Existing VM Has OTHER UAMIs

## Scenario

VM already has:

```text
UAMI-A
UAMI-B
```

But missing:

```text
UAMI-X
```

---

## Policy Evaluation

Policy checks:

```text
Does VM contain UAMI-X?
```

Result:

```text
Non-compliant
```

---

## Remediation Problem

DeployIfNotExists tries to attach UAMI-X.

But ARM deployments usually replace:

```json
identity.userAssignedIdentities
```

instead of merging dynamically.

---

## Possible Problems

```text
- Existing identities overwritten
- Deployment conflict
- Remediation failure
- Identity validation errors
```

---

# Why This Happens

ARM templates are declarative.

ARM expects final desired state.

ARM does NOT automatically do:

```text
existing identities + new identity
```

merge logic.

---

# Safe ARM Deployment

To safely preserve identities, ARM deployment must send FULL merged identity object.

Example:

```json
"identity": {
  "type": "SystemAssigned, UserAssigned",
  "userAssignedIdentities": {
    "/uamiA": {},
    "/uamiB": {},
    "/uamiX": {}
  }
}
```

---

# Important ARM Limitation

ARM template itself cannot reliably:
- discover all existing identities
- dynamically merge identity collections

especially inside DeployIfNotExists remediation.

---

# Recommended Enterprise Architecture

## Use Azure Policy For

```text
- future VM governance
- compliance reporting
- automatic attach when no identity exists
```

---

## Use Automation For

```text
- existing VMs with identities
- merging UAMIs
- preserving existing identities safely
```

Automation options:
- Azure Function
- Automation Account
- PowerShell
- Az CLI
- Bicep
- SDK

---

# Best Working Flow

```text
Azure Policy
    ↓
Detect missing UAMI-X
    ↓
Mark VM non-compliant

--------------------------------

If VM has NO identities
    ↓
Remediation succeeds

--------------------------------

If VM already has identities
    ↓
Automation/script merges identities safely
```

---

# Az CLI Safe Merge Example

This command APPENDS identity safely.

```bash
az vm identity assign \
  --resource-group myRG \
  --name myVM \
  --identities "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uamiX"
```

Result:

```text
Existing identities preserved
New UAMI added
```

---

# ARM Template Safe Approach

## Step 1

Fetch existing identities.

Example:

```bash
az vm show \
  -g myRG \
  -n myVM \
  --query identity.userAssignedIdentities
```

---

## Step 2

Build merged identity object.

Example:

```json
{
  "/uamiA": {},
  "/uamiB": {},
  "/uamiX": {}
}
```

---

## Step 3

Pass merged object into ARM template.

---

# ARM Template Example

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string"
    },
    "location": {
      "type": "string"
    },
    "identityType": {
      "type": "string"
    },
    "userAssignedIdentities": {
      "type": "object"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "[parameters('identityType')]",
        "userAssignedIdentities": "[parameters('userAssignedIdentities')]"
      },
      "properties": {}
    }
  ]
}
```

---

# Example Parameters

```json
{
  "vmName": {
    "value": "myvm"
  },
  "location": {
    "value": "eastus"
  },
  "identityType": {
    "value": "SystemAssigned, UserAssigned"
  },
  "userAssignedIdentities": {
    "value": {
      "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uamiA": {},
      "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uamiB": {},
      "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uamiX": {}
    }
  }
}
```

---

# Why DeployIfNotExists Fails For Existing UAMIs

Inside Azure Policy remediation:

```text
Policy cannot dynamically:
  - read existing identities
  - merge identity object
  - redeploy safely
```

because policy templates are static.

---

# Better Bicep Solution

Bicep supports object merge using:

```bicep
union()
```

Example:

```bicep
userAssignedIdentities: union(
  vm.identity.userAssignedIdentities,
  {
    '${uami.id}': {}
  }
)
```

This is much safer than plain ARM JSON.

---

# Final Key Takeaway

## DeployIfNotExists Works Well For

```text
- future VMs
- VMs without identities
- compliance reporting
```

---

## DeployIfNotExists Has Limitation For

```text
VMs already containing other identities
```

because ARM remediation cannot dynamically merge identity collections safely.

---

# Recommended Production Design

```text
Azure Policy
    ↓
Compliance + Detection

--------------------------------

Future VMs
    ↓
Auto attach UAMI

--------------------------------

Existing VMs Without Identity
    ↓
Remediation works

--------------------------------

Existing VMs With Other UAMIs
    ↓
Automation merges identities safely
```