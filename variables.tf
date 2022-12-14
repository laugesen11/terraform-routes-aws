#Sets the routes for a specified route table
#REQUIRED INPUTS:
#  - route_table - the name or ID of the route table 
#  - routes      - list of route objects to apply to this route table
#INPUTS FOR DYNAMICALLY RESOLVING RESOURCE IDS
#These are values intended for maps of resources created using for_each loops
#This allows you to resolve them by a user friendly name rather than by ID
#  - route_tables                        : Map of existing route tables
#  - internet_gateways                   : Map of existing internet gateways
#  - egress_only_internet_gateway_routes : Map of existing egress only internet gateways
#  - vpn_gateway_routes                  : Map of existing VPN gateways
#  - nat_gateway_routes                  : Map of existing NAT gateways
#  - vpc_peering_routes                  : Map of existing VPC Peering connections
#  - transit_gateway_routes              : Map of existing Tansit Gateways
#  - vpc_endpoints_routes                : Map of existing VPC Endpoints
#  - carrier_gateway_routes              : Map of existing Carrier Gateways (Wavelength Zones)
#  - network_interface_routes            : Map of existing Network interface IDs
#

variable "route_table" {
  description = "The ID of the route table we're adding a route to"
  type        = string
}

variable "vpc" {
  description = "The name or ID of the VPC"
  type        = string 
  default     = null
}

variable "routes" {
  description = "A list of routes to apply to this route table"
  default     = null
  
  #MUST SET THE VALUE 'type' and "target" or this module will error
  #Can specify three kinds of targets
  #- IPv4 CIDR block            - an IP range in the ##.##.##.##/## format. Most common, identified by '.' in string
  #- IPv6 CIDR block            - an IP range in IPv6 style (####:####:####/##). Identified by the ':' in the string
  #- destination prefix list ID - An AWS managed prefix list ID. Identified by starting with 'pl-'
  #  - target = "<network address we are sending traffic>"
  #Valid values for 'type': 
  #- "internet gateway" - automatically resolves route to internet gateway attached to VPC 
  #- "egress only internet gateway" - automatically resolves route to egress only internet gateway attached to VPC
  #- "vpn gateway" - automatically resolves route to  vpn gateway attached to VPC
  #- "nat gateway" - resolves route to nat gateway specified in "destination". Can use name in module or external id
  #- "vpc peering" - resolves route to vpc peering setup specified in "destination". Can use name in module or external id
  #- "vpc endpoint" - resolves route to vpc endpoint specified in "destination". Can use name in module or external id
  #- "transit gateway" - resolves route to transit gateway in "destination". Must attach transit gateway to VPC. Can use name in module or external id
  #- "carrier gateway" - resolves route to carrier gateway in "destination". Can only use ID
  #- "network interface" - resolves route to network interface in "destination". Can only use ID
  #  - type = <"type of route that we are setting">
  #OTHER options:
  #  - destination="<The name or ID of the destination object. Be careful to match to the type>"
  type = list(map(string))
}

#Input the existing AWS gateways into this module
#Each of these are maps of AWS resources
variable "route_tables" {
  description = "Route tables created in other modules"
  default = {}
  type = map
}

variable "internet_gateways" {
  description = "Internet gateways we want to route to"
  default = {}
  type = map
}

variable "egress_only_internet_gateways" {
  description = "Egress only internet gateways we want to route to"
  default = {}
  type = map
}

variable "vpn_gateways" {
  description = "VPN gateways we want to route to"
  default = {}
  type = map
}

variable "nat_gateways" {
  description = "NAT gateways we want to route to"
  default = {}
  type = map
}

variable "vpc_peering_connections" {
  description = "VPC Peering connections we want to route to"
  default = {}
  type = map
}

variable "vpc_endpoints" {
  description = "VPC endpoints we want to route to"
  default = {}
  type = map
}

variable "transit_gateways" {
  description = "Transit gateways we want to route to"
  default = {}
  type = map
}

