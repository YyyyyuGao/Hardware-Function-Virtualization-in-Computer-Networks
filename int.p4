


#include <core.p4>
#include <sume_switch.p4>

/* This program processes Ethernet packets,
 * performing forwarding based on the destination Ethernet Address
 */
 
typedef bit<48> EthernetAddress; 

// 4 bytes
#define INT_DATA_SIZE 4

#define INT_TYPE 0x1213

#define REG_READ 8w0
#define REG_WRITE 8w1

// switchID register
@Xilinx_MaxLatency(64)
@Xilinx_ControlWidth(2)
extern void switchID_reg_rw(in bit<2> index, in bit<31> newVal, in bit<8> opCode, out bit<31> result);

// timestamp generation
@Xilinx_MaxLatency(1)
@Xilinx_ControlWidth(0)
extern void tin_timestamp(in bit<1> valid, out bit<31> result);


/*

Bitmask format (5 bits):
<SWITCH_ID><INGRESS_PORT><Q_SIZE><TSTAMP><EGRESS_PORT>


*/
#define EGRESS_PORT_ID_POS   0 
#define EGRESS_PORT_ID_MASK  5w0b00001
#define INGRESS_TSTAMP_POS   1
#define INGRESS_TSTAMP_MASK  5w0b00010
#define Q_OCCUPANCY_POS      2
#define Q_OCCUPANCY_MASK     5w0b00100
#define INGRESS_PORT_ID_POS  3
#define INGRESS_PORT_ID_MASK 5w0b01000
#define SWITCH_ID_POS        4 
#define SWITCH_ID_MASK       5w0b10000

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////headers declaration
//////////////////////////////////////////////////////////////////

// standard Ethernet header
header Ethernet_h { 
    EthernetAddress dstAddr; 
    EthernetAddress srcAddr; 
    bit<16> etherType;
}

// INT header
header int_h {
    bit<2> ver;                   // version #
    bit<2> rep;                   // replication requested
    bit<1> c;                     // is copy 
    bit<1> e;                     // max hop count exceeded
    bit<5> rsvd1;                 // reserved 1 
    bit<5> ins_cnt;               // # of 1's in instruction bitmask
    bit<8> max_hop_cnt;           // max # hops allowed to add metadata
    bit<8> total_hop_cnt;         // # hops that have added metadata 
    bit<5> instruction_bitmask;   // which metadata to add to packet
    bit<27> rsvd2;                // reserved 2
}

// INT switch ID header
header int_switch_id_h {
    bit<1> bos;
    bit<31> switch_id;
}

// INT ingress port ID header
header int_ingress_port_id_h {
    bit<1> bos;
    bit<31> ingress_port_id;
}

// INT egress port ID header
header INT_egress_port_id_h {
    bit<1> bos;
    bit<31> egress_port_id;
}

// INT ingress timestamp header
header int_ingress_tstamp_h {
    bit<1> bos;
    bit<31> ingress_tstamp;
}

// INT queue occupancy header (bytes)
header int_q_occupancy_h {
    bit<1> bos;
    bit<31> q_occupancy;
}

// List of all recognized headers

// digest data to send to cpu if desired
// sume_metadata.send_dig_to_cpu set up to 1
// must be 256 bits

struct digest_data_t {
    bit<184> unused;
    bit<64>  eth_src_addr;  
    port_t   src_port;
}

// user defined metadata: can be used to shared information between
// TopParser, TopPipe, and TopDeparser 

struct user_metadata_t {
    bit<8>  unused;
}

struct Parsed_packet { 
    Ethernet_h ethernet; 
    int_h INT;
    int_switch_id_h int_switch_id;
    int_ingress_port_id_h int_ingress_port_id;
    int_q_occupancy_h int_q_occupancy;
    int_ingress_tstamp_h int_ingress_tstamp;
    INT_egress_port_id_h int_egress_port_id; 
}

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////parser implementation
//////////////////////////////////////////////////////////////////

@Xilinx_MaxPacketRegion(16384)   // declares the largest packet size (in bits) to support


parser TopParser(packet_in b, 
                 out Parsed_packet p, 
                 out user_metadata_t user_metadata,
                 out digest_data_t digest_data,
                 inout sume_metadata_t sume_metadata) {
                
                
                                                      }// TopParser
                                                      




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////deparser implementation
//////////////////////////////////////////////////////////////////
@Xilinx_MaxPacketRegion(16384)
control TopDeparser(packet_out b,
                    in Parsed_packet p,
                    in user_metadata_t user_metadata,
                    inout digest_data_t digest_data,
                    inout sume_metadata_t sume_metadata) { 
    apply {
        // only headers marked as valid will be emitted
        b.emit(p.ethernet); 
        b.emit(p.INT);
        b.emit(p.int_switch_id);
        b.emit(p.int_ingress_port_id);
        b.emit(p.int_q_occupancy);
        b.emit(p.int_ingress_tstamp);
        b.emit(p.int_egress_port_id);
    }
}



// Instantiate the switch
SimpleSumeSwitch(TopParser(), TopPipe(), TopDeparser()) main;







