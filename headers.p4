/*


This file is used to define headers.



*/

// standard Ethernet header
header_type ethernet_h {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}


// intrinsic metadata header
header_type intrinsic_metadata_h {
    fields {
        mcast_grp : 4;
        egress_rid : 4;
        mcast_hash : 16;
        lf_field_list: 32;
    }
}



// INT header
header_type int_header_h {
    fields {
        ver                     : 2;   // define INT metadata header version.
        rep                     : 2;   // Replication requested.
                                       // 0: No replication requested.
                                       // 1: Port_level (L2_level) replication requested. 
                                       // 2: Next_hop_level (L3_level) replication requested.
                                       // 3: Port_ and Next_hop_level replication requested. 
        c                       : 1;   // Copy.
        e                       : 1;   // Max Hop Count exceeded
        rsvd1                   : 5;   // Reserved 1
        ins_cnt                 : 5;   // Instruction Count
        max_hop_cnt             : 8;   // Max Hop Count
        total_hop_cnt           : 8;   // Total Hop Count
        instruction_bitmask     : 5;   // Decide which metadata to add to packet
        rsvd2                   : 16;  // Reserved 2
    }
}

// Headers initialization

header   ethernet_h ethernet;
metadata intrinsic_metadata_h intrinsic_metadata
header   int_h INT;
