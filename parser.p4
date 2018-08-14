


parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet_);
    return ingress;
}

