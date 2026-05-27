# Can Predefined VM Tags Make DeployIfNotExists Identity Merge Reliable?

## Short Answer

No.

Predefined tags help reliably identify which VMs should be remediated, but they do NOT make VM identity merge operations 100% reliable when using:

- Azure Policy
- DeployIfNotExists
- ARM Templates

The core issue still remains:

```text
ARM templates replace identity objects instead of performing true runtime merges.
```

---

# What Tags Successfully Solve

Example VM tag:

```json
"tags": {
  "AttachIdentity": "true"
}
```

Policy condition:

```json
"if": {
  "allOf": [
    {
      "field": "type",
      "equals": "Microsoft.Compute/virtualMachines"
    },
    {
      "field": "tags.AttachIdentity",
      "equals": "true"
    }
  ]
}
```

This part works reliably and is commonly used in enterprise environments.

Tags help determine:

```text
WHICH VM should be remediated
```

---

# What Tags Do NOT Solve

Tags do NOT solve:

```text
HOW ARM merges VM identities
```

The identity merge problem still exists.

---

# Example Failure Scenario

Suppose VM already has:

```json
{
  "identity": {
    "type": "SystemAssigned, UserAssigned",
    "userAssignedIdentities": {
      "uami1": {}
    }
  }
}
```

Your remediation template deploys:

```json
{
  "identity": {
    "type": "SystemAssigned, UserAssigned",
    "userAssignedIdentities": {
      "uami2": {}
    }
  }
}
```

ARM may interpret this as:

```text
Replace identity block
```

instead of:

```text
Merge uami1 + uami2
```

This can lead to:

- ProvisioningState terminal
- Identity update failure
- Remediation failure
- Existing identity conflicts

---

# Why This Happens

ARM templates are:

```text
Declarative desired-state deployments
```

They are NOT:

```text
Runtime state merge engines
```

So the `identity` property is usually treated as a full replacement object.

---

# Can ARM Merge Identities Using reference() and union()?

People commonly try:

```json
"identity": {
  "type": "[reference(resourceId('Microsoft.Compute/virtualMachines', variables('vmName')), '2023-09-01', 'Full').identity.type]",
  "userAssignedIdentities": "[union(
      reference(resourceId('Microsoft.Compute/virtualMachines', variables('vmName')), '2023-09-01', 'Full').identity.userAssignedIdentities,
      variables('newIdentity')
  )]"
}
```

This improves success probability because it attempts:

```text
existing identities
+
new identity
=
merged object
```

---

# But It Is STILL Not 100% Reliable

Failures can still occur because of:

- ARM evaluation timing
- Policy remediation execution context
- VM provider validation
- Null identity states
- SystemAssigned/UserAssigned transitions
- Azure compute locks
- Concurrent VM operations

So this remains:

```text
Best-effort behavior
```

NOT:

```text
Guaranteed merge semantics
```

---

# When It MAY Work Successfully

You may see successful remediation if:

```text
1. VM identity state is simple
2. Existing identity type matches deployment type
3. No conflicting identity removal occurs
4. No concurrent VM updates exist
5. ARM reference() resolves correctly
6. Azure compute provider accepts update
```

But this is still not enterprise-grade reliable behavior.

---

# Why Incremental Mode Does NOT Fix It

Even with:

```json
"mode": "incremental"
```

the identity object is still treated as a replacement object.

Incremental mode protects resources, NOT nested identity merging.

So:

```text
Incremental != Identity Merge
```

---

# Recommended Enterprise Architecture

## Best Reliable Pattern

```text
Tag VM
   ↓
AuditIfNotExists Policy
   ↓
Automation Triggered
   ↓
Automation Reads Existing Identities
   ↓
Automation Merges Identities Safely
   ↓
PATCH VM
```

Automation options:

- Azure Automation Runbook
- Azure Function
- Logic App
- Deployment Script
- Azure CLI
- PowerShell

---

# Why Automation Is More Reliable

Tools like Azure CLI internally do:

```text
1. GET existing identities
2. Merge identities in code
3. Send PATCH request
```

This is much safer than ARM template replacement behavior.

Example:

```bash
az vm identity assign \
  --ids <vmId> \
  --identities <new-uami>
```

Azure CLI safely merges identities in most scenarios.

---

# Final Conclusion

## Can predefined tags make DeployIfNotExists identity merge 100% reliable?

No.

Tags reliably solve VM targeting, but they do NOT change ARM template identity replacement behavior.

The identity merge operation itself remains inherently unreliable in ARM-only remediation scenarios.

---

# Recommended Final Design

## Avoid

```text
DeployIfNotExists
    ↓
ARM Template directly updates VM identity
```

## Prefer

```text
AuditIfNotExists
    ↓
Automation
    ↓
Safe identity merge
```