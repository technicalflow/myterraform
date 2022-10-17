# resource "azurerm_resource_group" "rg100" {
#     name = "msarg100"
#     location = var.region.name
# }

# resource "azurerm_virtual_network" "vnet100" {
#   count = length(var.addresses)
#   name = "msavnet100-${count.index + 1}"
#   address_space = [var.addresses[count.index]]
#   location = azurerm_resource_group.rg100.location
#   resource_group_name = azurerm_resource_group.rg100.name
# }

# resource "azurerm_subnet" "subnets" {
#   for_each             = var.subnet_list
#   name                 = "${each.key}-subnet"
#   resource_group_name  = azurerm_resource_group.rg100.name
#   virtual_network_name = azurerm_virtual_network.vnet100[0].name

#   # Size of the subnets is /27 - exactly the size we need for AppService VNET-integration
#   address_prefixes  = [cidrsubnet(var.addresses[2], 8, each.value)]
# }

# # resource "azurerm_subnet" "subnets" {
# #   count = local.count
# #   name                 = "subnet${count.index}"
# #   resource_group_name  = azurerm_resource_group.rg100.name
# #   virtual_network_name = azurerm_virtual_network.vnet100[count.index].name

# #   # Size of the subnets is /27 - exactly the size we need for AppService VNET-integration
# #   address_prefixes  = [cidrsubnet(var.addresses[0], 8, var.subnet_list["front"])]
# #   service_endpoints = ["Microsoft.Web"]

# # }


# locals {
#   count = length(var.addresses)
# }


# variable "address_spaces" {
#     type = map
#     default = {
#         0 = "10.1.0.0/16"
#         1 = "10.2.0.0/16"
#         2 = "10.3.0.0/16"
#     }
# }

# variable "addresses" {
#     type = list
#     default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
# }


# variable "subnet_list" {
#     type = map(number)
#     default = {
#         "front" = 0
#         "api1"  = 1
#         "api2"  = 2
#         "other" = 3
#     }
# }

# variable "region" {
#   type = map(string)
#   default = {
#     short_name = "neu"
#     name = "northeurope"
#   }
# }