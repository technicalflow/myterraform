terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}${var.rgname}"
  location = var.location
}
resource "azurerm_recovery_services_vault" "rsv" {
  count               = var.rsv_count
  name                = "${var.prefix}-${var.division}${var.environment}rsv${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = var.rsv_sku
  storage_mode_type   = var.rsv_storage_mode_type
  soft_delete_enabled = false
}

resource "azurerm_backup_policy_vm" "vm-backup-policy-slot1" {
  #   count               = var.create_vm_backup_policy_slot1 == "true" ? var.rsv_count : 0
  count               = var.rsv_count
  name                = "${var.prefix}backuppolicy"
  resource_group_name = azurerm_resource_group.rg1.name
  recovery_vault_name = element(azurerm_recovery_services_vault.rsv.*.name, count.index)
  timezone            = var.time_zone
  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 10
  }
  depends_on = [
    azurerm_recovery_services_vault.rsv
  ]
}

variable "division" {
  default = "IT"
}
variable "environment" {
  default = "dev"
}

variable "location" {
  default = "westus"
}

variable "rgname" {
  default = "rg1"
}

variable "prefix" {
  default = "msatst"
}

variable "time_zone" {
  default = "UTC"
}

variable "rsv_sku" {
  default = "Standard"
}

variable "rsv_storage_mode_type" {
  default = "GeoRedundant"
}

variable "rsv_count" {
  type    = number
  default = 2
}

variable "create_vm_backup_policy_slot1" {
  type    = bool
  default = true
}