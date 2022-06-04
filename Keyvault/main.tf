# terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}


provider "azuread" {
}

resource "azurerm_resource_group" "rg1" {
  name     = "msafs-tf-rg1"
  location = "France Central"
}
