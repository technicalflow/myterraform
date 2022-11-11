locals {
  location = {
    0 = "francecentral"
    1 = "westeurope"
    2 = "francecentral"
  }
}

variable "addresses" {
  type    = list(any)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}

variable "vnetname" {
  type    = list(any)
  default = ["hub", "spoke1", "spoke2"]
}

variable "tags" {
  type = map(any)
  default = {
    "env"         = "prod"
    "provisioner" = "tf"
    "ng"          = "true"
  }
}

resource "azurerm_resource_group" "rg300" {
  location = local.location[0]
  name = "rg300"
  
}


resource "azurerm_virtual_network" "vnet" {
  for_each            = local.location
  name                = "${var.vnetname[each.key]}_vnet_${local.location[each.key]}"
  address_space       = [var.addresses[each.key]]
  resource_group_name = azurerm_resource_group.rg300.name
  location            = each.value
  subnet {
    address_prefix = cidrsubnet(var.addresses[each.key], 8, 1)
    name           = "subnet1"
  }
  tags = var.tags
}