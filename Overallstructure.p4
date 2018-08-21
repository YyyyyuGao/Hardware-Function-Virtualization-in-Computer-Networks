#include <core.p4>
#include <sume_switch.p4>

/******** CONSTANTS ********/
#define IPV4_TYPE 0x0800

/******** TYPES ********/
typedef bit<48> EthAddr_t;
header Ethernet_h {...}
struct Parsed_packet {...}
struct user_metadata_t {...}
struct digest_data_t {...}

/******** EXTERN FUNCTIONS ********/
extern void const_reg_rw(...);

/******** PARSERS and CONTROLS ********/
parser TopParser(...) {...}
control TopPipe(...) {...}
control TopDeparser(...) {...}

/******** FULL PACKAGE ********/
SimpleSumeSwitch(TopParser(), TopPipe(), TopDeparser()) main;
