

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

