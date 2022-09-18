output "internet_gateway_routes" {
  value = aws_route.internet_gateway_route
}

output "egress_only_internet_gateway_routes" {
  value = aws_route.egress_only_internet_gateway_routes
}

output "vpn_gateway_routes" {
  value = aws_route.vpn_gateway_routes
}

output "nat_gateway_routes" {
  value = aws_route.nat_gateway_routes
}

output "vpc_peering_routes" {
  value = aws_route.vpc_peering_routes
}

output "vpc_endpoint_routes" {
  value = aws_vpc_endpoint_route_table_association.vpc_endpoint_routes
}

output "transit_gateway_routes" {
  value = aws_route.transit_gateway_routes
}

output "carrier_gateway_routes" {
  value = aws_route.carrier_gateway_routes
}

output "network_interface_routes" {
  value = aws_route.network_interface_routes
}
