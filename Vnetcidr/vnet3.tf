resource "azurerm_resource_group" "rg100" {
  name     = "msarg100"
  location = var.region.name
}

resource "azurerm_virtual_network" "vnet" {
  for_each = var.address_spaces
  name = each.key
  location = azurerm_resource_group.rg100.location
  resource_group_name = azurerm_resource_group.rg100.name
  address_space = [each.value]
}

# resource "azurerm_virtual_network" "vnet100" {
#   count               = length(var.addresses)
#   name                = "msavnet100-${count.index + 1}"
#   address_space       = [var.addresses[count.index]]
#   location            = azurerm_resource_group.rg100.location
#   resource_group_name = azurerm_resource_group.rg100.name
# }

resource "azurerm_subnet" "newsubnet" {
  for_each = var.subnet_list
  name = "subnet-${each.key}"
  resource_group_name = azurerm_resource_group.rg100.name
#   virtual_network_name = [for k, v in var.address_spaces : "${k}"]
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes = [cidrsubnet(var.addresses[0], 8, each.value)]
#   address_prefixes = [cidrsubnet(var.address_spacess[var.region.short_name], 8, each.value)]
}

# resource "azurerm_subnet" "subnets" {
#   for_each             = azurerm_virtual_network.vnet
#   name                 = "subnet-${each.key}"
#   resource_group_name  = azurerm_resource_group.rg100.name
#   virtual_network_name = each.value.name

#   # address_prefixes  = [cidrsubnet(var.addresses[each.key], 8, 4)]
#   # address_prefixes  = each.value.address_space[*]
#   address_prefixes = each.value.address_space
# }

# output "vnetoutput" {
#   value = [
#     for vnet in azurerm_virtual_network.vnet : azurerm_virtual_network.vnet[0].subnet
#   ]
# }

# output "vnetoutput1" {
#   value = [
#     for vnet in azurerm_virtual_network.vnet : azurerm_virtual_network.vnet[0].address_space
#   ]
# }


# resource "azurerm_subnet" "subnets" {
#   for_each             = var.address_spaces
#   name                 = "subnet${each.key}"
#   resource_group_name  = azurerm_resource_group.rg100.name
#   virtual_network_name = azurerm_virtual_network.vnet[each.key].name

#   address_prefixes  = [cidrsubnet(each.value, 8, 4)]
# #   address_prefixes  = [tostring(var.address_spaces[each.key])]

# }


locals {
  count = length(var.addresses)
}

variable "address_spaces" {
  type = map(any)
  default = {
    "msavnet10" = "10.1.0.0/16"
    "msavnet11" = "10.2.0.0/16"
    "msavnet12" = "10.3.0.0/16"
  }
}


variable "address_spacess" {
  type = map(any)
  default = {
    "neu" = "10.1.0.0/16"
    "frc" = "10.2.0.0/16"
    "weu" = "10.3.0.0/16"
  }
}

variable "addresses" {
  type    = list(any)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}


variable "subnet_list" {
  type = map(number)
  default = {
    "front" = 0
    "api1"  = 1
    "api2"  = 2
    "other" = 3
  }
}

variable "region" {
  type = map(string)
  default = {
    short_name = "neu"
    name       = "northeurope"
  }
}