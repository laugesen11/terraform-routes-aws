#Sets up local configuration for route tables based on module inputs
#These configurations are then fed into the 'routes' module in main.tf
#The only thing created here is the locals block

locals {
  #Creates map of internet gateway routes from routes with the type of "internet gateway" in variables.tf
  #Can pull the internet gateway ID from internet gateways created in terraform var.internet_gateways, or specify the ID directly. 
  #Uses the vpc variable to see if we can identify the internet gateway using that. Otherwise, we expect the "destination" value to be set with the ID of an IGW
  internet_gateway_routes = {
    for route in var.routes: 
      #If destination is set, we use that value. If not, we try to use vpc to pull the internet gateway
      route.destination != null ? (lookup(var.internet_gateways,route.destination,null) != null ? var.internet_gateways[route.destination].id : route.destination) : var.internet_gateways[var.vpc].id => 
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("^pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "internet gateway"
  }

  #Creates map of egress only internet gateway routes from routes with the type of "egress only internet gateway" in variables.tf
  #Can pull the egress only internet gateway ID from EO internet gateways created in terraform fed into var.egress_only_internet_gateways, or specify the ID directly
  egress_only_internet_gateway_routes = {
    for route in var.routes: 
      #If destination is set, we use that value. If not, we try to use vpc to pull the egress only internet gateway
      route.destination != null ? (lookup(var.egress_only_internet_gateways,route.destination,null) != null ? var.egress_only_internet_gateways[route.destination].id : route.destination) : var.egress_only_internet_gateways[var.vpc].id => 
      {
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("^pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "egress only internet gateway"
    } 

  #Creates map of VPN gateway routes from routes with the type of "vpn gateway" in variables.tf
  #Can pull the VPN gateway ID from VPN gateways created in terraform and fed into var.vpn_gateways, or specify the ID directly
  vpn_gateway_routes = {
    for route in item.routes: 
      #If destination is set, we use that value. If not, we try to use vpc to pull the VPN gateway (Virtual Private Gateway)
      route.destination != null ? (lookup(var.vpn_gateways,route.destination,null) != null ? var.vpn_gateways[route.destination].id : route.destination) : var.vpn_gateways[var.vpc].id => 
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("^pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "vpn gateway"
  }

  #Creates map of NAT gateway routes from routes with the type of "nat gateway" in variables.tf
  #Can pull the NAT gateway ID from NAT gateways created in terraform fed into var.nat_gateways, or specify the ID directly
  nat_gateway_routes = {
    for route in item.routes: 
      #Must set destination in route to either the key of a NAT gateway in the nat_gateway variable, or the ID of a NAT gateway
      lookup(var.nat_gateways,route.destination,null) != null ? var.nat_gateways[route.destination].id : route.destination
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("^pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "nat gateway"
  }

  #Creates map of VPC Peering Connection routes from routes with the type of "vpc peering" in variables.tf
  #Can pull the VPC Peering Connection ID from VPC Peering Connection created in terraform and fed into the var.vpc_peering_connections, or specify the ID directly
  vpc_peering_routes = {
    for route in item.routes: 
      #Must set destination in route to either the key of a VPC peering connection in the var.vpc_peering_connections variable, or the ID of a VPC peering connection
      lookup(var.vpc_peering_connections,route.destination,null) != null ? var.vpc_peering_connections[route.destination].id : route.destination
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "vpc peering"
  }

  #Creates map of VPC Endpoint routes from routes with the type of "vpc endpoint" in variables.tf
  #Can pull the VPC endpoint ID from VPC endpoints created in terraform and fed into var.vpc_endpoints, or specify the ID directly
  vpc_endpoint_routes = {
    for route in item.routes: 
      #Must set destination in route to either the key of a VPC endpoint in the var.vpc_endpoints variable, or the ID of a VPC endpoint
      lookup(var.vpc_endpoints,route.destination,null) != null ? var.vpc_endpoints[route.destination].id : route.destination
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "vpc endpoint"
  }

  #Creates map of Transit Gateway routes from routes with the type of "transit gateway" in variables.tf
  #Can pull the Transit gateway ID from transit gateways created in terraform and fed into var.transit_gateways variable, or specify the ID directly
  transit_gateway_routes = {
    for route in item.routes:
      #Must set destination in route to either the key of a Transit Gateway in the var.transit_gateways variable, or the ID of a Transit Gateway
      lookup(var.transit_gateways,route.destination,null) != null ? var.transit_gateways[route.destination].id : route.destination
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "transit gateway"
  }

  #Creates map of Carrier Gateway routes (Wavelength Zone) from routes with the type of "carrier gateway" in variables.tf
  #Must specify the destination ID directly
  carrier_gateway_routes = {
    for route in item.routes:
      #Must set route.destination 
      route.destination =>
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "carrier gateway"
  }
 
  #Creates a map of network interface routes from routes of type "network interface" in variable.tf
  #Must specify the destination ID directly
  network_interface_routes = {
    for route in item.routes:
      route.destination =>
      {
        "cidr_block"                 = length(regexall("\\.",route.target)) > 0 ? route.target : null
        "ipv6_cidr_block"            = length(regexall(":",route.target)) > 0 ? route.target : null
        "destination_prefix_list_id" = length(regexall("pl-",route.target)) > 0 ? route.target : null
      } if lower(route.type) == "network interface"
  }
}

