terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~>0.19.1"
    }
    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "2.20.2"
    # }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}
