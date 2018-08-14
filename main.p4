
/*

(1) When the switch receives a packet from a port, it first reads the source MAC address in the header, so that it knows which port the source MAC address machine is connected to;
(2) Then read the destination MAC address in the packet header and find the corresponding port in the address table;
(3) If there is a port corresponding to the destination MAC address in the table, copy the data packet directly to this port;
(4) If the corresponding port is not found in the table, the packet is broadcast to all ports. When the destination machine responds to the source machine, the switch can learn which port the destination MAC address corresponds to, and the next time the data is transmitted. It is no longer necessary to broadcast all ports.

This process is continuously cycled, and the MAC address information of the entire network can be learned. In this way, the Layer 2 switch establishes and maintains its own address table.


*/
action mac_learn() {
    generate_digest(MAC_LEARN_RECEIVER, mac_learn_digest);
}

table smac {
    reads {
        ethernet_.srcAddr : exact;
    }
    actions {mac_learn; _nop;}
    size : 512;
}

table dmac {
    reads {
        ethernet_.dstAddr : exact;
    }
    actions {forward; broadcast;}
    size : 512;
}

