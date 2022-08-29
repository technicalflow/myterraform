resource "random_integer" "priority" {
  min = 100
  max = 120
}

resource "random_password" "password" {
  count            = var.admin_password == null && var.disable_password_authentication == false ? 1 : 0
  length           = 16
  min_numeric      = 3
  special          = true
  override_special = "\\"
}


locals {
  loc = var.location == "francecentral" ? "frc" : var.location == "northeurope" ? "neu" : var.location == "germanyestcentral" ? "gwc" : var.location == "eastus" ? "eus" : var.location
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}_${local.loc}_${var.provisioner}_rg${random_integer.priority.result}"
  location = var.location
  tags     = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
