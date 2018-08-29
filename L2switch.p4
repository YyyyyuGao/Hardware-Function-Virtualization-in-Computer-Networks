#include <core.p4>
#include <sume_switch.p4>




#define MAC_LEARN_RECEIVER 1024

typedef bit<48> EthernetAddress; 




// standard Ethernet header
header Ethernet_h { 
    EthernetAddress dstAddr;  // width in 48 bits
    EthernetAddress srcAddr; 
    bit<16> etherType;
}




header_type intrinsic_metadata_h {
    fields {
        mcast_grp : 4;
        egress_rid : 4;
        mcast_hash : 16;
        lf_field_list: 32;
    }
}





// List of all recognized headers
struct Parsed_packet { 
    Ethernet_h ethernet; 
}

//////////////////////////////////////////////////////////////////////
// Parser Implementation
/////////////////////////////////////////////////////////////////////

@Xilinx_MaxPacketRegion(16384)
parser TopParser(packet_in b, 
                 out Parsed_packet p, 
                 out user_metadata_t user_metadata,
                 out digest_data_t digest_data,
                 inout sume_metadata_t sume_metadata) {
    state start {
        b.extract(p.ethernet);
       
       
        transition accept;
    }
}

//////////////////////////////////////////////////////////////////////
// match-action pipeline
/////////////////////////////////////////////////////////////////////

control TopPipe(inout Parsed_packet headers,
                inout user_metadata_t user_metadata, 
                inout digest_data_t digest_data, 
                inout sume_metadata_t sume_metadata) {


    
                                                    }
                                                    
                                                    
 table dmac {
    key = { headers.ethernet.dstAddr: exact; }

        actions = {
            foward;
            broadcast;
        }
        size = 512;
        default_action = NoAction;
    }
    


table smac {
    key = {headers.ethernet_.srcAddr : exact;  }
    actions = {
            mac_learn; 
            NoAction;
              }
    size : 512;
    default_action = NoAction;
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
    actions {
    NoAction;
    Drop_action;
    }
    size : 1;
}

field_list mac_learn_digest {
    ethernet_.srcAddr;
    standard_metadata.ingress_port;
}

action mac_learn() {
    generate_digest(MAC_LEARN_RECEIVER, mac_learn_digest);
}

action forward(port_t port) {
        sume_metadata.dst_port = port;
    }

////////////////////////////////////////////////need modify
action broadcast() {
    intrinsic_metadata.mcast_grp = 1;
}


control ingress {
    apply(smac);
    apply(dmac);
}

control egress {
    if(standard_metadata.ingress_port == standard_metadata.egress_port) {
        apply(mcast_src_pruning);
    }
}



//////////////////////////////////////////////////////////////////////
// Deparser Implementation
/////////////////////////////////////////////////////////////////////
@Xilinx_MaxPacketRegion(16384)
control TopDeparser(packet_out b,
                    in Parsed_packet p,
                    in user_metadata_t user_metadata,
                    inout digest_data_t digest_data,
                    inout sume_metadata_t sume_metadata) { 
    apply {
        b.emit(p.ethernet); 
    }
}


// Instantiate the switch
SimpleSumeSwitch(TopParser(), TopPipe(), TopDeparser()) main;

