terraform {
  required_providers {
    azurerm = {
      #      version = "2.29.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "stateRG1" {
  name     = "${var.prefix}_state_rg1"
  location = var.location
}

resource "azurerm_storage_account" "datasa" {
  name                     = "${var.prefix}_sa1"
  location                 = var.location
  account_tier             = var.satier
  account_replication_type = var.satype[0]
  resource_group_name      = data.azurerm_resource_group.rgname

  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
  lifecycle {
    prevent_destroy = true
  }
}

data "azurerm_resource_group" "rgname" {

  name = 12
}