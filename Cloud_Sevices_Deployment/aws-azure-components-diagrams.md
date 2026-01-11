

1️⃣ IP Address – the foundation
An IP address uniquely identifies a machine on a network.

Example (IPv4):

10.0.0.4
Think of it as:

House number

Without IPs → computers can’t talk.
---------------------------------

2️⃣ CIDR – how IP ranges are defined
CIDR = Classless Inter-Domain Routing

CIDR defines how many IPs are in a network.

Format
<network-address>/<prefix>
Example:

10.0.0.0/16
What /16 means
First 16 bits → network

Remaining 16 bits → hosts

IP count formula
Total IPs = 2^(32 - prefix)
CIDR	Total IPs
/32	1
/24	256
/16	65,536
/8	16 million
📌 CIDR answers:
➡️ How big is my network?

---------------------------------

3️⃣ VNet / VPC – private network in the cloud
Cloud	Name
Azure	VNet
AWS	VPC
What is a VNet?
A logically isolated private network in the cloud.

Example:

VNet: 10.0.0.0/16
Think of VNet as:

🏙️ A gated city

You control IP range

Isolated from other VNets/VPCs

Lives inside a region

VNet diagram
VNet (10.0.0.0/16)
┌──────────────────────────────┐
│                              │
│    Private cloud network     │
│                              │
└──────────────────────────────┘
---------------------------------

4️⃣ Subnet – dividing the VNet
A Subnet is a smaller IP range inside a VNet.

Example:

VNet:     10.0.0.0/16
Subnet A: 10.0.1.0/24
Subnet B: 10.0.2.0/24
Why subnets exist
Isolation

Security

Routing control

Scalability

Think of subnet as:

🏢 Buildings inside a city

Subnet diagram
VNet (10.0.0.0/16)
│
├── Subnet-Web  (10.0.1.0/24)
├── Subnet-App  (10.0.2.0/24)
└── Subnet-DB   (10.0.3.0/24)

---------------------------------

5️⃣ Public vs Private Subnet (important concept)
Private Subnet
No direct internet access

Used for DBs, internal services

Public Subnet
Has route to Internet Gateway

Used for Load Balancers, Bastion

📌 Subnet is “public” or “private” based on ROUTES, not name

---------------------------------

6️⃣ Route Table – traffic decision maker
A route table tells:

“If traffic wants to go X, send it to Y”

Example:

Destination        Target
0.0.0.0/0          Internet Gateway
10.0.0.0/16        Local
Default route
0.0.0.0/0 = anywhere on internet
Routing flow
VM → Subnet → Route Table → Gateway

---------------------------------

7️⃣ Internet Gateway (IGW)
An Internet Gateway allows public IP communication.

Enables inbound + outbound internet

Attached to VNet/VPC

Think of it as:

🚪 Main city gate to the internet

---------------------------------

8️⃣ NAT – Network Address Translation (VERY IMPORTANT)
Problem NAT solves
Private IPs cannot access internet directly.

Example private IP:

10.0.1.5
Internet cannot route back to it.

NAT Gateway – solution
A NAT Gateway:

Allows outbound internet

Blocks inbound internet

Translation example
10.0.1.5  → 52.12.34.8 (public NAT IP)
Think of NAT as:

📞 Caller ID changer

NAT diagram
Private Subnet
VM (10.0.1.5)
      │
      ▼
NAT Gateway (Public IP)
      │
      ▼
Internet
NAT vs Internet Gateway
Feature	NAT	Internet Gateway
Inbound	❌	✅
Outbound	✅	✅
Used for	Private subnet	Public subnet

---------------------------------

9️⃣ Security Groups & NSGs – firewalls
Azure
NSG (Network Security Group)

AWS
Security Group

NACL

They control:

Inbound rules

Outbound rules

Ports, protocols, IPs

Example:

Allow TCP 443 from 0.0.0.0/0
Deny all others
Think of it as:

🛂 Security guards at building entrance

---------------------------------

🔟 How everything connects (FULL FLOW)
Scenario
Web app

App server

Database

Architecture
Internet
   │
   ▼
Load Balancer (Public Subnet)
   │
   ▼
App VM (Private Subnet)
   │
   ▼
DB (Private Subnet)
Outbound from DB
DB → NAT → Internet
1️⃣1️⃣ Complete mental model (one line)
VNet = private city
CIDR = city size
Subnet = buildings
Route table = traffic police
IGW = public gate
NAT = outbound-only gate
NSG/SG = security guards

1️⃣2️⃣ Interview-level Q&A
Q: Can two subnets talk?
✅ Yes, by default within same VNet.

Q: Can two VNets talk?
❌ No
✅ Only via Peering / VPN / ExpressRoute

Q: Why NAT instead of public IP?
Security

Cost

Control

Prevent inbound attacks
