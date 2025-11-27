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

provider "azapi" {
}


provider "random" {
}

resource "azurerm_resource_group" "rg300" {
  location = var.location
  name     = "MEETUPDEMO1"
}
