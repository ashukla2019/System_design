==================== CONTROL PLANE (SETUP) ====================

1. Create Identity (WHO)
   - IAM User / Role / Group
   What it is: Identity creation
   User → A person or app (long-term   identity)
   Role → Temporary identity (assumed via AWS STS)
   Group → Collection of users

2. Define Policy (WHAT)
   - JSON Policy:
       Effect: Allow / Deny
       Action: s3:GetObject, s3:PutObject
       Resource: S3 bucket

3. Attach Policy (LINK)
   - Attach policy to User / Role / Group

4. Assume Role → Get Credentials
   - Via :contentReference[oaicite:0]{index=0}
   - Returns:
       Access Key
       Secret Key
       Session Token (temporary)

===============================================================


===================== DATA PLANE (RUNTIME) =====================

5. Application Runs (EC2 / Lambda / CLI)

6. Uses STS Credentials
   - Signs request (SigV4)

7. Calls S3 API
   - PUT / GET Object

8. S3 Validates
   - Signature check
   - IAM policy evaluation

9. Action Happens
   - File uploaded / downloaded

===============================================================

Azure Full Flow (Entra ID + Managed Identity + RBAC + Blob)
==================== CONTROL PLANE (SETUP) ====================

1. Create Identity (WHO)
   - User / Service Principal / Managed Identity

   What it is: Identity creation

   User → Human identity (login via portal/CLI)
   Service Principal → App identity (like AWS IAM User for apps)
   Managed Identity → Azure-managed identity for VM / services (like IAM Role)

   (All managed by :contentReference[oaicite:0]{index=0})

---------------------------------------------------------------

2. Define Permission Model (WHAT)
   - RBAC Role Definition:
       Actions (Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read)
       No explicit Allow/Deny like AWS
       (Mostly Allow-based model)

---------------------------------------------------------------

3. Assign Role (LINK)
   - Role Assignment:
       Assign RBAC role to:
         User / Service Principal / Managed Identity
       Scope:
         Subscription / Resource Group / Resource

   (Handled via Azure RBAC)

---------------------------------------------------------------

4. Get Token (Credential Issuance)
   - Via :contentReference[oaicite:1]{index=1}
   - Managed Identity → uses IMDS (169.254.169.254)
   - Returns:
       Access Token (OAuth 2.0 JWT)

===============================================================


===================== DATA PLANE (RUNTIME) =====================

5. Application Runs (VM / Function / App Service / CLI)

6. Uses Access Token
   - Token obtained from Entra ID
   - No SigV4 (uses OAuth Bearer Token)

---------------------------------------------------------------

7. Calls Azure Storage (Blob API)
   - PUT / GET Blob

---------------------------------------------------------------

8. Azure Storage Validates
   - Token validation (JWT)
   - RBAC role check

---------------------------------------------------------------

9. Action Happens
   - Blob uploaded / downloaded

===============================================================