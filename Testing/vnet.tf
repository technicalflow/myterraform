terraform {
  required_version = "~> 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {

    }
    azapi = {
      source  = "azure/azapi"
      version = ">=0.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {

}

provider "azapi" {
}


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

variable "tags" {
  type = map(any)
  default = {
    "env"         = "prod"
    "provisioner" = "tf"
    "ng"          = "true"
  }
}
resource "azurerm_resource_group" "rg200" {
  for_each = local.location
  name     = "rg200${local.location[each.key]}${random_string.resource_code[each.key].result}"
  location = each.value
}

resource "random_string" "resource_code" {
  length  = 3
  special = false
  upper   = false
  count   = length(local.location)
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = local.location
  name                = "vnet${local.location[each.key]}${random_string.resource_code[each.key].result}"
  address_space       = [var.addresses[each.key]]
  resource_group_name = azurerm_resource_group.rg200[each.key].name
  location            = each.value
  subnet {
    address_prefix = cidrsubnet(var.addresses[each.key], 8, 4)
    name           = "subnet1"
  }
  tags = var.tags
}