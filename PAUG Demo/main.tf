terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}

resource "azurerm_resource_group" "rg300" {
  location = var.location
  name     = "MEETUPDEMO1"
}
