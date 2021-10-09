terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.80"
    }
  }
}

provider "azurerm" {
  features {

  }
}
# data "azurerm_resource_group" "deploymentRG" {
#   name = "msafssa1"
# }

resource "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}-rg1"
  location = var.location
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}

data "azurerm_virtual_network" "vnet" {
  name = "vnet1"
  resource_group_name = azurerm_resource_group.rg1.name
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_storage_account" "datasa" {
  name                      = "${var.storage_prefix}sa1"
  location                  = var.location
  account_tier              = var.satier
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  account_replication_type  = var.satype[0]
  resource_group_name       = azurerm_resource_group.rg1.name
  allow_blob_public_access  = false
  enable_https_traffic_only = true
  identity {
    type = "SystemAssigned"
  }
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    virtual_network_subnet_ids = [
      data.azurerm_subnet.subnet.id
    ]
    ip_rules = [var.clientaccessip]
  }
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

resource "azurerm_storage_share" "datasa_s1" {
  name                 = "myshare"
  storage_account_name = azurerm_storage_account.datasa.name
}