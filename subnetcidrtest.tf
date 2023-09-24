resource "azurerm_subnet" "subnets" {
  for_each             = local.subnet_list
  name                 = "${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  # Size of the subnets is /27 - exactly the size we need for AppService VNET-integration
  address_prefixes  = [cidrsubnet(var.address_spaces[var.location_short], 4, each.value)]

  # service_endpoints = ["Microsoft.Web"]

  # # Delegation to enable app services to join the subnet later
  # delegation {
  #   name = "appservicedelegation"
  #   service_delegation {
  #     name    = "Microsoft.Web/serverFarms"
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  #   }
  # }
}

location_short = "neu"

address_spaces = {
  "neu" = "172.10.1.0/23"
  "weu" = "172.10.3.0/23"
  "uks" = "172.20.28.0/23"
}
type = map(string)

subnet_list = {
  "front" = 0
  "api1"  = 1
  "api2"  = 2
  "other" = 3
}
type = map(number)

Can work with count
count = length(var.address_spaces)

In short: cidrsubnet(iprange, newbits, netnum) where:

iprange = CIDR of the virtual network
172.10.1.0/23
newbits = the difference between subnet mask and network mask
27 - 23 = 4
netnum = practically the subnet index (see the ipcalc output above)
0 = 172.10.0.0/27
1 = 172.10.0.32/27
2 = 172.10.0.64/27
3 = 172.10.0.96/27


### Cidr Host
> cidrhost("10.12.112.0/20", 16)
10.12.112.16
> cidrhost("10.12.112.0/20", 268)
10.12.113.12
> cidrhost("fd00:fd12:3456:7890:00a2::/72", 34)
fd00:fd12:3456:7890::22

