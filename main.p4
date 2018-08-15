
/*

(1) When the switch receives a packet from a port, it first reads the source MAC address in the header, so that it knows which port the source MAC address machine is connected to;
(2) Then read the destination MAC address in the packet header and find the corresponding port in the address table;
(3) If there is a port corresponding to the destination MAC address in the table, copy the data packet directly to this port;
(4) If the corresponding port is not found in the table, the packet is broadcast to all ports. When the destination machine responds to the source machine, the switch can learn which port the destination MAC address corresponds to, and the next time the data is transmitted. It is no longer necessary to broadcast all ports.

This process is continuously cycled, and the MAC address information of the entire network can be learned. In this way, the Layer 2 switch establishes and maintains its own address table.


*/
#include <headers.p4>
#include <parser.p4>

#define MAC_LEARN_RECEIVER 1024

field_list mac_learn_digest {
    ethernet_.srcAddr;
    standard_metadata.ingress_port;
}


// Define actions
action _drop() {
    drop();
}

action _nop() {
}

action mac_learn() {
    generate_digest(MAC_LEARN_RECEIVER, mac_learn_digest);
}

action forward(port) {
    modify_field(standard_metadata.egress_spec, port);
}

action broadcast() {
    modify_field(intrinsic_metadata.mcast_grp, 1);
}


// Define tables

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

table mcast_src_pruning {
    reads {
        standard_metadata.instance_type : exact;
    }
    actions {_nop; _drop;}
    size : 1;
}

// Define control flow
control ingress {
    apply(smac);
    apply(dmac);
}

control egress {
    if(standard_metadata.ingress_port == standard_metadata.egress_port) {
        apply(mcast_src_pruning);
    }
}

