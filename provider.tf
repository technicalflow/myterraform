terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "<storage_account_name>"
        container_name       = "tfstate"
        key                  = "terraform.tfstate" ## name of the blob - set folders with dev/app.tfstate
    }

}

provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "state-demo-secure" {
#   name     = "state-demo"
#   location = "eastus"
# }

# Store backend for every environment separately 
# For dev –> terraform init -backend-config="dev/backend.tfvars".
# For Production –> terraform init -backend-config="production/backend.tfvars".