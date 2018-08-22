
package SimpleSumeSwitch<H, M, D>(
Parser<H, M, D> TopParser,
Pipe<H, M, D> TopPipe,
Deparser<H, M, D> TopDeparser) {
// Top level I/O
packet_in instream;
inout sume_metadata_t sume_metadata;
out D digest_data;
packet_out outstream;

// Connectivity of the architecture
connections {

// TopParser input connections
TopParser.b = instream;
TopParser.sume_metadata = sume_metadata;

// TopPipe <-- TopParser
TopPipe.p = TopParser.p;
TopPipe.user_metadata = TopParser.user_metadata;
TopPipe.digest_data = TopParser.digest_data;
TopPipe.sume_metadata = TopParser.sume_metadata;

// TopDeparser <-- TopPipe
TopDeparser.p = TopPipe.p;
TopDeparser.user_metadata = TopPipe.user_metadata;
TopDeparser.digest_data = TopPipe.digest_data;
TopDeparser.sume_metadata = TopPipe.sume_metadata;

// TopDeparser output connections
digest_data = TopDeparser.digest_data;
sume_metadata = TopDeparser.sume_metadata;
outstream = TopDeparser.b;
             }
                               }
                                 }
