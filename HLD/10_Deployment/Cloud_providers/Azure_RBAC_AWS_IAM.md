# Azure RBAC vs AWS IAM — Complete Notes

# 1. Core Idea

Every cloud permission system has 3 things:

| Concept | Meaning |
|---|---|
| Identity | Who are you? |
| Permissions | What can you do? |
| Scope/Resource | Where can you do it? |

---

# 2. Azure vs AWS Mapping

| Azure | AWS | Meaning |
|---|---|---|
| Managed Identity | IAM Role | Identity for VM/Service |
| RBAC Role | IAM Policy | Permissions |
| Role Assignment | Attach Policy to Role | Grant permissions |
| Azure AD Token | Temporary Credentials | Authentication |
| Scope | Resource ARN | Where permission applies |

---

# 3. Azure Architecture

Azure separates:
- Identity
- Permissions

into different components.

---

# 4. Azure Components

## 4.1 Managed Identity

Managed Identity = Identity of VM/App.

Example:
```text
VM-1
   └── Managed Identity
```

This only means:
> VM can authenticate to Azure AD.

It DOES NOT mean:
> VM has permissions.

---

## 4.2 RBAC Role

RBAC Role defines allowed actions.

Examples:
- Reader
- Contributor
- Owner
- Storage Blob Data Reader
- Key Vault Secrets User

Example internal permission:
```json
{
  "actions": [
    "Microsoft.Storage/storageAccounts/read"
  ]
}
```

---

## 4.3 Role Assignment

Role Assignment connects:
- Identity
- Role
- Scope

Example:
```text
Managed Identity
   └── Storage Blob Data Reader
         └── Scope = Storage Account A
```

Meaning:
> VM can read blobs from Storage Account A.

---

# 5. Azure Full Flow

## Step 1 — Create VM

```text
VM created
```

No permissions yet.

---

## Step 2 — Attach Managed Identity

```text
VM
 └── Managed Identity
```

VM now has identity.

Still no permissions.

---

## Step 3 — Assign RBAC Role

```text
Managed Identity
   └── Role = Storage Blob Data Reader
         └── Scope = Storage Account
```

Now VM can access storage.

---

# 6. Azure Example

## Scenario

VM needs to read blobs from Storage Account.

---

## Architecture

```text
VM
 └── Managed Identity
      └── RBAC Role Assignment
           ├── Role = Storage Blob Data Reader
           └── Scope = Storage Account
```

---

## Result

Application inside VM can:
- get Azure AD token
- access blob storage

without passwords/secrets.

---

# 7. Azure Important Clarification

## Managed Identity != Permission

This is VERY important.

### WRONG understanding
```text
Managed Identity attached
=> VM has access
```

### CORRECT understanding
```text
Managed Identity attached
+ RBAC Role Assignment
=> VM has access
```

---

# 8. Azure Scope Hierarchy

Azure RBAC works using hierarchy.

```text
Management Group
   └── Subscription
         └── Resource Group
               └── Resource
```

Permissions inherit downward.

---

## Example

```text
Reader role assigned at Resource Group level
```

Result:
- VM can read all resources inside that RG.

---

# 9. AWS Architecture

AWS combines identity + permission model more tightly.

---

# 10. AWS Components

## 10.1 IAM Role

IAM Role acts as:
- identity
- permission container

Example:
```text
EC2
   └── IAM Role
```

---

## 10.2 IAM Policy

IAM Policy defines permissions.

Example:
```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "*"
}
```

---

## 10.3 Policy Attachment

Policy attached to IAM Role.

Example:
```text
IAM Role
   └── S3ReadOnly Policy
```

---

# 11. AWS Full Flow

## Step 1 — Create EC2

```text
EC2 created
```

No permissions.

---

## Step 2 — Attach IAM Role

```text
EC2
   └── IAM Role
```

Role exists.

---

## Step 3 — Attach Policy

```text
IAM Role
   └── S3ReadOnly Policy
```

Now EC2 can access S3.

---

# 12. AWS Example

## Scenario

EC2 needs to read objects from S3.

---

## Architecture

```text
EC2
 └── IAM Role
      └── IAM Policy
           └── Action = s3:GetObject
```

---

## Result

Application inside EC2 can:
- get temporary credentials
- access S3

without storing AWS keys.

---

# 13. Major Difference

# Azure

Azure separates:
- Identity
- Permissions

Example:
```text
Managed Identity
+
RBAC Role
```

---

# AWS

AWS combines them more tightly.

Example:
```text
IAM Role
+
IAM Policy
```

---

# 14. Simplified Mental Model

## Azure

```text
Managed Identity = WHO
RBAC Role = WHAT
Scope = WHERE
```

---

## AWS

```text
IAM Role = WHO
IAM Policy = WHAT
Resource ARN = WHERE
```

---

# 15. Default Permissions Question

## Can VM get default permissions automatically?

YES sometimes.

But usually through:
- Terraform
- ARM templates
- CloudFormation
- Landing Zone
- Organization policies
- Automation
- AKS/EKS setup

NOT because VM automatically gets admin access.

---

# 16. Example Comparison

# Azure Example

## VM accessing Storage

```text
VM
 └── Managed Identity
      └── Storage Blob Data Reader
           └── Scope = Storage Account
```

---

# AWS Example

## EC2 accessing S3

```text
EC2
 └── IAM Role
      └── S3ReadOnly Policy
```

---

# 17. Authentication Flow

# Azure Flow

```text
VM
 -> Managed Identity
 -> Azure Metadata Service
 -> Azure AD Token
 -> Access Azure Resource
```

---

# AWS Flow

```text
EC2
 -> Instance Metadata Service
 -> Temporary AWS Credentials
 -> Access AWS Resource
```

---

# 18. Important Interview Explanation

## Azure

### Question:
How does VM access Azure Storage securely?

### Answer:
```text
1. Attach Managed Identity to VM
2. Assign RBAC role to Managed Identity
3. VM gets token from Azure AD
4. VM accesses storage without secrets
```

---

## AWS

### Question:
How does EC2 access S3 securely?

### Answer:
```text
1. Attach IAM Role to EC2
2. Attach IAM Policy to role
3. EC2 gets temporary credentials
4. EC2 accesses S3 without AWS keys
```

---

# 19. Final One-Line Understanding

# Azure

```text
Managed Identity + RBAC Role Assignment = VM Permissions
```

---

# AWS

```text
IAM Role + IAM Policy = EC2 Permissions
```

---

# 20. Quick Revision Table

| Feature | Azure | AWS |
|---|---|---|
| VM Identity | Managed Identity | IAM Role |
| Permission Model | RBAC | IAM |
| Permission Object | RBAC Role | IAM Policy |
| Permission Attachment | Role Assignment | Attach Policy |
| Hierarchy | Scope-based | Resource Policy-based |
| Token/Credentials | Azure AD Token | Temporary AWS Credentials |
| Metadata Service | IMDS | IMDS |
| Typical Storage Permission | Storage Blob Data Reader | S3ReadOnly |
| Secretless Access | Yes | Yes |
