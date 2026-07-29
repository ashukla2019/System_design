# Chapter 15 – Ethernet Switching ASICs & Hardware Packet Pipeline
**(Must Know for Arista)**

## Why this chapter?

Software engineers at Arista frequently work close to switch hardware.

Interviewers may ask:

- How does a switch forward a packet?
- What happens inside a switch ASIC?
- CAM vs TCAM?
- Why is TCAM expensive?
- Why do switch buffers overflow?
- What is Head-of-Line Blocking?
- Store-and-Forward vs Cut-Through switching?
- Shared Buffer vs Per-Port Buffer?
- VOQ (Virtual Output Queues)
- QoS packet scheduling
- ECN, RED/WRED
- Line Rate forwarding

---

Topics covered

```
Incoming Port

↓

MAC Parser

↓

VLAN Lookup

↓

ACL Lookup (TCAM)

↓

Routing Lookup

↓

QoS

↓

Output Queue

↓

Scheduler

↓

Outgoing Port
```

You will also learn

- CAM
- TCAM
- SRAM
- DRAM
- Packet Buffering
- Packet Pipeline
- Switch Architecture

This is probably the **highest ROI chapter** for Arista.