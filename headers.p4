/*


This file is used to define headers.



*/

// standard Ethernet header
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

// INT headers
header_type int_header_t {
    fields {
        ver                     : 2;   // define INT metadata header version.
        rep                     : 2;   // Replication requested.
                                       // 0: No replication requested.
                                       // 1: Port_level (L2_level) replication requested. 
                                       // 2: Next_hop_level (L3_level) replication requested.
                                       // 3: Port_ and Next_hop_level replication requested. 
        c                       : 1;   // Copy.
        e                       : 1;   // Max Hop Count exceeded
        rsvd1                   : 5;
        ins_cnt                 : 5;   // Instruction Count
        max_hop_cnt             : 8;   // Max Hop Count
        total_hop_cnt           : 8;   // Total Hop Count
        instruction_mask_0003   : 4;   // split the bits for lookup
        instruction_mask_0407   : 4;
        instruction_mask_0811   : 4;
        instruction_mask_1215   : 4;
        rsvd2                   : 16;
    }
}

