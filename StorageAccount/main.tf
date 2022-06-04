terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
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

data "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}_rg1"
}
# resource "azurerm_resource_group" "rg1" {
#   name     = "${var.prefix}_rg1"
#   location = var.location
#   tags = {
#     environment = "Dev/Test"
#     provisioner = "Terraform"
#   }
# }

data "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}_vnet1"
  resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_subnet" "subnet" {
  name                 = "mysubnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg1.name
}

resource "azurerm_storage_account" "datasa" {
  name                      = "${var.storage_prefix}sa1"
  location                  = var.location
  account_tier              = var.satier
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  account_replication_type  = var.satype[0]
  resource_group_name       = data.azurerm_resource_group.rg1.name
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
    ip_rules = var.clientaccessip
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
  quota = 5120
}

resource "azurerm_private_endpoint" "pe-endpoint" {
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name
  name                = "pe1"
  subnet_id           = data.azurerm_subnet.subnet.id
  private_service_connection {
    name                           = azurerm_storage_account.datasa.name
    private_connection_resource_id = azurerm_storage_account.datasa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}