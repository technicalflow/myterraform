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
data "azurerm_resource_group" "deploymentRG" {
  name = "msafssa1"
}

resource "azurerm_resource_group" "stateRG1" {
  name     = "${var.prefix}_state_rg1"
  location = var.location
}

resource "azurerm_storage_account" "datasa" {
  name                     = "${var.prefix}_sa1"
  location                 = var.location
  account_tier             = var.satier
  account_kind             = "StorageV2"
  account_replication_type = var.satype[0]
  resource_group_name      = data.azurerm_resource_group.deploymentRG

  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
  lifecycle {
    prevent_destroy = true
  }

}
resource "azurerm_storage_container" "datasa_c1" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.datasa.name
  container_access_type = "private"
}
