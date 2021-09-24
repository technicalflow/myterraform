# terraform

provider "azurerm" {
  features {

  }
}

variable "kv_id" {
  default = "/subscriptions/kv_id"
}

data "azurerm_key_vault_secret" "kv_secret" {
  name         = "kvpassword"
  key_vault_id = var.kv_id
}

output "KV_Secret_is" {
  value = data.azurerm_key_vault_secret.kv_secret.value
}