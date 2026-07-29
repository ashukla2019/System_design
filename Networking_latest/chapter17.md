# Chapter 17 – Linux Kernel Networking Source Walkthrough

Instead of theory, this chapter follows the actual kernel functions.

Packet Receive

```
NIC

↓

napi_poll()

↓

netif_receive_skb()

↓

ip_rcv()

↓

ip_local_deliver()

↓

tcp_v4_rcv()

↓

tcp_recvmsg()

↓

recv()
```

Packet Transmit

```
send()

↓

tcp_sendmsg()

↓

ip_queue_xmit()

↓

dev_queue_xmit()

↓

NIC Driver
```

Interviewers love asking

"Can you explain packet flow using kernel functions?"