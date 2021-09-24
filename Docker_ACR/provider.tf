terraform {
  required_version = "~>1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

# Reference to the current subscription.  Used when creating role assignments
data "azurerm_subscription" "current" {}

resource "random_string" "rgname" {
 length  = 1
 special = false
 upper   = false
 lower = false
 number  = true
}
resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg${random_string.rgname}"
  location = var.location
  depends_on = [
    random_string.rgname
  ]
}

