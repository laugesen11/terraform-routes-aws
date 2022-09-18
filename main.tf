locals{
  #Get the route table ID
  route_table_id = lookup(var.route_tables,var.route_table,null) != null ? var.route_tables[var.route_table].id : var.route_table
}

#Create internet gateway routes
resource "aws_route" "internet_gateway_route" {
  route_table_id              = local.route_table_id
  for_each                    = var.internet_gateway_routes
  destination_cidr_block      = each.value.cidr_block
  gateway_id                  = each.key
}

#Create egress only internet gateway routes
resource "aws_route" "egress_only_internet_gateway_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.egress_only_internet_gateway_routes
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  egress_only_gateway_id      = each.key
}

#Create vpn gateway routes
resource "aws_route" "vpn_gateway_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.vpn_gateway_routes
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_cidr_block      = each.value.cidr_block
  gateway_id                  = each.key
}

#Create NAT gateway routes
resource "aws_route" "nat_gateway_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.nat_gateway_routes
  destination_cidr_block      = each.value.cidr_block
  nat_gateway_id                  = each.key
}

#Create VPC peering routes
resource "aws_route" "vpc_peering_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.vpc_peering_routes
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_cidr_block      = each.value.cidr_block
  vpc_peering_connection_id   = each.key
}

#Attaches VPC endpoint routes to route table
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.vpc_endpoint_routes
  vpc_endpoint_id             = each.key
}

#Set up Transit gateway routes
#WARNING: Must set up Transit gateway VPC attachment for this to work
resource "aws_route" "transit_gateway_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.transit_gateway_routes
  destination_cidr_block      = each.value.cidr_block
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id
  transit_gateway_id          = each.key
}

#Set up Carrier Gateway routes
resource "aws_route" "carrier_gateway_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.carrier_gateway_routes
  destination_cidr_block      = each.value.cidr_block
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id
  carrier_gateway_id          = each.key
}

#Set up route to Network Interface
resource "aws_route" "network_interface_routes" {
  route_table_id              = local.route_table_id
  for_each                    = var.network_interface_routes
  destination_cidr_block      = each.value.cidr_block
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id
  network_interface_id        = each.key
}
